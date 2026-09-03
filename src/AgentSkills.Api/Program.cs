using AgentSkills.Application.Abstractions;
using AgentSkills.Application.Abstractions.Sessions;
using AgentSkills.Application.Sessions.Commands.SeedIntent;
using AgentSkills.Infrastructure.Persistence.Pmcro;
using AgentSkills.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);
builder.AddServiceDefaults();
builder.Services.AddControllers();

builder.Services.AddSingleton<IUnitOfWork, InMemoryUnitOfWork>();
var repoRoot = builder.Configuration["PMCR_WORKING_ROOT"]
    ?? Directory.GetCurrentDirectory();
builder.Services.AddSingleton<ISessionRepository>(_ => new FileSessionRepository(repoRoot));
builder.Services.AddSingleton<ITrailEventStore>(_ => new FileTrailEventStore(repoRoot));
builder.Services.AddSingleton<SeedIntentCommandHandler>();

var app = builder.Build();
app.MapDefaultEndpoints();
app.MapControllers();
app.Run();
