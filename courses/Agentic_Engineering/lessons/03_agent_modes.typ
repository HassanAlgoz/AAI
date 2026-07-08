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
    title: [Agent Modes],
    subtitle: [Ask, Plan, Agent, and Debug in Cursor],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)
#set heading(numbering: "1.")
#title-slide()

= Agent Modes

== What makes Agents different?

An agent is built on three basic components:

+ #link("https://cursor.com/docs/models-and-pricing")[*Model*]: The agent model you pick for the task (LLM)
+ *Instructions*:
  + System Prompt: Base instructions written by the developers that guide the agent behavior
  + User Prompt: Instructions written by users
+ *Tools*:
  + Base tools: File editing, #link("https://cursor.com/docs/agent/tools/search")[codebase search], #link("https://cursor.com/docs/agent/tools/terminal")[terminal execution], #link("https://cursor.com/docs/agent/tools/browser")[browser], and more (I/O)
  + User tools: Installed by users later (e.g. #link("https://github.com/mcp/upstash/context7")[context7])

== Agent Harness

What separates coding agents apart is the #link("https://addyosmani.com/blog/agent-harness-engineering/")[Agent Harness].

#figure(
  image("/courses/Agentic_Engineering/assets/04/agent_harness.png", height: 80%),
  caption: [Harness],
)

#pagebreak()

#quote[A harness is every piece of code, configuration, and execution logic that isn't the model itself. A raw model is not an agent. It becomes one once a harness gives it state, tool execution, feedback loops, and enforceable constraints.] -- addyosmani

Cursor's Coding Agent supports the use of *Modes*:

+ Ask Mode
+ Plan Mode (humans should spend most time here)
+ Agent Mode (execution)
+ Debug Mode

#pagebreak()

= 1. Ask Mode

== What is it

Ask Mode is *read-only*: the agent can search and read your codebase, fetch documentation, and answer questions, but it cannot edit files, run terminal commands, or change anything in your workspace. Switch to Ask before you change anything — a common failure pattern with coding agents is asking for changes _before_ understanding what already exists.

Under the hood, Ask uses the same search tools as Agent Mode:

- *Agentic search*: exact-string lookups with `grep`/`ripgrep`. Cursor's _Instant Grep_ speeds this up significantly on large repos.
- *Semantic search*: meaning-based lookups powered by Cursor's codebase embeddings. Asking "where do we handle authentication?" can surface `middleware/session.ts` even when the literal word "authentication" isn't in the file.
- *Explore subagent*: a built-in subagent that searches in its own context window and returns only the findings, keeping your main conversation focused.

== When to use it

=== A. You're new to a codebase and want a guided tour.

Example 1:

```md
"How does authentication work in this codebase?
Could you point me to where the middleware is configured and any core auth logic?
List relevant files."
```

Example 2:

```md
How are frontend errors handled and reported in this project?
Show me the main error boundary or error handling utilities, and explain if any logging or monitoring is integrated.
List the relevant modules and highlight any custom logic for user error display.
```

#pagebreak()

=== B. You're about to make a change and need to know what already exists.

Example 1:

```md
I'm planning to update our notification system.
Can you show me where notifications are sent and managed in the backend?
List the relevant files and explain briefly how the flow works.
```

Example 2:

```md
Where is the project configuration stored?
List all main config files, and explain the structure or format (YAML, JSON, etc).
Highlight any environment-specific overrides or loading logic.
```

#pagebreak()

= 2. Plan Mode

== Motivation

- Agent starts making unrelated edits, touching files you didn't want, and losing focus.
- Plan Mode forces the agent to commit to a written, reviewable design _before_ it touches any code.

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/04/small_deviation_straight_line.png"),
  caption: [Straight horizontal green line, representing intended trajectory, and two deviating lines.],
)

Earlier course correction can save you a lot of frustration (and money).

How much time to spend on each phase?

+ *Understanding and planning*: ~80% — clarifying intent, exploring the codebase, writing and refining the plan.
+ *Execution*: ~5% — once the plan is right, agents are very fast.
+ *Review*: ~15% — verifying, revising the plan and re-executing, fixing edge cases, cleaning up.

== How it works

Press `Shift+Tab` from the chat input to cycle modes until you reach Plan, or pick it from the mode dropdown. Cursor also suggests Plan Mode automatically when your prompt describes a complex task.

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/04/01_plan_mode.png"),
  caption: [Plan Mode in the agent input],
)

#link("https://cursor.com/docs/agent/plan-mode#how-it-works")[How it works]:

+ Agent asks clarifying questions to understand your requirements
+ Researches your codebase to gather relevant context
+ Creates a comprehensive implementation plan
+ You review and edit the plan through chat or markdown files

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/04/05_plan_md.png"),
  caption: [Generated `Plan.md` file],
)

Click *Save to workspace* on the plan panel to move your plan into `.cursor/plans/` inside your project.

== Reviewing and editing the plan

You have two ways to refine a plan before clicking Build:

+ Edit the `Plan.md` file directly: you can tighten step descriptions, delete wrong assumptions, add file references.
+ Follow-up chat messages: The agent re-drafts the plan in response to your follow-ups.

