using AgentSkills.Workflows.Domain.Runs;
using AgentSkills.Workflows.Domain.Workflows;
using Xunit;

namespace AgentSkills.Workflows.Tests;

public sealed class WorkflowDomainTests
{
    [Fact]
    public void WorkflowId_rejects_empty_values()
    {
        Assert.Throws<ArgumentException>(() => new WorkflowId(" "));
    }

    [Fact]
    public void WorkflowDefinition_rejects_rooted_yaml_paths()
    {
        var id = new WorkflowId("sample");
        Assert.Throws<ArgumentException>(() =>
            new WorkflowDefinition(id, "Sample", "Description", Path.GetFullPath("sample.yaml")));
    }

    [Fact]
    public void WorkflowRun_records_lifecycle_events()
    {
        var run = new WorkflowRun(new WorkflowId("sample"));
        run.Start();
        run.Complete();

        Assert.Equal(RunStatus.Completed, run.Status);
        Assert.Equal(3, run.Events.Count);
        Assert.Equal("Started", run.Events[1].EventType);
        Assert.Equal("Completed", run.Events[2].EventType);
        Assert.NotNull(run.CompletedAt);
    }
}
