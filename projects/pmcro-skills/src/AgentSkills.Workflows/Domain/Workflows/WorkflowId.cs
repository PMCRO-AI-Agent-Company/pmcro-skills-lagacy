namespace AgentSkills.Workflows.Domain.Workflows;

/// <summary>
/// Identity of a workflow definition. Value-object equality (record),
/// non-empty by construction.
/// </summary>
public sealed record WorkflowId
{
    public WorkflowId(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new ArgumentException("WorkflowId cannot be empty or whitespace.", nameof(value));
        }

        Value = value.Trim();
    }

    public string Value { get; }

    public override string ToString() => Value;
}
