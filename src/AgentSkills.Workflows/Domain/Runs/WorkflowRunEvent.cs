namespace AgentSkills.Workflows.Domain.Runs;

/// <summary>Append-only lifecycle event on a <see cref="WorkflowRun"/>.</summary>
public sealed record WorkflowRunEvent(string EventType, DateTimeOffset OccurredAt);
