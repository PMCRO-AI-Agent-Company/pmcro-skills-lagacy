// AGENTSKILLS — MCP.TERMINAL
// File   : Tools/TerminalTools.cs
// Rule   : colony-laws.md — Mutation & trails: "TYPE1 (state-changing)
//          mutations require explicit human approval before execution."
//          RunCommand/RunScript/KillProcess below are TYPE1: they only
//          ever return TYPE1_PENDING. Only the corresponding Execute*
//          method actually runs anything, and per colony-laws.md that
//          method must only be invoked by the Orchestrator after HIL
//          approval is recorded in the active trail.

using System.ComponentModel;
using System.Text.Json;
using AgentSkills.Mcp.Terminal.Configuration;
using ModelContextProtocol.Server;

namespace AgentSkills.Mcp.Terminal.Tools;

[McpServerToolType]
public sealed class TerminalTools(TerminalConfig config)
{
    private static readonly JsonSerializerOptions JsonOptions =
        new() { PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower };

    private static readonly string[] Slots = ["terminal-1", "terminal-2", "terminal-3", "terminal-4"];
    private static readonly string[] Type1Tools = ["RunCommand", "RunScript", "KillProcess"];
    private static readonly string[] Type2Tools = ["GetTerminalStatus", "GetEnvironment", "Which"];

    private static string Result(bool success, object? data = null, string? error = null) =>
        JsonSerializer.Serialize(new { success, data, error }, JsonOptions);

    private static string? NormalizeSlot(string? slot)
    {
        if (string.IsNullOrWhiteSpace(slot)) return slot;
        var trimmed = slot.Trim();
        if (Slots.Contains(trimmed)) return trimmed;
        if (int.TryParse(trimmed, out var n) && n is >= 1 and <= 4) return $"terminal-{n}";
        var lowered = trimmed.ToLowerInvariant();
        if (lowered.StartsWith("terminal")
            && int.TryParse(lowered.Replace("terminal", "").Replace("-", "").Replace("_", ""), out var m)
            && m is >= 1 and <= 4)
        {
            return $"terminal-{m}";
        }
        return trimmed;
    }

    private static string Pending(string tool, object requestedAction) => JsonSerializer.Serialize(new
    {
        success = false,
        data = (object?)null,
        error = "TYPE1_PENDING",
        type1_pending = new
        {
            tool,
            requested_action = requestedAction,
            note = "TYPE1 tools require explicit human approval and are dispatched only by the Orchestrator (colony-laws.md).",
        },
    }, JsonOptions);

    [McpServerTool(Name = "GetTerminalStatus")]
    [Description("Returns terminal MCP status, limits, slots, and TYPE1/TYPE2 boundaries.")]
    public string GetTerminalStatus()
    {
        try
        {
            var root = config.ResolveAndValidatePath(null);
            return Result(true, new
            {
                working_root = root,
                command_timeout_seconds = config.CommandTimeoutSeconds,
                max_output_bytes = config.MaxOutputBytes,
                slots = Slots,
                type1_tools = Type1Tools,
                type2_tools = Type2Tools,
            });
        }
        catch (Exception ex) { return Result(false, error: ex.Message); }
    }

    [McpServerTool(Name = "GetEnvironment")]
    [Description("Returns selected environment variables visible to terminal MCP.")]
    public string GetEnvironment(string[]? names = null)
    {
        try
        {
            string[] defaults = ["PATH", "DOTNET_ROOT", "DOTNET_VERSION", "ASPNETCORE_ENVIRONMENT"];
            var requested = names is { Length: > 0 } ? names : defaults;
            return Result(true, new { variables = requested.ToDictionary(n => n, Environment.GetEnvironmentVariable) });
        }
        catch (Exception ex) { return Result(false, error: ex.Message); }
    }

