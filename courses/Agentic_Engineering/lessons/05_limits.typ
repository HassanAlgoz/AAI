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
    title: [The Case for Software Engineering Skills],
    subtitle: [Why fundamentals still matter with AI],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= The Case for Software Engineering Skills

= Matt Pocock

== Engineering Fundamentals

Matt Pocock #link("https://www.aihero.dev/")[wrote]: *Engineering fundamentals are your biggest advantage* #pause

#quote(block: true)[
  A lot of people think the rules of software development are being rewritten by AI. They think that code is cheap. That software engineering, as a profession, is finished. #pause

  Coding agents like Claude Code and Codex ship code faster than any human ever has. But without careful guidance, they make codebases worse. And the worse the codebase, the worse the AI performs. It's a vicious circle. #pause

  Code isn't cheap. In fact, bad code is the most expensive it's ever been. If you can design codebases agents love, you can reap the rewards of this new era. #pause

  Software fundamentals aren't obsolete. They're essential. AI Hero is for anyone who cares about the code they ship.
]

== How AI Has Rewired His Brain

He also #link("https://www.aihero.dev/ways-ai-coding-has-rewired-my-brain")[wrote]:  #pause

+ Much higher cognitive load to keep up with the changes the LLM makes to the codebase  #pause
+ AI has no taste for UI, prototype extremely aggressively before committing to a PRD  #pause
+ AI has no taste for software architecture, be extremely explicit about the modules you want and think about their interfaces

= Carl Brown

== Programming Skills AIs Cannot Have

#link("https://www.youtube.com/watch?v=iJv25jws7qo")[Programming Skills that AIs Cannot Have & How You Learn Them] by Carl Brown (InternetOfBugs):

This video, presented by *Carl* from _Internet of Bugs_, explores the limitations of current AI models in software development and outlines the human skills that remain indispensable. Carl argues that while AI can perform discrete coding tasks, it lacks the *contextual awareness* and *long-term experience* necessary for true software engineering.

#pagebreak()
=== Core Limitations of AI (0:00 – 3:42) #pause

+ *Lack of Long-term Memory:* AI functions like the character from the movie _Memento_; it forgets sessions and cannot inherently improve its decision-making over time. #pause
+ *Context Sensitivity:* AI is limited by its training data and specific prompt context, struggling to anticipate real-world user scenarios or edge cases that aren't well-documented. #pause
+ *Isolation:* AI treats each coding task as an independent event, whereas real software maintenance requires understanding the history and future implications of every change.

#pagebreak()
=== The Human Advantage (3:42 – 12:58) #pause

+ *Intuition and Experience:* Human developers can develop an intuition for potential bugs by reflecting on past trade-offs and failures (5:13–7:00). #pause
+ *Systemic Understanding:* Unlike AI, a skilled developer realizes that bugs are often the result of decisions made months or years prior and actively works to mitigate future technical debt.  #pause
+ *Handling External Changes:* When external environments change (like security patches or library updates), developers must rely on problem-solving skills that aren't just found in search results like _Stack Overflow_.

#pagebreak()
=== How to Improve Your Skills (12:58 – 16:48) #pause

+ *Volunteer for Tough Problems:* Seek out bugs that lack clear answers to build expertise beyond rote coding.  #pause
+ *Engage with Operations and QA:* Understanding the full lifecycle of the software, including the perspective of those who test or deploy it, is critical. Carl highlights his experience testing his own code at _Amazon_ as a prime example of proactive quality assurance (13:45–14:58).  #pause
+ *Build Personal Projects:* Engaging in your own projects provides the best feedback loop, allowing you to encounter and fix bugs you created yourself, which is an invaluable learning experience.

= Google I/O

== Software Ecology

Even #link("https://www.youtube.com/watch?v=2n41YjR5QfU")[Google haven't figured it out yet].

In this Google I/O 2026 session, Adam Bender introduces *software ecology*—a holistic approach to viewing software engineering through the lens of sociotechnical systems. He argues that developers must understand their internal ecosystems as complex, adaptive systems to successfully navigate the rapid changes brought on by AI-driven development (0:26–5:42).

== Key Concepts

+ *The Google Example:* Using Google as a case study, he highlights how _shared fate_—manifested in their monolithic repository and standardized build tools—creates unique capabilities like _Large Scale Changes (LSCs)_, allowing developers to refactor millions of lines of code globally (5:51–12:17). #pause
+ *The 10x AI Tipping Point:* The core of the talk addresses the massive transformation caused by AI increasing developer velocity by orders of magnitude. Bender warns that traditional practices for testing, code review, and version control will likely break under 10x or 100x load, and teams must prepare by identifying bottlenecks now (14:36–24:09). #pause
+ *Strategic Adaptations:* As software systems become more brittle and complex, he advocates for a shift in perspective. Instead of focusing only on individual "trees" (tasks), engineers must manage the whole "forest" (the ecosystem). He emphasizes that AI acts as an *amplifier* for existing practices; if fundamentals like testing, security, and abstraction are poor, AI will only amplify that chaos (24:28–33:17).

=== Call to Action  #pause

Bender encourages senior engineers to mentor others and advocates for software quality, emphasizing that individuals have the agency to steer the future of their organizations (35:27–39:39).
