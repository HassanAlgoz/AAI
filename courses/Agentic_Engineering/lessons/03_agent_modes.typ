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


#pagebreak()

Cursor's Coding Agent supports the use of *Modes*:

+ Ask
+ Plan (humans should spend most time here)
+ Agent (execution mode)
+ Debug
+ Multitask

#pagebreak()

= 1. Ask Mode

== What is it

Switch to *Ask* before you change anything — a common failure pattern with coding agents is asking for changes _before_ understanding what already exists.

=== How it Works

Ask Mode is *read-only*: the agent can search and read your codebase, fetch documentation, and answer questions, but it cannot edit files, run terminal commands, or change anything in your workspace.

Under the hood, Ask uses the same search tools as Agent Mode:
+ *Agentic search*: exact-string lookups with `grep`/`ripgrep`.
+ *Semantic search*: meaning-based lookups.
+ *Explore subagent*: a built-in subagent that searches in its own context window and returns only the findings, keeping your main conversation focused.

== Examples

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

Example 3: asking about the timeline of a specific function, module, or class utilizing the git history and GitHub issues:

```md
Can you tell my why this function has 15 arguments?
Use the git history and GitHub issues to answer the question.
```

Suggested by #link("https://www.youtube.com/live/6eBSHbLKuN0?si=44v_2r_gq9uNeKQf&t=253")[Boris Cherny from Anthropic]

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

#figure(
  image("/courses/Agentic_Engineering/assets/04/small_deviation_straight_line.png", height: 50%),
  caption: [Straight horizontal green line, representing intended trajectory, and two deviating lines.],
)

Earlier course correction can save you a lot of frustration (and money).

How much time to spend on each phase?

+ *Understanding and planning*: ~45% — clarifying intent, exploring the codebase, writing and refining the plan.
+ *Review*: ~55% — verifying, revising the plan and re-executing, fixing edge cases, cleaning up.

Execution is handled by agents; so you can keep working on other tasks while the agent is working on the plan.

== Switch or be switched

Press `Shift+Tab` from the chat input to cycle modes until you reach Plan, or pick it from the mode dropdown. Cursor also suggests Plan Mode automatically when your prompt describes a complex task.

#figure(
  image("/courses/Agentic_Engineering/assets/04/01_plan_mode.png"),
  caption: [Plan Mode in the agent input],
)

== Drafting the plan

#grid(
  columns: (1.1fr, 0.8fr),
  gutter: 1em,
  [
    #link("https://cursor.com/docs/agent/plan-mode#how-it-works")[How it works]:

    + Agent asks clarifying questions to understand your requirements
    + Researches your codebase to gather relevant context
    + Creates a comprehensive implementation plan
  ],
  [
    #figure(
      image("/courses/Agentic_Engineering/assets/04/05_plan_md.png", width: 100%),
      caption: [Agent Plan],
    )

    Click *Save to workspace* to keep the plan in `.cursor/plans/`.
  ],
)

== Reviewing and editing the plan

You have two ways to refine a plan before clicking Build:

+ Edit the `Plan.md` file directly: you can tighten step descriptions, delete wrong assumptions, add file references.
+ Follow-up chat messages: The agent re-drafts the plan in response to your follow-ups.

You might want to collaborate on this, and clarify things with your teammates before moving on.

Especially for large changes, spend extra time creating a precise, well-scoped plan. The hard part is often figuring out *what* change should be made.

== Revising after wrong implementation

If the agent goes off track — wrong direction, unrelated edits, drifting scope — do not keep patching with follow-ups. Rather, *undo and revise the plan itself*:

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 1em,
  [
    + *Stop the run* — `Esc` or the Stop button.
    + *Undo changes* — `Cmd/Ctrl+Z` in chat, discard in Source Control, or Revert on a past message.
    + *Re-open the plan* — chat panel, or `~/.cursor/plans/...` if not saved to workspace.
    + *Edit the plan* — tighten tasks, fix assumptions, add missing file references.
    + *Run it again*.
  ],
  [
    #figure(
      image("/courses/Agentic_Engineering/assets/plan_revise.png", width: 100%),
    )
  ],
)

= 3. Agent Mode

== What is it

*Agent Mode* is the most general mode, it allows the agent to edit files, run terminal commands, and change anything in your workspace.

You can spawn *sub-agents* from here as well.

Example:

```md
Implement the @plan.md and dedicate a sub-agent for each independent task or file being edited.
```

= 4. Debug Mode

== What is it

*Debug Mode* helps you find root causes and fix tricky bugs that are hard to reproduce or understand. Instead of immediately writing code, the agent generates hypotheses, adds log statements, and uses runtime information to pinpoint the exact issue before making a targeted fix.

=== When to use it?

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
