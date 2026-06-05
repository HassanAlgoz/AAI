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
    title: [Applied AI Intro],
    subtitle: [An introduction to the bootcamp],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= introduction

== Pedagogy

#figure(
  image("/assets/00/tell_me_and_I_forget.png", width: 45%),
  caption: [Text on a board that reads: Tell me and I forget, teach me and I may remember, involve me and I learn.],
) <pedagogy>

== Capstone Project

Utilize various skills learned during the bootcamp to solve problems that needs AI.

Tentative schedule:
+ Ideation and team formation (by end of week 4)
+ Proposal, project plan, and approval (week 5)
+ Phase 1 (end of week 6): progress presentation
+ Phase 2 (end of week 7): progress presentation
+ Final submission and evaluation (week 8)

== Learning Material

1. 🧬 *Slides*: concepts, mental models, connecting ideas, and discussion.
2. 🔬 *Labs*: details, docs, debugging, and what-ifs.
3. ✍️ *Exercise Notebooks*: guided through step-by-step questions.
4. 📝 *Quizzes*: knowledge test.
5. 🎯 *Projects*: practice skills to achieve specific goals.
6. 💬 *Presentations*: express ability to communicate technically.

== Why Presentations?

Your success in life depends on three key elements: #pause

+ Your ability to *speak* #pause
+ Your ability to *write* #pause
+ The quality of your *ideas* #pause

.. in that order (as #link("https://www.youtube.com/watch?v=Unzc731iCUY")[Professor Winston puts it]).

Your ability to communicate ideas is ultimately more critical to your success than the ideas themselves.

== One-to-one check-ins

Random selection:
+ Show and explain your solutions to specific exercises
+ Questions about the learning material covered so far

== ❌️ Bad
+ Let AI do the work
+ Low attendance, come late, leave early
+ No clue what work to be done today, tomorrow, and end of week.


== ✅️ Good
+ You are honest and consistent in putting in the required effort in class
+ You pay attention to instructions and ask when things aren't clear
+ You ask the right questions; for the sake of learning
+ You are not afraid of making mistakes; for the sake of exceeding your limits
