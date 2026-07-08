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
    title: [Agentic Engineering],
    subtitle: [From vibe coding to structured AI collaboration],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Agentic Engineering

== Coding Agents

An agent is an AI system that autonomously plans and executes coding tasks. You give the agent a high-level goal, and it breaks the goal down into steps, executes those steps with #link("https://code.visualstudio.com/docs/copilot/concepts/tools")[tools], and self-corrects when it hits errors.

=== Examples of Coding Agents

- #link("https://claude.com/product/claude-code")[Claude Code]
- #link("https://cursor.com/")[Cursor Agent]
- #link("https://aider.chat/")[Aider]
- #link("https://cline.bot/")[Cline]
- #link("https://opencode.ai/")[OpenCode]

== Vibe Coding

*Vibe Coding* is the practice of letting an LLM generate code based on loose, high-level prompts without the human developer understanding the underlying codebase. #pause

While incredibly fast for spinning up initial prototypes, it breaks down quickly in production. #pause

Relying on basic prompting means you are at the mercy of LLM non-determinism. A "vibe" that works today might break tomorrow with a minor model update.

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/01/vibe_coding_vibe_debugging_meme.png", height: 65%),
  caption: [The initial euphoria of effortlessly generating code is immediately haunted by a pink monster: Vibe Debugging. When the AI-generated code inevitably fails, the developer doesn't actually know how it works, leading to a painful, clueless cycle of guessing new prompts to fix it.
  ]
)

#pagebreak()

== Agentic Engineering

*Agentic Engineering* means integrating AI into your existing development workflow. When quality software is the goal, there is no substitute for a skilled engineer. It is about enhancing what we can accomplish through thoughtful collaboration. #pause

Ultimately, Agentic Engineering moves us away from the chaotic guesswork of vibe coding and brings back structure and determinism to software development. #pause

In this course, we learn to mitigate the hallucinations and limitations that are inherent in AI models, and learn to make them work for us better. #pause

= Challenges

== Hallucinations

- *Hallucination* is when an AI model confidently generates information that seems plausible but is actually incorrect.
- It's like when someone tries to bluff their way through a conversation about a topic they don't really know.
- "You're absolutely right!" when in reality, you were no where near right.

For coding, this might means: #pause

- Inventing plausible-sounding API methods that don't actually exist #pause
- Mixing up syntax between different programming libraries or frameworks #pause
- Creating configuration options that seem reasonable but aren't real

#pagebreak()

=== Why do models hallucinate?

Programs are *deterministic*:

1. Given some input,
2. if you run the program again,
3. you will *definitely* get the same output.

LLMs are *statistical models*:

1. Given some input,
2. if you run the program again,
3. you will *probably* get the same output.

#pagebreak()

#table(
  columns: (1fr, 1fr, 1fr),
  align: (left, left, left),
  table.header(
    [*Capability*], [*Deterministic Software*], [*LLM-based AI Models*],
  ),
  [*Consistency*],
  [100% reproducible.],
  [Variable; the same input can yield different outputs.],
  [*Exact Arithmetic*],
  [Flawless precision.],
  [Guesses the next token; often fails complex math.],
  [*Auditability*],
  [Verifiable via stack traces.],
  ["Black box" execution; unexplainable logic leaps.],
  [*State Management*],
  [Perfect recall via databases.],
  [Limited by context windows; prone to dropping data.],
  [*Execution Efficiency*],
  [Executes discrete algorithms in microseconds.],
  [Massive compute overhead for basic logic tasks.],
)

#pagebreak()

== Pricing & Token Limits

Why tokens matter?

1. Tokens are how models are *priced* You pay per token (word, sub-word, or symbol).
2. Tokens are how we measure model *speed* Faster models have a faster TPS (tokens per second).
#pause
AI models charge based on two types of tokens: #pause

1. *Output tokens*, include everything the model generates back to you.
2. *Input tokens*, include everything you send to the model like your prompt (and the conversation history). #pause

Output tokens typically *cost 2-4x more than input tokens*, because generating new content requires more computational work than just processing what you sent.

#pagebreak()

#figure(
  image("/courses/Agentic_Engineering/assets/01/models_pricing.png", height: 90%),
  caption: [models pricing],
)

#pagebreak()
Set _Usage Summary_ to: `"Always"`

#figure(
  image("/courses/Agentic_Engineering/assets/01/00_usage_summary_always.png", height: 65%),
  caption: [tokens usage summary],
)

== Performance & Context Length

- Every AI model also has a different context limit, where it will no longer accept further messages in the conversation.
- At some point, even before the limit, performance degrades
- The longer the conversation the more you pay (history is appended as input)

#figure(
  image("/courses/Agentic_Engineering/assets/01/200k_context_window.png", height: 65%),
)

#pagebreak()

=== Start anew

Essentially the problem is that AI models can only handle so much context, so we need to keep it fresh. Keep your conversations short and focused:

+ Build a feature
+ Test it
+ Start a new conversation for the next feature

#pagebreak()


== Security

An Agent is a Man-in-the-Middle (MITM). It sits between the user and the system they are trying to control, intercepting the communication and routing it to servers hosting AI models, and back to the system to execute remotely generated instructions.

#figure(
  image("/courses/Agentic_Engineering/assets/01/cli_agent_openai.png", height: 60%),
  caption: [The User-Agent Interface],
)

=== Left: Direct Execution

1. The Terminal acts as a transparent interface, routing raw string input directly to the Shell.
2. Execution requires the user to manually construct precise, structurally valid system commands and flags.
3. The Shell returns raw execution streams (stdout/stderr) directly to the Terminal, requiring manual human analysis for error resolution.

=== Right: Agent as Man-in-the-Middle

1. An Agent layer is inserted directly between the Terminal and the Shell, intercepting the standard I/O pipeline.
2. The Agent captures natural language objectives and local system context, packaging and transmitting them via network requests to external *OpenAI Servers*.
3. The remote language model processes the payload, translates the intent into executable shell syntax, and transmits the command back to the local Agent.
4. The Agent executes the proxy commands in the local Shell and intercepts the output streams; it routes subsequent errors or stack traces back to the OpenAI Servers for autonomous debugging and recursive correction before yielding a final summary to the user.

See #link("https://cursor.com/docs/agent/security")[Agent Security] for more details.
