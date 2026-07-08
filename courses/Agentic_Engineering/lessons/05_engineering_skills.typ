#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Skills for Software Engineers],
    subtitle: [Architecture patterns agents can follow],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Skills for Software Engineers

== Context Management

- The key to working effectively with AI is developing a *verification mindset*. Every response is just a suggestion not a final answer. #pause


== Plan and Multi-task

Use *Planning Mode* to breakdown your tasks into smaller chunks; then use *Multi-Task Mode* to execute each task in isolated conversations.

#figure(
  image("/courses/Agentic_Engineering/assets/01/zones_smart_vs_dumb.png", height: 65%),
)

== AI Skills for Real Engineers (by Matt Pocock)

- Demo: #link("https://www.aihero.dev/real-world-feature-build-with-claude-code")[Real-world feature build with Claude Code: every step explained].
- Skills: #link("https://github.com/mattpocock/skills/tree/main/skills/engineering")[mattpocock/skills].

#pagebreak()

== Layered Design

- LLMs like coding horizontally; this means you cannot test until all code is done from L1 to L3.
- Structure Todos into vertical slices; so the agent can get immediate feedback using TDD.

#figure(
  image("/courses/Agentic_Engineering/assets/03/layered_design.png"),
  caption: [Layered vs. vertical slice design.],
)

See: #link("https://www.aihero.dev/tracer-bullets")[Tracer Bullets: Keeping AI Slop Under Control]

#pagebreak()

== Modular Design

Modules: break down code into units; but:

- Shallow modules have wide interface and little functionality; consider deepning it.
- Balance depth such that code surface area is easily navigable by humans and AI alike.

#figure(
  image("/courses/Agentic_Engineering/assets/03/modular_design.png"),
  caption: [Modular design depth.],
)

See: #link("https://www.aihero.dev/how-to-make-codebases-ai-agents-love")[How To Make Codebases AI Agents Love]

#pagebreak()

== Task Dependencies

The skill: `to-issues` breaks down the PRD into issues, and notes down the dependencies to allow parallel work.

#figure(
  image("/courses/Agentic_Engineering/assets/03/task_dependencies.png"),
  caption: [Task dependencies from PRD.],
)

#pagebreak()

== Summary

- Let the AI ask the questions.
- Spend most time on alignment and planning (10 - 40 minutes sessions).
  - Global docs (ADR / CONTEXT.md)
  - Current conversation -> PRD
  - PRD -> many tasks with dependencies
- Be intentional with architecture.
- Use TDD to give immediate feedback loops to agents.
- Apply principles from 20-year-old software engineering books to AI.
