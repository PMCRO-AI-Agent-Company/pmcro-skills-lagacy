using AgentSkills.Application.Abstractions.Sessions;
using AgentSkills.Application.Sessions.Commands.SeedIntent;
using AgentSkills.Infrastructure.Persistence.Pmcro;
using AgentSkills.Mcp.Terminal.Configuration;
using AgentSkills.Mcp.Terminal.Tools;

var builder = WebApplication.CreateBuilder(args);
builder.AddServiceDefaults();

var workingRoot = Environment.GetEnvironmentVariable("PMCR_WORKING_ROOT")
    ?? Directory.GetCurrentDirectory();
var config = new TerminalConfig { WorkingRoot = workingRoot };
builder.Services.AddSingleton(config);
builder.Services.AddSingleton<ISessionRepository>(_ => new FileSessionRepository(workingRoot));
builder.Services.AddSingleton<ITrailEventStore>(_ => new FileTrailEventStore(workingRoot));
builder.Services.AddSingleton<SeedIntentCommandHandler>();

builder.Services.AddMcpServer()
    .WithHttpTransport()
    .WithTools<TerminalTools>()
    .WithTools<GovernanceTools>();

var app = builder.Build();
app.MapDefaultEndpoints();
app.MapMcp();
app.Run();
