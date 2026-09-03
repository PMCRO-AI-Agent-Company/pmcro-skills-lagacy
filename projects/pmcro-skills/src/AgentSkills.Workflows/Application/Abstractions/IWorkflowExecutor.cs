using AgentSkills.Workflows.Domain.Runs;
using AgentSkills.Workflows.Domain.Workflows;

namespace AgentSkills.Workflows.Application.Abstractions;

/// <summary>
/// Drives a workflow's actual execution (start/resume/cancel). Distinct
/// from persistence, which goes through the shared IUnitOfWork /
/// IRepository&lt;WorkflowRun, Guid&gt; abstractions instead of a bespoke
/// store interface.
/// </summary>
public interface IWorkflowExecutor
{
    Task<WorkflowRun> StartAsync(WorkflowId id, CancellationToken ct = default);
    Task ResumeAsync(Guid runId, CancellationToken ct = default);
    Task CancelAsync(Guid runId, string reason, CancellationToken ct = default);
}
