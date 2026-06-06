# Lesson 1. Moving Around

Programs / apps we install are what we visually see and interact with the most. They are stored in files within folders/directories.

The purpose of this lesson is to to understand how to trace the visual elements to the black box terminal.

## The File System is Hierarchical 

Directories/folders contain others, down to the **File**. The bottom-most element with the suffix: `.txt`, `.py`, `.xsl`, known as the **File Extension** or _File Type_.

An installed program includes: binaries, libraries, and configurations. But different OSes have different ways in storing them:

1. Filing Cabinet approach (Linux)
2. Suitcase approach (Windows)
3. Hybrid: use of both

### Visualizing the Architectures

```text
   Windows (Suitcase)           Linux (Filing Cabinet)          macOS (Hybrid)
+-----------------------+     +--------+  +---------+     +-----------------------+
|  C:\Program Files\    |     | /bin/  |  | /lib/   |     |    /Applications/     |
|   +-- [App_Name]      |     |  (exe) |  | (shared)|     |     +-- [App.app]     |
|         |- app.exe    |     +--------+  +---------+     |           (bundle)    |
|         |- app.dll    |                                 +-----------------------+
|         |- config     |     (Scattered by file type)     (Hidden folder inside) 
+-----------------------+                                  

```

---

### 1. Windows: The "Suitcase" Method

Groups files by **Program**.

* **Philosophy:** Self-contained and isolated. Almost everything a program needs is packed into one dedicated folder.
* **Structure:** `C:\Program Files\app-name\`
* **Contents:** The executable (`.exe`), shared libraries (`.dll`), plugins, and configs sit together.

### 2. Linux: The "Filing Cabinet" Method

Groups files by **Type**.

* **Philosophy:** Shared resources and efficiency. If five programs need the same library, Linux stores it once centrally rather than duplicating it.
* **Structure:** A program is dissected and scattered:
* **Binaries (Commands):** `/usr/bin/app-name`
* **Libraries (Shared code):** `/usr/lib/`
* **Configs & Assets (Data):** `/usr/share/app-name/`



### 3. macOS: The Hybrid Method

The "Disguised Suitcase."

* **Philosophy:** Drag-and-drop graphical simplicity built on top of standard Unix rules.
* **Structure:** `/Applications/App-Name.app`
* **The Trick:** The `.app` file is an "App Bundle" (a disguised folder). Navigating inside via terminal reveals an internal structure containing specific binaries and libraries.
* **The Caveat:** Standard command-line tools still install into `/usr/bin/` and `/usr/lib/`, exactly like Linux.

---

### Understanding the File System

| Feature | Linux & MacOS | Windows |
| --- | --- | --- |
| **Hierarchy Root** | Single root starting at `/` | Partition-based (e.g., `C:\`, `D:\`) |
| **Path Separators** | Forward slash (`/`) | Backslash (`\`) |

**Path Types:**

* **Absolute Path:** Starts from the root directory (`/`). *Example: `/home/hgoz*`
* **Relative Path:** Starts from your current directory. *Example: `a/b/c*`
* `.` refers to the **current** directory.
* `..` refers to the **parent** directory.

---

### Navigation & Viewing

| Command | Purpose | Example |
| --- | --- | --- |
| `cd` | Change directory | `cd Desktop` |

**Helpful `cd` Shortcuts**:

* `cd` or `cd ~` : Go to your home directory.
* `cd -` : Go to the previous working directory.
* `cd ~` or `cd ~adam` : Go to user’s home directory.

---

# Hands-On Exercise: Tracking Down Your Programs

In this exercise, we will hunt down the Python executable on your system, open it in your visual file manager, and then explore its home directory using the terminal.

### Step 1 & 2: Find the Binary (`which` / `where`)

To interact with a program, you first need to know exactly where your operating system hid it.

**Run the locator command for your OS:**

* **macOS / Linux:** Type `which python3` and press Enter.
* **Windows:** Type `where python` and press Enter.

*Expected Output:* The terminal will print the absolute path to the executable file (e.g., `/usr/bin/python3` or `C:\...\python.exe`).

---

### Step 3: Open in File Explorer (The Manual Way)

Let's bridge the gap between the terminal and your visual interface. Copy the path outputted from Step 2, and use it with the open command for your system.

**Run the open command (paste your specific path):**

* **macOS:** `open -R /usr/bin/python3` *(The `-R` flag reveals it in Finder)*
* **Windows:** `explorer /select,"C:\...\python.exe"` *(Opens Explorer with the file highlighted)*
* **Linux:** `xdg-open /usr/bin/` *(Note: Linux requires the directory path, not the file path)*

---

### Step 4: Work Smarter with Command Substitution `$()`

Copying and pasting paths is slow. In Unix-based systems (macOS/Linux), you can use **Command Substitution** to make the terminal do the work for you. By wrapping a command in `$()`, the terminal runs that command *first* and plugs the answer directly into your main command.

We'll use three commands in a chain here (as in the Linux example):

1. `which python`
2. `dirname $`
3. `xdg-open $`

**Try this one-liner (macOS / Linux):**

```bash
# macOS
open $(dirname $(which python))

# Linux
xdg-open $(dirname $(which python))

# Windows (PowerShell)
explorer (Split-Path (where.exe python))

```

*How it works:* The system secretly runs `which python3`, gets the path, and instantly feeds it to `open -R`.

---

### Step 5: Change Directory (`cd`)

Now let's stay in the terminal and navigate to the folder containing Python. The `cd` command stands for **C**hange **D**irectory. You must use the path *up to* the folder, not the file itself.

**Navigate to the directory:**

* **macOS / Linux:** `cd /usr/bin`
* **Windows:** `cd C:\Users\Name\AppData\Local\Programs\Python\Python310`

---

### Step 6: Confirm Your Location (`pwd` / `cd`)

Before you start looking around, it is a good habit to confirm you landed in the right place.

**Print your current working directory:**

* **macOS / Linux:** Run `pwd`
* **Windows:** Run `cd` (with no path after it)

Your terminal will output the path of the directory you are currently standing in.

---

### Step 7: Inspect the Contents (`ls` / `dir`)

You are inside the folder. Let's look at the files.

**1. The Basic View:**
Run the list command by itself (`ls` on Mac/Linux, `dir` on Windows). You will see a massive, unformatted wall of text showing every file name.

**2. The Detailed View (Using Flags):**
Let's add options to make this readable and useful.

* **macOS / Linux:** Run `ls -lah`
* **Windows:** Run `dir /Q /A`

**Understanding the `-lah` Flags:**
In Unix systems, short flags can be separated (e.g., `-l -a -h`) or combined into a single block (`-lah`). This does the exact same thing, just like how Windows separates its flags (`/Q /A`).

* `-l`: **Long format** (shows permissions, owner, and date).
* `-a`: **All files** (includes hidden files that start with a dot).
* `-h`: **Human-readable** (shows sizes like `2M` instead of `2048000` bytes).

---

### Conclusion

You just successfully navigated the core loop of command-line file management. You located a hidden system binary, passed its path to a visual application, navigated to its core directory, and manipulated command structures to inspect files from anywhere on your machine.