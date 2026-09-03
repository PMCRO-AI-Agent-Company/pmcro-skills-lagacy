using AgentSkills.Application.Abstractions.Sessions;
using AgentSkills.Domain.Sessions;
using System.Text.Json;

namespace AgentSkills.Infrastructure.Persistence.Pmcro;

public sealed class FileSessionRepository(string repoRoot) : ISessionRepository
{
    private string PathFor(Guid id) => System.IO.Path.Combine(repoRoot, ".pmcro", "sessions", $"{id:N}.json");

    public async Task SaveAsync(Session session, CancellationToken ct = default)
    {
        var path = PathFor(session.Id);
        Directory.CreateDirectory(System.IO.Path.GetDirectoryName(path)!);
        await File.WriteAllTextAsync(path, JsonSerializer.Serialize(session), ct);
        var statePath = System.IO.Path.Combine(repoRoot, ".pmcro", "session-state.md");
        var state = $"# Session State\n\n- session_id: `{session.Id:N}`\n- status: `{session.Status}`\n- active_role: `{session.ActiveRole}`\n- requested_by: `{session.RequestedBy}`\n- seed_intent: {session.RawIntent}\n- updated_at_utc: `{DateTimeOffset.UtcNow:O}`\n";
        await File.WriteAllTextAsync(statePath, state, ct);
    }

    public async Task<Session?> GetAsync(Guid id, CancellationToken ct = default)
    {
        var path = PathFor(id);
        if (!File.Exists(path)) return null;
        var json = await File.ReadAllTextAsync(path, ct);
        return JsonSerializer.Deserialize<Session>(json);
    }

    public async Task<Session?> GetActiveAsync(CancellationToken ct = default)
    {
        var dir = System.IO.Path.Combine(repoRoot, ".pmcro", "sessions");
        if (!Directory.Exists(dir)) return null;
        foreach (var file in Directory.EnumerateFiles(dir, "*.json"))
        {
            var json = await File.ReadAllTextAsync(file, ct);
            var session = JsonSerializer.Deserialize<Session>(json);
            if (session?.Status == SessionStatus.Active) return session;
        }
        return null;
    }
}
