using AgentSkills.Application.Abstractions;
using AgentSkills.Workflows.Application.Abstractions;
using AgentSkills.Workflows.Domain.Runs;

namespace AgentSkills.Workflows.Application.UseCases;

/// <summary>
/// Starts a workflow run and persists it via the shared IUnitOfWork /
/// IRepository&lt;WorkflowRun, Guid&gt; pattern (AgentSkills.Application.
/// Abstractions) rather than a bespoke store — no reason to duplicate the
/// generic repository contract for one aggregate.
/// </summary>
public sealed class RunWorkflowCommand(IWorkflowExecutor executor, IUnitOfWork unitOfWork)
{
    public async Task<WorkflowRun> HandleAsync(RunWorkflowRequest request, CancellationToken ct = default)
    {
        var run = await executor.StartAsync(request.WorkflowId, ct);

        unitOfWork.Repository<WorkflowRun, Guid>().Add(run);
        await unitOfWork.SaveChangesAsync(ct);

        return run;
    }
}
