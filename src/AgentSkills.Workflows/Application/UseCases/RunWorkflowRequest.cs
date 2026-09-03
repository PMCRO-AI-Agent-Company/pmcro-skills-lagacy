using AgentSkills.Workflows.Domain.Workflows;

namespace AgentSkills.Workflows.Application.UseCases;

public sealed record RunWorkflowRequest(WorkflowId WorkflowId);
