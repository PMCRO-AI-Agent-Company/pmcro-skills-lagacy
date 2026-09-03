using AgentSkills.Application.Abstractions.Sessions;
using AgentSkills.Application.Sessions.Commands.SeedIntent;
using System.Text.Json;

namespace AgentSkills.Infrastructure.Persistence.Pmcro;

public sealed class FileTrailEventStore(string repoRoot) : ITrailEventStore
{
    public async Task AppendAsync(IntentSeededEvent @event, CancellationToken ct = default)
    {
        var dir = System.IO.Path.Combine(repoRoot, ".pmcro", "trails");
        Directory.CreateDirectory(dir);
        var path = System.IO.Path.Combine(dir, $"{@event.SessionId:N}.events.jsonl");
        var line = JsonSerializer.Serialize(@event) + Environment.NewLine;
        await File.AppendAllTextAsync(path, line, ct);
    }
}
