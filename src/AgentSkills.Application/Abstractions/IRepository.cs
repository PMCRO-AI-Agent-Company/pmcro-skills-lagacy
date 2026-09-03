using AgentSkills.Domain.Common;

namespace AgentSkills.Application.Abstractions;

/// <summary>
/// Generic repository contract. Reads are immediate; writes (<see cref="Add"/>,
/// <see cref="Update"/>, <see cref="Remove"/>) are staged and only take effect
/// once <see cref="IUnitOfWork.SaveChangesAsync"/> commits them — the classic
/// Repository + Unit of Work pairing.
/// </summary>
public interface IRepository<TEntity, TKey>
    where TEntity : Entity<TKey>
    where TKey : notnull
{
    Task<TEntity?> FindAsync(TKey id, CancellationToken ct = default);
    Task<IReadOnlyCollection<TEntity>> ListAsync(CancellationToken ct = default);
    void Add(TEntity entity);
    void Update(TEntity entity);
    void Remove(TEntity entity);
}
