namespace AgentSkills.Core.Primitives;

/// <summary>
/// Framework-neutral value object for required textual identifiers and names.
/// </summary>
public readonly record struct NonEmptyString
{
    public NonEmptyString(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("Value cannot be empty or whitespace.", nameof(value));

        Value = value.Trim();
    }

    public string Value { get; }

    public override string ToString() => Value;
}