    [McpServerTool(Name = "Which")]
    [Description("Locates an executable on PATH without executing it.")]
    public string Which(string command)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(command))
                return Result(false, error: "command must be a non-empty executable name");

            var path = Environment.GetEnvironmentVariable("PATH") ?? string.Empty;
            var separators = OperatingSystem.IsWindows() ? new[] { ';' } : new[] { ':' };
            var extensions = OperatingSystem.IsWindows()
                ? (Environment.GetEnvironmentVariable("PATHEXT") ?? ".EXE;.CMD;.BAT;.COM").Split(';')
                : [""];

            foreach (var dir in path.Split(separators, StringSplitOptions.RemoveEmptyEntries))
            {
                foreach (var ext in extensions)
                {
                    var candidate = Path.Combine(dir, command + ext);
                    if (File.Exists(candidate)) return Result(true, new { found = true, path = candidate });
                }
            }

            return Result(true, new { found = false, path = (string?)null });
        }
        catch (Exception ex) { return Result(false, error: ex.Message); }
    }

    [McpServerTool(Name = "RunCommand")]
    [Description("TYPE1: requests command execution. Always returns TYPE1_PENDING; requires HIL approval before ExecuteRunCommand.")]
    public string RunCommand(string command, string? args = null, string? workingDirectory = null, string? slot = null)
    {
        var normalized = NormalizeSlot(slot);
        return Pending("RunCommand", new
        {
            command,
            args,
            working_directory = workingDirectory,
            slot = normalized ?? "(unassigned)",
        });
    }

    [McpServerTool(Name = "ExecuteRunCommand")]
    [Description("ORCHESTRATOR-ONLY: executes a command after HIL approval.")]
    public async Task<string> ExecuteRunCommand(string command, string? args = null, string? workingDirectory = null, string? slot = null)
    {
        try
        {
            var dir = config.ResolveAndValidatePath(workingDirectory);
            slot = NormalizeSlot(slot);
            if (slot is not null && !Slots.Contains(slot))
                return Result(false, error: $"Unknown slot '{slot}'. Valid slots: {string.Join(", ", Slots)}");

            var psi = new System.Diagnostics.ProcessStartInfo
            {
                FileName = command,
                Arguments = args ?? string.Empty,
                WorkingDirectory = dir,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            };

            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(config.CommandTimeoutSeconds));
            using var process = new System.Diagnostics.Process { StartInfo = psi };
            var sw = System.Diagnostics.Stopwatch.StartNew();
            process.Start();
            var stdoutTask = process.StandardOutput.ReadToEndAsync();
            var stderrTask = process.StandardError.ReadToEndAsync();
            await process.WaitForExitAsync(cts.Token);
            sw.Stop();
            var stdout = await stdoutTask;
            var stderr = await stderrTask;

            if (stdout.Length + stderr.Length > config.MaxOutputBytes)
            {
                var budget = config.MaxOutputBytes / 2;
                stdout = stdout.Length > budget ? stdout[..budget] + "...[truncated]" : stdout;
                stderr = stderr.Length > budget ? stderr[..budget] + "...[truncated]" : stderr;
            }

            return Result(process.ExitCode == 0, new
            {
                exit_code = process.ExitCode,
                stdout = stdout.TrimEnd(),
                stderr = stderr.TrimEnd(),
                elapsed_ms = sw.ElapsedMilliseconds,
                working_directory = dir,
                slot = slot ?? "(unassigned)",
            });
        }
        catch (OperationCanceledException) { return Result(false, error: $"Command timed out after {config.CommandTimeoutSeconds}s"); }
        catch (Exception ex) { return Result(false, error: ex.Message); }
    }

    [McpServerTool(Name = "RunScript")]
    [Description("TYPE1: requests script execution. Always returns TYPE1_PENDING; requires HIL approval before ExecuteRunScript.")]
    public string RunScript(string scriptPath, string? args = null, string? workingDirectory = null, string? slot = null)
    {
        var normalized = NormalizeSlot(slot);
        return Pending("RunScript", new
        {
            script_path = scriptPath,
            args,
            working_directory = workingDirectory,
            slot = normalized ?? "(unassigned)",
        });
    }

    [McpServerTool(Name = "ExecuteRunScript")]
    [Description("ORCHESTRATOR-ONLY: executes a script after HIL approval.")]
    public async Task<string> ExecuteRunScript(string scriptPath, string? args = null, string? workingDirectory = null, string? slot = null)
    {
        try
        {
            var script = config.ResolveAndValidatePath(scriptPath);
            var dir = config.ResolveAndValidatePath(workingDirectory);
            slot = NormalizeSlot(slot);
            if (slot is not null && !Slots.Contains(slot))
                return Result(false, error: $"Unknown slot '{slot}'. Valid slots: {string.Join(", ", Slots)}");
            if (!File.Exists(script))
                return Result(false, error: $"Script not found: {script}");

            var ext = Path.GetExtension(script).ToLowerInvariant();
            var (interpreter, interpreterArgs) = ext switch
            {
                ".ps1" => ("pwsh", $"-NonInteractive -File \"{script}\" {args ?? string.Empty}"),
                ".sh" => ("bash", $"\"{script}\" {args ?? string.Empty}"),
                ".bat" or ".cmd" => ("cmd.exe", $"/c \"{script}\" {args ?? string.Empty}"),
                _ => (script, args ?? string.Empty),
            };

            var psi = new System.Diagnostics.ProcessStartInfo
            {
                FileName = interpreter,
                Arguments = interpreterArgs,
                WorkingDirectory = dir,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            };

            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(config.CommandTimeoutSeconds));
            using var process = new System.Diagnostics.Process { StartInfo = psi };
            var sw = System.Diagnostics.Stopwatch.StartNew();
            process.Start();
            var stdoutTask = process.StandardOutput.ReadToEndAsync();
            var stderrTask = process.StandardError.ReadToEndAsync();
            await process.WaitForExitAsync(cts.Token);
            sw.Stop();
            var stdout = await stdoutTask;
            var stderr = await stderrTask;
            if (stdout.Length + stderr.Length > config.MaxOutputBytes)
            {
                var budget = config.MaxOutputBytes / 2;
                stdout = stdout.Length > budget ? stdout[..budget] + "...[truncated]" : stdout;
                stderr = stderr.Length > budget ? stderr[..budget] + "...[truncated]" : stderr;
            }

            return Result(process.ExitCode == 0, new
            {
                exit_code = process.ExitCode,
                stdout = stdout.TrimEnd(),
                stderr = stderr.TrimEnd(),
                elapsed_ms = sw.ElapsedMilliseconds,
                script_path = script,
                working_directory = dir,
                slot = slot ?? "(unassigned)",
            });
        }
        catch (OperationCanceledException)
        {
            return Result(false, error: $"Script timed out after {config.CommandTimeoutSeconds}s");
        }
        catch (Exception ex) { return Result(false, error: ex.Message); }
    }

    [McpServerTool(Name = "KillProcess")]
    [Description("TYPE1: requests process termination. Always returns TYPE1_PENDING; requires HIL approval.")]
    public string KillProcess(int processId, string? slot = null)
    {
        var normalized = NormalizeSlot(slot);
        return Pending("KillProcess", new { process_id = processId, slot = normalized ?? "(unassigned)" });
    }

    [McpServerTool(Name = "ExecuteKillProcess")]
    [Description("ORCHESTRATOR-ONLY: terminates a process after HIL approval.")]
    public string ExecuteKillProcess(int processId, string? slot = null)
    {
        try
        {
            slot = NormalizeSlot(slot);
            if (slot is not null && !Slots.Contains(slot))
                return Result(false, error: $"Unknown slot '{slot}'. Valid slots: {string.Join(", ", Slots)}");

            using var process = System.Diagnostics.Process.GetProcessById(processId);
            process.Kill(entireProcessTree: true);
            return Result(true, new { process_id = processId, killed = true, slot = slot ?? "(unassigned)" });
        }
        catch (ArgumentException) { return Result(false, error: $"Process not found: {processId}"); }
        catch (Exception ex) { return Result(false, error: ex.Message); }
    }
}
