using System.Collections.Concurrent;
using AgentSkills.Application.Abstractions;
using AgentSkills.Domain.Common;

namespace AgentSkills.Infrastructure.Repositories;

/// <summary>
/// In-memory <see cref="IRepository{TEntity,TKey}"/>. Add/Update/Remove are
/// staged in-process; nothing touches the backing store until
/// <see cref="Commit"/> runs (invoked by <see cref="InMemoryUnitOfWork"/>).
/// </summary>
internal sealed class InMemoryRepository<TEntity, TKey> : IRepository<TEntity, TKey>, ICommittable
    where TEntity : Entity<TKey>
    where TKey : notnull
{
    private readonly ConcurrentDictionary<TKey, TEntity> _store = new();
    private readonly List<TEntity> _pendingAdds = [];
    private readonly List<TEntity> _pendingUpdates = [];
    private readonly List<TKey> _pendingRemovals = [];

    public Task<TEntity?> FindAsync(TKey id, CancellationToken ct = default)
        => Task.FromResult(_store.GetValueOrDefault(id));

    public Task<IReadOnlyCollection<TEntity>> ListAsync(CancellationToken ct = default)
        => Task.FromResult<IReadOnlyCollection<TEntity>>(_store.Values.ToList());

    public void Add(TEntity entity) => _pendingAdds.Add(entity);

    public void Update(TEntity entity) => _pendingUpdates.Add(entity);

    public void Remove(TEntity entity) => _pendingRemovals.Add(entity.Id);

    public int Commit()
    {
        var count = 0;

        foreach (var entity in _pendingAdds)
        {
            _store[entity.Id] = entity;
            count++;
        }

        foreach (var entity in _pendingUpdates)
        {
            _store[entity.Id] = entity;
            count++;
        }

        foreach (var id in _pendingRemovals)
        {
            if (_store.TryRemove(id, out _))
            {
                count++;
            }
        }

        _pendingAdds.Clear();
        _pendingUpdates.Clear();
        _pendingRemovals.Clear();

        return count;
    }
}
