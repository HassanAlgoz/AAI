# Course: Terminal

- L0 [Terminal: Motivation](L1/01_motivation.md) (15m)
- L1 [Moving Aronud](L1/02_moving_around.md) (20m)
- L2 [Commands Grammar](L2/01_commands_grammar.md) (20m)
- L3 [Version Control](L3/01_version_control.md)  (45m)
- L4 [Command Runners](L4/01_command_runners.md) (30m)
- L5 [Client for URLs: `curl`](L5/01_curl.md) (50m)

### Tools

#### Version Control System

[Install Git](https://git-scm.com/): a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.  
    Git is [lightning fast](https://git-scm.com/about) and has a huge ecosystem of [GUIs](https://git-scm.com/tools/guis), [hosting services](https://git-scm.com/tools/hosting), and [command-line tools](https://git-scm.com/tools/command-line).

#### Integrated Development Environment

* **[Zed](https://zed.dev/):** A high-performance, multiplayer code editor written in Rust. It focuses on extreme speed, native collaborative editing, and fast out-of-the-box AI integration without the bloat of Electron.
* **[Lapdev](https://lap.dev/lapce/):** A lightning-fast, Rust-based editor featuring a native GUI. It is built from the ground up to support remote workspaces and remote development seamlessly.
* **[VS Code](https://code.visualstudio.com/):** Microsoft's ubiquitous, highly extensible editor. It dominates the market with its massive extension ecosystem, robust debugging, and broad multi-language support.
  * **[VSCodium](https://vscodium.com/):** The most direct replacement. It is the exact same underlying codebase as VS Code, but compiled without Microsoft's telemetry, tracking, and proprietary branding.
  * **[Positron](https://positron.posit.co/):** A data science IDE by Posit (makers of RStudio). Built on the VS Code base, it is specifically tailored for R and Python workflows, data exploration, and reproducible authoring.
  * **[Cursor AI](https://cursor.com/home):** An AI-centric fork of VS Code. It prioritizes deeply integrated, codebase-wide AI assistance, allowing for intelligent multi-line predictions and natural-language code generation.
  * **[Anti Gravity](https://antigravity.google/):** Google's "agent-first" development platform. Forked from VS Code, it introduces a dual-pane interface (Editor and Agent Manager) that allows autonomous, Gemini-powered AI agents to plan, verify, and execute coding tasks in parallel.

#### Command Runner

- [**just**](https://github.com/casey/just#quick-start) a handy way to save and run project-specific commands.  
    Alternatve to: [Make](https://www.gnu.org/software/make/)
