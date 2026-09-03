namespace AgentSkills.Application.Sessions.Commands.SeedIntent;

public sealed record SeedIntentCommand(string RawIntent, string RequestedBy);

public sealed record SeedIntentResult(
    Guid SessionId,
    string RawIntent,
    string RequestedBy,
    string PlanArtifactPath,
    string Status);
