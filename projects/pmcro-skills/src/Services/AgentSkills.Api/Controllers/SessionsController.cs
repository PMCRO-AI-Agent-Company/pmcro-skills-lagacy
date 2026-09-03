using AgentSkills.Application.Sessions.Commands.SeedIntent;
using AgentSkills.Application.Abstractions.Sessions;
using Microsoft.AspNetCore.Mvc;

namespace AgentSkills.Api.Controllers;

[ApiController]
[Route("api/v1/sessions")]
public sealed class SessionsController(
    SeedIntentCommandHandler seedIntent,
    ISessionRepository sessions) : ControllerBase
{
    [HttpPost("seed-intent")]
    public async Task<ActionResult<SeedIntentResult>> SeedIntent(
        [FromBody] SeedIntentRequest request, CancellationToken ct)
    {
        try
        {
            var result = await seedIntent.Handle(
                new SeedIntentCommand(request.RawIntent, request.RequestedBy ?? "user"), ct);
            return Created($"/api/v1/sessions/{result.SessionId}", result);
        }
        catch (ArgumentException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpGet("active")]
    public async Task<ActionResult<SeedIntentResult>> Active(CancellationToken ct)
    {
        var session = await sessions.GetActiveAsync(ct);
        if (session is null) return NoContent();
        return Ok(new SeedIntentResult(session.Id, session.RawIntent,
            session.RequestedBy, $".pmcro/trails/{session.Id:N}.events.jsonl", session.Status.ToString()));
    }
}

public sealed record SeedIntentRequest(string RawIntent, string? RequestedBy);
