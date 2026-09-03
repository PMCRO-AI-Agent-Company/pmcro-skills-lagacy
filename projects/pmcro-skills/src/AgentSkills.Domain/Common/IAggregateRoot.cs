namespace AgentSkills.Domain.Common;

/// <summary>
/// Marker interface for entities that are the root of a persistence and
/// consistency boundary. Only aggregate roots get a dedicated repository.
/// </summary>
public interface IAggregateRoot;
