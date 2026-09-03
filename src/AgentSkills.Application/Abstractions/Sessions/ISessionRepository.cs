using AgentSkills.Domain.Sessions;

namespace AgentSkills.Application.Abstractions.Sessions;

public interface ISessionRepository
{
    Task<Session?> GetAsync(Guid id, CancellationToken ct = default);
    Task SaveAsync(Session session, CancellationToken ct = default);
    Task<Session?> GetActiveAsync(CancellationToken ct = default);
}
