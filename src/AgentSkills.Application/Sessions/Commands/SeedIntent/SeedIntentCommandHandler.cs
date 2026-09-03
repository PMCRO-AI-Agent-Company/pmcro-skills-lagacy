using AgentSkills.Application.Abstractions.Sessions;
using AgentSkills.Domain.Sessions;

namespace AgentSkills.Application.Sessions.Commands.SeedIntent;

public sealed class SeedIntentCommandHandler(ISessionRepository sessions, ITrailEventStore trails)
{
    public async Task<SeedIntentResult> Handle(SeedIntentCommand command, CancellationToken ct = default)
    {
        var session = Session.Create(command.RawIntent, command.RequestedBy);
        await sessions.SaveAsync(session, ct);
        await trails.AppendAsync(new IntentSeededEvent(
            session.Id, session.RawIntent, session.RequestedBy, session.CreatedAtUtc), ct);

        return new SeedIntentResult(
            session.Id,
            session.RawIntent,
            session.RequestedBy,
            $".pmcro/trails/{session.Id:N}.events.jsonl",
            session.Status.ToString());
    }
}

public sealed record IntentSeededEvent(
    Guid SessionId,
    string RawIntent,
    string RequestedBy,
    DateTimeOffset OccurredAtUtc);
