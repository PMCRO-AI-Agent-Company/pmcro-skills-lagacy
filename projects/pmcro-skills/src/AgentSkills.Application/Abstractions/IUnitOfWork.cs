using AgentSkills.Domain.Common;

namespace AgentSkills.Application.Abstractions;

/// <summary>
/// Coordinates one or more repositories so their staged changes commit
/// together. Call <see cref="Repository{TEntity, TKey}"/> to get a repository
/// scoped to this unit of work, stage changes on it, then
/// <see cref="SaveChangesAsync"/> to flush every staged Add/Update/Remove
/// atomically and get back the number of entities affected.
/// </summary>
public interface IUnitOfWork
{
    IRepository<TEntity, TKey> Repository<TEntity, TKey>()
        where TEntity : Entity<TKey>
        where TKey : notnull;

    Task<int> SaveChangesAsync(CancellationToken ct = default);
}