You might want to collaborate on this, and clarify things with your teammates before moving on.

Especially for large changes, spend extra time creating a precise, well-scoped plan. The hard part is often figuring out *what* change should be made.

#pagebreak()

= 3. Agent Mode: Execute the Reviewed Plan

== What is it

*Agent Mode* is where the actual edits happen. It's the _execution mode_.

- LLMs tend to repeat existing patterns. But, you want to move on to a completely different mode: *Execution*.
- Their attention fades as context grows (context rot).

> Remember: AI performance degrades as the conversation grows longer.

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/04/04_context_limit.png"),
  caption: [Context Usage in Cursor Agents],
)

It's best to have another agent handle execution. This ensures the next agent has full, focused access to your plan without context rot:

+ Open a new chat window with `Ctrl+N`
+ Instruct the model to: `implement the plan @Plan.md` (type `@file` and select your plan file) -- which we have saved before by clicking "*Save to Workspace*"

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/04/zones_smart_vs_dumb.png"),
  caption: [Smart and Dumb Zones],
)

== When the run goes wrong

If the agent goes off track — wrong direction, unrelated edits, drifting scope — do not keep patching with follow-ups. Rather, *undo and revise the plan itself*:

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/04/plan_revise_implement_revise.png", height: 55%),
)

+ *Stop the run* (`Esc` or the Stop button).
+ *Undo agent changes* — `Cmd/Ctrl+Z` in the chat to roll back the latest agent edits, or use Source Control to discard the diff. The Revert button in the bottom-right of a past chat message rolls files back to that point in the conversation.
+ *Re-open the plan* — Markdown file in the chat panel, or under `~/.cursor/plans/...` if you haven't clicked Save to workspace yet.
+ *Edit the plan* — tighten ambiguous tasks, drop wrong assumptions, add file references that were missing the first time.
+ *Run it again*.

#pagebreak()

= 4. Debug Mode

== What is it

Reach *Debug Mode* the same way as the others: `Shift+Tab` to cycle, or the mode picker dropdown.

Debug Mode helps you find root causes and fix tricky bugs that are hard to reproduce or understand. Instead of immediately writing code, the agent generates hypotheses, adds log statements, and uses runtime information to pinpoint the exact issue before making a targeted fix.

== When to use Debug Mode

Debug Mode works best for: *Bugs you can reproduce but can't figure out*: when you know something is wrong but the cause isn't obvious from reading the code.

When standard Agent interactions struggle with a bug, Debug Mode provides a different approach using runtime evidence rather than guessing at fixes.

== How it works

+ *Explore and hypothesize*: the agent explores relevant files, builds context, and generates multiple hypotheses about potential root causes.
+ *Add instrumentation*: the agent adds log statements that send data to a local debug server running in a Cursor extension.
+ *Reproduce the bug*: Debug Mode asks you to reproduce the bug and provides specific steps. This keeps you in the loop and ensures the agent captures real runtime behavior.
+ *Analyze logs*: after reproduction, the agent reviews the collected logs to identify the actual root cause based on runtime evidence.
+ *Make a targeted fix*: the agent makes a focused fix that directly addresses the root cause, often just a few lines of code.
+ *Verify and clean up*: you can re-run the reproduction steps to verify the fix. Once confirmed, the agent removes all instrumentation.

== Tips for Debug Mode

- *Provide detailed context*: the more you describe the bug and how to reproduce it, the better the agent's instrumentation will be. Include error messages, stack traces, and specific steps.
- *Follow reproduction steps exactly*: execute the steps the agent provides to ensure logs capture the actual issue.
- *Reproduce multiple times if needed*: reproducing the bug multiple times may help the agent identify tricky problems like race conditions.
- *Be specific about expected vs. actual behavior*: help the agent understand what should happen versus what is happening.

#pagebreak()

= Models

== Latency-Quality Tradeoff

#figure(
  image("/courses/Agentic_Engineering/assets/04/model_latency_quality_tradeoff.png", height: 65%),
  caption: [Model Latency Quality Tradeoff],
)

- *Faster models* work well for quick edits and routine tasks
- *More capable models* are better for complex reasoning and multi-file refactoring

== How to switch between models

Use the model picker dropdown at the top of the chat input to switch models, or press `Ctrl /` to cycle through models. The change applies to the current conversation going forward. Set a default model in *Cursor Settings > Models*.

You can switch models mid-conversation, for example when a faster model handled exploration but you need deeper reasoning for implementation. See #link("https://cursor.com/docs/models-and-pricing")[Models & Pricing] for the full list.

#pagebreak()

== Where this is going?

Addy Osmani #link("https://addyosmani.com/blog/agent-harness-engineering/")[wrote]:

#quote[Look at the top coding agents side by side (Claude Code, Cursor, Codex, Aider, Cline) and they look more like each other than their underlying models do. The models are different. The harness patterns are converging. I don't think that's an accident. It's the industry slowly finding the load-bearing pieces of scaffolding that turn a generative model into something that can ship.] -- addyosmani
