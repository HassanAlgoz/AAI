#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Agentic Engineering],
    subtitle: [Autonomous workflows, optimization & patterns],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Memes

== 

#align(center + horizon)[
  #image("./assets/vibe_coding_vibe_debugging_meme.png", width: 85%)
]

== 

#align(center + horizon)[
  #image("./assets/agentic_ai_economy_meme.png", width: 85%)
]


= Overview

== Coding Agents

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    An agent is an AI system that autonomously plans and executes coding tasks. You give the agent a high-level goal, and it breaks the goal down into steps, executes those steps with #link("https://code.visualstudio.com/docs/copilot/concepts/tools")[*tools*], and self-corrects when it hits errors.
  ],
  [
    #align(center + horizon)[
      #image("/courses/00_Intros/assets/chat-sessions-view.png", width: 100%)
    ]
  ]
)

== Examples of Coding Agents

- #link("https://cursor.com/")[*Cursor*]
- #link("https://antigravity.google/")[*Antigravity*]
- #link("https://code.visualstudio.com/docs/copilot/overview")[*GitHub Copilot*]
- Claude Code (most expensive)
- #link("https://cline.bot/")[*Cline*] (on-prem)


= Operational Workflows

== Agent loop

The agent loop typically involves three high-level stages:

1. *Understand.* The agent reads files, searches the codebase, and looks up documentation to understand what needs to change.
2. *Act.* The agent modifies code, runs terminal commands, installs dependencies, or calls external services through #link("https://code.visualstudio.com/docs/copilot/concepts/tools")[*tools*].
3. *Validate.* The agent runs tests, checks for compiler errors, and reviews its own changes.

#v(0.5em)
#align(center)[
  #image("/courses/00_Intros/assets/agent-loop.png", width: 60%)
]

== Agent types

Agents run in different environments depending on when you need results and how much oversight you want. The two key dimensions are:

1. _where_ the agent runs (your machine or the cloud) and
2. _how_ you interact with it (interactively or autonomously in the background)

#v(0.5em)
#align(center)[
  #image("/courses/00_Intros/assets/agent-types-diagram-v3.png", width: 65%)
]


= Customization

== System Prompt

- A `AGENTS.md` file placed at the root, is automatically injected into every chat session. Use when:
  - You work with multiple AI coding agents and want a single set of instructions recognized by all of them
  - You want subfolder-level instructions that apply to specific parts of a monorepo

#v(0.5em)
See: #link("https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_tips-for-writing-effective-instructions")[Tips for writing effective instructions].

== Example: `AGENTS.md` file

