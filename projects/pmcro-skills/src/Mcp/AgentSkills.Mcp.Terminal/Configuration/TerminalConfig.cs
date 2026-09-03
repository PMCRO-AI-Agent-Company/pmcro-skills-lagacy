// PROJECTNAME — MCP.TERMINAL
// File     : Configuration/TerminalConfig.cs
// Purpose  : Sandbox enforcer & command execution limits.
// Law ref  : colony-laws.md — Portability (W-PORTABILITY-001: no literal
//            drive-letter paths in code/config; resolve relative to repo
//            root or via environment). ResolveAndValidatePath below is the
//            runtime enforcement of that rule for terminal commands.
//
// Constructed directly in Program.cs via object-initializer syntax, so all
// three properties must have public setters.

namespace AgentSkills.Mcp.Terminal.Configuration;

/// <summary>
/// Defines the boundaries and limits for terminal command execution.
/// TYPE1 tools (RunCommand, RunScript, KillProcess) and TYPE2 tools
/// (GetTerminalStatus, GetEnvironment, Which) read these limits.
/// </summary>
public sealed class TerminalConfig
{
    /// <summary>
    /// Absolute path terminal commands are rooted at by default. Aspire
    /// injects this via Parameters:working-root; falls back to two levels
    /// above ContentRootPath in dev.
    /// </summary>
    public required string WorkingRoot { get; set; }

    /// <summary>Max wall-clock seconds before a command is treated as timed out.</summary>
    public int CommandTimeoutSeconds { get; set; } = 30;

    /// <summary>Max combined stdout+stderr bytes captured before truncation.</summary>
    public int MaxOutputBytes { get; set; } = 65536;

    /// <summary>
    /// Safely resolves a relative path against WorkingRoot.
    /// W-PORTABILITY-001: throws if the resolved path would escape
    /// WorkingRoot.
    /// </summary>
    /// <param name="relativePath">
    /// A path relative to WorkingRoot. Null or empty resolves to WorkingRoot
    /// itself.
    /// </param>
    /// <returns>The verified, absolute directory or file path.</returns>
    /// <exception cref="UnauthorizedAccessException">
    /// If the path attempts to escape WorkingRoot.
    /// </exception>
    public string ResolveAndValidatePath(string? relativePath)
    {
        var root = Path.GetFullPath(WorkingRoot);

        if (string.IsNullOrWhiteSpace(relativePath))
        {
            return root;
        }

        relativePath = relativePath.TrimStart('/', '\\');

        if (string.IsNullOrWhiteSpace(relativePath))
        {
            return root;
        }

        var combined = Path.Combine(root, relativePath);
        var absolute = Path.GetFullPath(combined);

        var rootPrefix = root.EndsWith(Path.DirectorySeparatorChar.ToString())
            ? root
            : root + Path.DirectorySeparatorChar;

        var absWithSlash = absolute.EndsWith(Path.DirectorySeparatorChar.ToString())
            ? absolute
            : absolute + Path.DirectorySeparatorChar;

        if (!absWithSlash.StartsWith(rootPrefix, StringComparison.OrdinalIgnoreCase)
            && !string.Equals(absolute, root, StringComparison.OrdinalIgnoreCase))
        {
            throw new UnauthorizedAccessException(
                $"W-PORTABILITY-001 violation: path traversal attempt detected. " +
                $"The path '{relativePath}' resolves outside WorkingRoot ('{root}').");
        }

        return absolute;
    }
}
