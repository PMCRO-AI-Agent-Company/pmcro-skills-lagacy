var builder = DistributedApplication.CreateBuilder(args);

var workingRoot = Environment.GetEnvironmentVariable("PMCR_WORKING_ROOT")
    ?? Directory.GetCurrentDirectory();

builder.AddProject<Projects.AgentSkills_Api>("api")
    .WithEnvironment("PMCR_WORKING_ROOT", workingRoot);

builder.AddProject<Projects.AgentSkills_Mcp_Terminal>("terminal-mcp")
    .WithEnvironment("Parameters__working-root", workingRoot);

builder.Build().Run();