#set text(size: 13pt)
#block(
  fill: rgb("#1e1e2e"),
  inset: 1em,
  radius: 0.3em,
  stroke: 1pt + rgb("#313244"),
  width: 100%
)[
  #set text(fill: rgb("#cdd6f4"), font: "Courier New")
  *1. Environment & Commands*
  - This project uses *\`uv\`* for dependency management. Do not use standard pip.
  - *Run a script:* \`uv run python path/to/script.py\`
  - *Add dependency:* \`uv add <package>\`

  *2. Tech Stack Context*
  - *Orchestration:* LangChain handles chains, tools, and agents.
  - *Local Models:* HF \`transformers\` with explicit \`device_map="auto"\`.
  - *Vector Database:* ChromaDB initialization using \`PersistentClient\`.
]

== Up-to-date Code Docs

#link("https://github.com/mcp/upstash/context7")[Context7 Platform]

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  block(fill: rgb("#fee2e2"), inset: 1em, radius: 0.5em, width: 100%)[
    #text(weight: "bold", fill: rgb("#991b1b"))[❌ Without Context7]
    - Examples are outdated and based on year-old training data.
    - Hallucinated APIs.
    - Generic answers.
  ],
  block(fill: rgb("#dcfce7"), inset: 1em, radius: 0.5em, width: 100%)[
    #text(weight: "bold", fill: rgb("#166534"))[✅ With Context7]
    - Up-to-date, version-specific documentation.
    - Code examples straight from source.
    - Injected directly into prompt.
  ]
)


= Planning & Scaling

== Planning

*Vibe Coding*: jumping straight into code generation; can lead to incomplete implementations or wrong architectural decisions.

The plan agent uses a 4-phase iterative workflow:
1. *Discovery*: research the task using read-only tools and codebase analysis.
2. *Alignment*: ask clarifying questions to resolve ambiguities.
3. *Design*: draft a structured implementation plan.
4. *Refinement*: iterate on the plan based on your feedback.

_Just type `/plan` to switch to planning mode._

== Customize planning

You can tailor the planning process to fit your team's workflow:

- *Create a custom planning agent:* Define a custom agent with specific instructions, enforcing architectural guidelines.
- *Choose models:* Use `chat.planAgent.defaultModel` for planning and `github.copilot.chat.implementAgent.model` for implementation.
- *Add extra tools (experimental):* Use `github.copilot.chat.planAgent.additionalTools` to grant access to things like internal MCP servers.

== Subagents

The built-in Plan agent uses subagents to perform research autonomously.

- *Context isolation*: each subagent runs in its own context window. It doesn't inherit history.
- *Synchronous execution*: the main agent waits for subagent results to inform the next step.
- *Parallel execution*: VS Code can spawn multiple subagents concurrently (e.g., security, performance).
- *Focused results*: only the final result returns, reducing main token usage.

== Context Isolation & The "Dumb Zone"

#grid(
  columns: (1.2fr, 1fr),
  gutter: 1.5em,
  [
    Keep tasks small and delegate to subagents to avoid performance degradation:
    
    - *Smart Zone:* Starts fresh, unburdened attention relationships.
    - *Dumb Zone:* Context > 100k tokens degrades LLM performance quadratically.
    
    #v(0.5em)
    _Compacting (summarizing context) is of no use. Instead, clear it._
  ],
  [
    #align(center + horizon)[
      #image("/courses/00_Intros/assets/dumb_zone.png", width: 100%)
    ]
  ]
)


= Engineering Guardrails

== Skills

- A skill is a prompt retrieved on-demand (unlike `AGENTS.md` which is pre-injected).
- Examples:
  - #link("https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd/SKILL.md")[*tdd*] — Test-driven development with a red-green-refactor loop. Fixes bugs one vertical slice at a time.
  - #link("https://github.com/mattpocock/skills/blob/main/skills/engineering/diagnose/SKILL.md")[*diagnose*] — Loop for hard bugs: reproduce $arrow$ minimise $arrow$ hypothesise $arrow$ instrument $arrow$ fix.

== Example Skill: `caveman/SKILL.md`

#set text(size: 15pt)
#grid(
  columns: (1.1fr, 1fr),
  gutter: 1.5em,
  block(fill: rgb("#f8fafc"), inset: 0.8em, radius: 0.4em)[
    *Rules:*
    - *Drop:* articles (a/an/the), filler, pleasantries, hedging.
    - *Keep:* Exact technical terms (`uv`, `LCEL`), exact code blocks.
    - *Format:* Fragments OK. Arrows for causality ($X arrow Y$).
    - *Pattern:* `[thing] [action] [reason]. [next step].`
  ],
  block(fill: rgb("#f1f5f9"), inset: 0.8em, radius: 0.4em)[
    *Stack Examples:*
    - _"Why lose data on restart?"_ \ \> Memory client used. Switch \`PersistentClient\`.
    - _"How to add package?"_ \ \> \`uv add [package]\`. No pip.
  ]
)

== Architecture Layouts

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    #text(weight: "bold")[Modular Design]
    - Avoid wide, shallow modules. Deepen functionality.
    - Surface area navigable by humans and AI.
    #v(0.2em)
    #align(center)[#image("/courses/00_Intros/assets/modular_design.png", width: 85%)]
  ],
  [
    #text(weight: "bold")[Layered Design]
    - LLMs code horizontally, delaying tests.
    - Slice tasks into *vertical slices* for immediate TDD agent loop feedback.
    #v(0.2em)
    #align(center)[#image("/courses/00_Intros/assets/layered_design.png", width: 85%)]
  ]
)

== Task Dependencies & Community Focus

#grid(
  columns: (1.2fr, 1fr),
  gutter: 1.5em,
  [
    - The skill `to-issues` breaks down a product requirements document (PRD) into issues mapping technical dependencies to enable safe parallel agent execution.
    - Resources by Matt Pocock:
      - #link("https://www.aihero.dev/my-7-phases-of-ai-development")[My 7 Phases Of AI Development]
      - #link("https://github.com/mattpocock/skills")[mattpocock/skills] repository
  ],
  [
    #align(center + horizon)[
      #image("/courses/00_Intros/assets/task_dependencies.png", width: 100%)
    ]
  ]
)


= Wrap Up

== Summary

- *Let the AI ask the questions.*
- Spend most time on alignment and planning (10 - 40 minutes sessions).
  - Global docs (ADR / CONTEXT.md) $arrow$ PRD $arrow$ tasks with explicit dependencies.
- Be intentional with architecture.
- Use *TDD* to give immediate structural feedback loops to execution agents.
- Apply proven software engineering book paradigms to AI engines.