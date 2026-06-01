# Lesson 2. Commands Grammar

## Anatomy of a Command

Most commands follow this pattern:

```bash
command [options] [required-args] [optional-args]

```

- **Required Arguments**: are mandatory
    - `mv old.txt new.txt`

- **Optional Arguments** change behavior of the command
      - **Short** flags: `-a`, `-l`, `-n 10`
      - **Long** flags: `--all`, `--help`

- Most commands allow combining short flags like `ls` in this way: `ls -la`
- Always check exact syntax in docs (`man command` or `command --help`)

### Exercise 1: Trying the `ls` command options

Let's prove that you don't need to manually change directories to inspect files if you know how to combine commands.

1. **Open a completely new terminal window.**
2. **Check your location:** Run `pwd` (or `cd` on Windows) to confirm you are back in your default home folder.
3. **Inspect from afar:** Now, list the detailed metadata of the Python binary directly from where you are standing by combining `ls` with your locator command:

```bash
# macOS / Linux
ls -lah $(which python3)

```

By substituting the path directly into the `ls` command, you bypassed the need to navigate there entirely!

---

## Exercise 2: recognize parts

Identify **Required Arguments** and **Optional Arguments** in the following commands:

```bash
head -n 5 README.md
cp -r src_dir backup_dir
find . -name "*.qmd"
```

## Getting Help

When you don't know what a command does, use the system's built-in manuals:

| Command | Purpose |
| --- | --- |
| `man` | Display the full manual page for a command |
| `help` | Get help for shell built-in commands |
| `type` | Show how a command name is interpreted |
| `which` | Display the exact path of the executable program |
| `apropos` | Search manual page descriptions for a keyword |
| `whatis` | Display one-line manual page descriptions |
| `info` | Display comprehensive info entries |

**External Resources:**

* **ExplainShell:** [https://explainshell.com/](https://explainshell.com/) (Visually breaks down complex commands)
* **TLDR Pages:** [https://tldr.sh/](https://tldr.sh/) (Simplified, community-driven man pages)

> **The Golden Rule:** Think twice before executing or copying any commands you don’t fully understand!

---

### Exercise 3: Try three of these commands

| **Linux**  | **Purpose**                     | **Windows CMD (Classic)**                 | **PowerShell (Modern)**                                      |
| ---------- | ------------------------------- | ----------------------------------------- | ------------------------------------------------------------ |
| `date`     | Displays current time and date  | `date /t` and `time /t`                   | `Get-Date`                                                   |
| `df`       | Shows free disk space           | `wmic logicaldisk get caption, freespace` | `Get-Volume`                                                 |
| `free`     | Displays free memory (RAM)      | `systeminfo \| find "Memory"`             | `(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory` |
| `lscpu`    | Displays CPU architecture info  | `wmic cpu get name, numberofcores`        | `Get-CimInstance Win32_Processor`                            |
| `uname -a` | Displays system and kernel info | `systeminfo` or `ver`                     | `Get-ComputerInfo`                                           |
| `whoami`   | Displays current active user    | `whoami`                                  | `whoami`                                                     |
| `clear`    | Clears the terminal screen      | `cls`                                     | `cls` (or `clear`)                                           |
| `history`  | Shows past run commands         | `doskey /history` (or press `F7`)         | `Get-History` (or `history`)                                 |
