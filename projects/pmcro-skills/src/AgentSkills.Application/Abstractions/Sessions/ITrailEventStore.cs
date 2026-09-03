using AgentSkills.Application.Sessions.Commands.SeedIntent;

namespace AgentSkills.Application.Abstractions.Sessions;

public interface ITrailEventStore
{
    Task AppendAsync(IntentSeededEvent @event, CancellationToken ct = default);
}
