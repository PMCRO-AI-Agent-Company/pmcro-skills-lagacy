using System.ComponentModel;
using AgentSkills.Application.Sessions.Commands.SeedIntent;
using ModelContextProtocol.Server;

namespace AgentSkills.Mcp.Terminal.Tools;

[McpServerToolType]
public sealed class GovernanceTools(SeedIntentCommandHandler seedIntent)
{
    [McpServerTool(Name = "pmcro_seed_intent")]
    [Description("Seeds a PMCR-O intent through the Application CQRS boundary.")]
    public async Task<object> SeedIntent(
        string rawIntent, string requestedBy = "user", CancellationToken ct = default)
    {
        try
        {
            var result = await seedIntent.Handle(
                new SeedIntentCommand(rawIntent, requestedBy), ct);
            return result;
        }
        catch (ArgumentException ex)
        {
            return new { error = ex.Message };
        }
    }
}
