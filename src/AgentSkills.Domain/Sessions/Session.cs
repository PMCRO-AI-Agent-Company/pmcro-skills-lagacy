namespace AgentSkills.Domain.Sessions;

public enum SessionRole { Orchestrator, Planner, Maker, Checker, Reflector }
public enum SessionStatus { Active, Completed, Blocked }

public sealed class Session
{
    [System.Text.Json.Serialization.JsonConstructor]
    public Session(Guid id, string rawIntent, string requestedBy,
        SessionRole activeRole, SessionRole? previousRole, SessionStatus status,
        DateTimeOffset createdAtUtc)
    {
        Id = id;
        RawIntent = rawIntent;
        RequestedBy = requestedBy;
        ActiveRole = activeRole;
        PreviousRole = previousRole;
        Status = status;
        CreatedAtUtc = createdAtUtc;
    }

    public Guid Id { get; }
    public string RawIntent { get; }
    public string RequestedBy { get; }
    public SessionRole ActiveRole { get; private set; }
    public SessionRole? PreviousRole { get; private set; }
    public SessionStatus Status { get; private set; }
    public DateTimeOffset CreatedAtUtc { get; }

    public static Session Create(string rawIntent, string requestedBy)
    {
        if (string.IsNullOrWhiteSpace(rawIntent))
            throw new ArgumentException("Raw intent is required.", nameof(rawIntent));
        if (string.IsNullOrWhiteSpace(requestedBy))
            throw new ArgumentException("Requested by is required.", nameof(requestedBy));
        return new Session(Guid.NewGuid(), rawIntent.Trim(), requestedBy.Trim(),
            SessionRole.Orchestrator, null, SessionStatus.Active, DateTimeOffset.UtcNow);
    }

    public void AdvanceTo(SessionRole nextRole)
    {
        if (Status != SessionStatus.Active)
            throw new InvalidOperationException("Only active sessions can advance.");
        if (nextRole == ActiveRole)
            throw new InvalidOperationException("Session cannot transition to the same role.");
        if (ActiveRole == SessionRole.Maker && nextRole != SessionRole.Checker)
            throw new InvalidOperationException("Maker must hand off to Checker; Maker cannot self-approve.");
        if (ActiveRole == SessionRole.Checker && nextRole != SessionRole.Reflector)
            throw new InvalidOperationException("Checker must hand off to Reflector.");
        PreviousRole = ActiveRole;
        ActiveRole = nextRole;
    }
}
