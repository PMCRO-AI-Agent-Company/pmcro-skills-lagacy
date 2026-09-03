using AgentSkills.Application.Abstractions;
using AgentSkills.Infrastructure.Repositories;
using AgentSkills.Workflows.Application.Abstractions;
using AgentSkills.Workflows.Application.UseCases;
using AgentSkills.Workflows.Domain.Runs;
using AgentSkills.Workflows.Domain.Workflows;
using Xunit;

namespace AgentSkills.Workflows.Tests;

public sealed class WorkflowApplicationTests
{
    [Fact]
    public async Task RunWorkflowCommand_starts_and_saves_run()
    {
        var executor = new FakeExecutor();
        IUnitOfWork unitOfWork = new InMemoryUnitOfWork();
        var command = new RunWorkflowCommand(executor, unitOfWork);
        var ct = TestContext.Current.CancellationToken;

        var run = await command.HandleAsync(new RunWorkflowRequest(new WorkflowId("sample")), ct);

        Assert.Equal(RunStatus.Running, run.Status);

        var saved = await unitOfWork.Repository<WorkflowRun, Guid>().FindAsync(run.Id, ct);
        Assert.Same(run, saved);
    }

    private sealed class FakeExecutor : IWorkflowExecutor
    {
        public Task<WorkflowRun> StartAsync(WorkflowId id, CancellationToken ct = default)
        {
            var run = new WorkflowRun(id);
            run.Start();
            return Task.FromResult(run);
        }

        public Task ResumeAsync(Guid runId, CancellationToken ct = default) => Task.CompletedTask;
        public Task CancelAsync(Guid runId, string reason, CancellationToken ct = default) => Task.CompletedTask;
    }
}
