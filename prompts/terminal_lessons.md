Your task is to write a tutorial for beginner users, in an effective best practice, hands-on manner. Novice programmers rarely interact with the terminal because, to them:

1. really hard to tell what needs to be typed to get the desired output (memorization)
2. it feels unforgiving of mistakes and really  hard to know what to do if something goes wrong (cryptic error messages)

Why learn terminal commands?

- Faster for repetitive tasks (rename/copy/search many files)
- Works the same on local machine, servers, and cloud VMs
- Easier to automate and document exact steps
- Needed for many developer tools (`git`, `python`, package managers)
- Useful when GUI is unavailable or too slow

When terminal beats GUI:

- You need to process many files at once
- You want reproducible steps in notes/scripts
- You work over SSH on a remote Linux machine
- You debug environments and paths quickly
- You chain commands into one workflow

However, these points are out-of-reach for a person who doesn't have a good idea of what they mean in the first place.

So, the overarching goal for this is to build tutorials, in parts, to demonstrate how the command line is actually very useful for a programmer / software engineer / data scientists. We'll then expand the idea into scripting (but we'll use Python instead since it is both cross-platform and where the students home some background).

The tutorial may be split into multiple parts, each of which targeting specific set of basic skills.
We always provide hints and context, such that user knows what's going on.
We need to motivate the tutorial not by saying what others are using it for, but rather, what the user him/herself can use it for; as a programmer.
You can assume the user is familiar with Python, but have no idea about bash or shell scripting, or even what the terminal is all about.

Let's start the tutorial assuming a Unix-like shell like Bash that works for (macOS / Linux).

Always accomodate for Linux (bash), MacOS, and Windows systems (PowerShell).

Covered so far (which you'll find in this path: `courses/00_Intros` ):

1. Motivation (what and why)
2. Moving around (cd, pwd, ..etc)
3. Commands Grammar
4. Version control (with Git)
5. Command runners (with just)

Now I want to cover how the curl command works to download images, scripts, and from the internet, which can potentially be dangerous.

Edit the lesson here: `courses/00_Intros/L5/01_curl.md`