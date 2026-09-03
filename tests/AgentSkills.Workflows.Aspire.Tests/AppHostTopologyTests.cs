using Aspire.Hosting;
using Aspire.Hosting.Testing;
using Xunit;

namespace AgentSkills.Workflows.Aspire.Tests;

public sealed class AppHostTopologyTests
{
    [Fact]
    public async Task AppHost_registers_terminal_mcp_resource()
    {
        await using var app = await DistributedApplicationTestingBuilder
            .CreateAsync<Projects.AgentSkills_AppHost>(TestContext.Current.CancellationToken);

        var resource = app.Resources.SingleOrDefault(r => r.Name == "terminal-mcp");

        Assert.NotNull(resource);
    }
}
