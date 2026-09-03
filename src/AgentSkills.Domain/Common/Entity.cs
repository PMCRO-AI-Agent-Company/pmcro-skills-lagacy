namespace AgentSkills.Domain.Common;

/// <summary>
/// Base type for entities identified by a stable key. Equality is by
/// identity (<see cref="Id"/>), not by value, per standard DDD entity
/// semantics.
/// </summary>
public abstract class Entity<TKey> : IEquatable<Entity<TKey>>
    where TKey : notnull
{
    public required TKey Id { get; init; }

    public bool Equals(Entity<TKey>? other)
        => other is not null && EqualityComparer<TKey>.Default.Equals(Id, other.Id);

    public override bool Equals(object? obj) => Equals(obj as Entity<TKey>);

    public override int GetHashCode() => EqualityComparer<TKey>.Default.GetHashCode(Id);
}
