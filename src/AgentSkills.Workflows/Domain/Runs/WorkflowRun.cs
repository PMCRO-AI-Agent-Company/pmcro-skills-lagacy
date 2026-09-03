using System.Diagnostics.CodeAnalysis;
using AgentSkills.Domain.Common;
using AgentSkills.Workflows.Domain.Workflows;

namespace AgentSkills.Workflows.Domain.Runs;

/// <summary>
/// Aggregate root for a single execution of a workflow. Uses the shared
/// Entity&lt;TKey&gt;/IAggregateRoot pattern from AgentSkills.Domain.Common
/// so it works with the generic IRepository/IUnitOfWork abstractions
/// unchanged — no bespoke store interface needed.
/// </summary>
public sealed class WorkflowRun : Entity<Guid>, IAggregateRoot
{
    private readonly List<WorkflowRunEvent> _events = [];

    [SetsRequiredMembers]
    public WorkflowRun(WorkflowId workflowId)
    {
        Id = Guid.NewGuid();
        WorkflowId = workflowId ?? throw new ArgumentNullException(nameof(workflowId));
        Status = RunStatus.Pending;
        _events.Add(new WorkflowRunEvent("Created", DateTimeOffset.UtcNow));
    }

    public WorkflowId WorkflowId { get; }
    public RunStatus Status { get; private set; }
    public DateTimeOffset? CompletedAt { get; private set; }
    public IReadOnlyList<WorkflowRunEvent> Events => _events;

    public void Start()
    {
        Status = RunStatus.Running;
        _events.Add(new WorkflowRunEvent("Started", DateTimeOffset.UtcNow));
    }

    public void Complete()
    {
        Status = RunStatus.Completed;
        CompletedAt = DateTimeOffset.UtcNow;
        _events.Add(new WorkflowRunEvent("Completed", DateTimeOffset.UtcNow));
    }

    public void Cancel(string reason)
    {
        Status = RunStatus.Cancelled;
        _events.Add(new WorkflowRunEvent($"Cancelled: {reason}", DateTimeOffset.UtcNow));
    }
}
