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
    title: [AAI Bootcamp],
    subtitle: [An introduction to the Applied Artificial Intelligence Bootcamp],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= AAI Bootcamp

== Overview

The Applied Artificial Intelligence Bootcamp is a 8-week course that teaches you the skills to apply AI to real-world problems.

=== What's a "Bootcamp"?

A bootcamp is a short-term, intensive training program designed to quickly impart practical skills. It is typically focused on a specific topic or skill set and is structured to maximize learning through hands-on experience and immediate application.

=== What is "Applied"?

The focus of the bootcamp is to acquired applied skills to solve real-world problems. We won't cover much theory or focus on mathematical details. Rather, we will focus on *mental models* and *working examples*.

== What is "Artificial Intelligence"?

*Artificial intelligence (AI)* is the capability of computational systems to perform tasks typically associated with human intelligence, such as learning, reasoning, problem-solving, perception, and decision-making.

== Related fields

To reach these goals, AI researchers have used techniques including state space search, *mathematical optimization*, formal logic, *artificial neural networks*, and methods based on *statistics*, operations research, and economics.

#figure(image("/courses/Intro/assets/related_fields.png", width: 65%), caption: [AI = Computer Science + Mathematics + Statistics])

== Use Cases of AI

Few of many many use cases:

- *Content moderation* and *audience analytics* (social media).
- *Ministry of Health*: population health forecasting from electronic health records (COVID-19 pandemic).
- *Predictive maintenance* to reduce downtime.
- *Educator support*: content creation, assessment automation, ..etc.

..what else?

== Roadmap

The bootcamp has a shared *Core*, two career tracks (*Analysts* and *Engineers*), a shared merge course, and optional Level 3 advanced work.
The roadmap was designed with career paths in mind — to help you land a job (Inshallah).

You can read it from the end (bottom to top): start from *job roles*, then work back through the courses that build the knowledge, skills, and mindset to get your foot in the door.

#figure(image("/assets/aai_roadmap.png", width: 90%), caption: [AAI Courses Roadmap])

== Courses Outline

=== Core

- *Python*: programming foundations (external material).
- *Terminal*: command and conquer your machine; fear not the black box; protect yourself from malicious code.

=== Analysts Track

- *Data Analysis*: fundamentals of data wrangling and analysis in Python via pandas, matplotlib, and seaborn.
- *Statistical Analysis*: calculate, analyze, visualize, and extract insights from data; formulate hypotheses and draw conclusions.
- *Inferential Statistics*: generalize results from samples onto a target population.
- *Applied Timeseries Analysis*: visualize, analyze, and forecast time series.

=== Engineers Track

- *Software Engineering*: software design and construction fundamentals.
- *Agentic Engineering*: work effectively with AI in software engineering projects.
- *Building with Deep Learning*: select, use, compose, fine-tune, and deploy open-weight deep learning models.
- *Building with Agentic AI*: develop, debug, evaluate, deploy, and monitor LLM-driven AI agents.

=== Level 2

- *Applied Machine Learning*: build reliable predictive modeling pipelines; reached from either track.

=== Level 3

- *Building Machine Learning Systems*: design and operate production ML systems (advanced).

== Pre-requisites

+ English B2 (Upper-Intermediate) level: IELTS 6.5 or TOEFL 80. #pause
+ Algorithmic thinking and problem-solving skills. #pause
+ Strong foundation in programming. #pause
+ Working laptop with internet access.

== Assessment

- Attendance
- Quizzes
- Projects (and presentations)
- One-to-one check-ins
- Final project

== AI Policy

Good use of AI means it *augments, rather than replaces, thinking* — used for feedback, hints, explanations, practice, or extra resources, while *you still do the core reasoning, writing, and problem-solving*. #pause

*Forbidden use*: treating course material as "work" and AI as an assistant to get it done "faster" or "easier" or "better". Don't mix productivity (output) with learning (you). #pause

See the research and findings that made up our AI Policy at: `/docs/ai_policy.md`.

== No Pain, No Gain: Real Learning Demands Effort

Growth comes from pushing yourself out of your comfort zone. The challenges and frustrations you encounter while learning—struggling with new concepts, debugging stubborn errors, or feeling stuck—are not obstacles to avoid, but signs that you are building new skills. Enduring and overcoming these difficulties is what makes your progress meaningful and lasting.

- If you keep using AI, then employers won't have the incentive to hire you over the AI.
- If you invest in yourself, you will be an invaluable asset that employers seek you.

== Assigned Exercises

- Exercises are due Thursday 11:59 PM (end of same week).
- Work must be pushed to GitHub.
- Mark as done in Google Classroom before then.
- Commit history *MUST* follow the #link("https://github.com/HassanAlgoz/AAI/blob/main/docs/proof-of-work.md", [proof-of-work]) system.

== Trainers' Expertise

=== Classroom discussions

- Active participation is at the heart of our learning process. Share your thoughts, ask questions, and collaborate with your peers during discussions—you’ll learn more by engaging, challenging ideas, and building on each other’s perspectives.
- Remember: no question is too simple, and your contributions can help others as much as they help you.

#pagebreak()

=== One-to-one check-ins

- Insturctors will randomly select you (5-10 minutes) to show and explain your solutions to specific parts of the course material, an interview-like setting.
- This is a great opportunity to get feedback on your work and to improve your skills.

== Honesty

*Collaboration* is encouraged other than in individual tests.

*Cheating* is a serious violation of the bootcamp's code of conduct. It undermines the learning experience for everyone, and harms the reputation of the bootcamp. #pause

*Punishment*: #pause _expulsion from the bootcamp_. #pause

If you are honest, hard-working, and persistent, expect good treatment. If you are dishonest, you will be treated as such!

== Learning Material

- *Lessons*:
  - 🧬 *Slides*: concepts, mental models, connecting ideas, and discussion.
  - 🔬 *Labs*: details, docs, debugging, and what-ifs.
- ✍️ *Exercises*: step-by-step guided questions.
- 📝 *Quizzes*: knowledge test.
- 🎯 *Projects*: practice skills to achieve specific goals.
  - 💬 *Presentations*: express ability to communicate technically.

== Why Presentations?

Your success in life depends on three key elements: #pause

+ Your ability to *speak* #pause
+ Your ability to *write* #pause
+ The quality of your *ideas* #pause

.. in that order (as #link("https://www.youtube.com/watch?v=Unzc731iCUY")[Professor Winston puts it]).

This prepares you for the real world, where you will need to communicate your ideas to others in the future, as well as for the *final project presentation*.

== Final Project

A group project in which you will build an Agentic AI System to automate tasks involving unstructured data.

Tentative schedule:
+ (week 4) Team formation and brainstorming
+ (week 5) Proposal and approval
+ Progress presentation 1 (end of week 6)
+ Progress presentation 2 (end of week 7)
+ Final submission (week 8: Tuesday)
+ Evaluation: Wednesday and Thursday
