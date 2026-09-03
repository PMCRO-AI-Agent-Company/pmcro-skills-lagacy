namespace AgentSkills.Workflows.Domain.Workflows;

/// <summary>
/// Static description of a workflow: what it's called and which YAML file
/// defines its steps. yamlPath must be relative — colony-laws.md
/// W-PORTABILITY-001 forbids rooted/drive-letter paths in config, and this
/// applies equally to workflow definitions.
/// </summary>
public sealed class WorkflowDefinition
{
    public WorkflowDefinition(WorkflowId id, string name, string description, string yamlPath)
    {
        if (Path.IsPathRooted(yamlPath))
        {
            throw new ArgumentException(
                "Workflow yaml path must be relative to repo root (W-PORTABILITY-001).",
                nameof(yamlPath));
        }

        Id = id ?? throw new ArgumentNullException(nameof(id));
        Name = name;
        Description = description;
        YamlPath = yamlPath;
    }

    public WorkflowId Id { get; }
    public string Name { get; }
    public string Description { get; }
    public string YamlPath { get; }
}
