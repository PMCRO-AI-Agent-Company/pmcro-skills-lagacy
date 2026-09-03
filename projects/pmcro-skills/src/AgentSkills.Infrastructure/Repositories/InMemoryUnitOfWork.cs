using System.Collections.Concurrent;
using AgentSkills.Application.Abstractions;
using AgentSkills.Domain.Common;

namespace AgentSkills.Infrastructure.Repositories;

/// <summary>
/// Process-lifetime Unit of Work backed by in-memory repositories, one per
/// entity type, created lazily via <see cref="Repository{TEntity,TKey}"/>
/// and reused for the lifetime of this instance.
/// </summary>
public sealed class InMemoryUnitOfWork : IUnitOfWork
{
    private readonly ConcurrentDictionary<Type, object> _repositories = new();

    public IRepository<TEntity, TKey> Repository<TEntity, TKey>()
        where TEntity : Entity<TKey>
        where TKey : notnull
        => (IRepository<TEntity, TKey>)_repositories.GetOrAdd(
            typeof(TEntity),
            static _ => new InMemoryRepository<TEntity, TKey>());

    public Task<int> SaveChangesAsync(CancellationToken ct = default)
    {
        var count = _repositories.Values.OfType<ICommittable>().Sum(r => r.Commit());
        return Task.FromResult(count);
    }
}
