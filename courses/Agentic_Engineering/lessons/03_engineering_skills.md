# Skills for Software Engineers

## AI Skills for Real Engineers (by Matt Pocock)

- Demo: [Real-world feature build with Claude Code: every step explained](https://www.aihero.dev/real-world-feature-build-with-claude-code).
- Skills: [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/engineering).

## Layered Design

- LLMs like coding horizontally; this means you cannot test until all code is done from L1 to L3.
- Structure Todos into vertical slices; so the agent can get immediate feedback using TDD.

![](../assets/03/layered_design.png)

See: [Tracer Bullets: Keeping AI Slop Under Control](https://www.aihero.dev/tracer-bullets)

## Modular Design

Modules: break down code into units; but:

- Shallow modules have wide interface and little functionality; consider deepning it.
- Balance depth such that code surface area is easily navigable by humans and AI alike.

![](../assets/03/modular_design.png)

See: [How To Make Codebases AI Agents Love](https://www.aihero.dev/how-to-make-codebases-ai-agents-love)

## Task Dependencies

The skill: `to-issues` breaks down the PRD into issues, and notes down the dependencies to allow parallel work.

![](../assets/03/task_dependencies.png)

## Summary

- Let the AI ask the questions.
- Spend most time on alignment and planning (10 - 40 minutes sessions).
    - Global docs (ADR / CONTEXT.md)
    - Current conversation -> PRD
    - PRD -> many tasks with dependencies
- Be intentional with architecture.
- Use TDD to give immediate feedback loops to agents.
- Apply principles from 20-year-old software engineering books to AI.