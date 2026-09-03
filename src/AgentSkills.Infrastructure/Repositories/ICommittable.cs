namespace AgentSkills.Infrastructure.Repositories;

/// <summary>
/// Implemented by repositories that stage changes for a later atomic flush.
/// Internal: only <see cref="InMemoryUnitOfWork"/> calls <see cref="Commit"/>.
/// </summary>
internal interface ICommittable
{
    int Commit();
}
