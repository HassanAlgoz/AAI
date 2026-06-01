**1. Project Setup & Version Control**

Let's create a workspace, track it with Git, and set up our ignore rules. Open your terminal and run these sequentially:

```bash
cd Desktop
mkdir my_project
cd my_project

```

Initialize your Git repository:

```bash
git init

```

Create a `.gitignore` file so Git knows which files to ignore (like local environments or generated folders):

```bash
touch .gitignore

```

Append our ignore rules (remember, `>>` appends, `>` overwrites):

```bash
echo ".env" >> .gitignore
echo ".venv" >> .gitignore
echo "outputs/" >> .gitignore

```

---

### **2. Verification & Inspection**

Let's make sure those lines were actually written.

**Method A: Print the whole file**

```bash
cat .gitignore

```

*(Alternatively, use `head .gitignore` for the top lines, `tail .gitignore` for the bottom lines, or `less .gitignore` to scroll if it were a massive file).*

**Method B: Search for a specific entry**

```bash
grep ".venv" .gitignore

```

> **How `grep` works:** It stands for **G**lobally search for a **R**egular **E**xpression and **P**rint. It scans the target file line by line, looking for the exact text pattern you provided (`".venv"`). If it finds a match, it prints that specific line to your screen.

---

### **3. The Editor & Git Integration**

Now we hand off to our GUI tools while keeping the terminal driving.

Open the current directory (`.`) in VS Code:

```bash
code .

```

1. Inside VS Code, create a file named `script.py`.
2. Write a simple Python script: `print("Hello from the terminal!")`
3. Save the file.

Back in your terminal, verify the code works:

```bash
python script.py

```

Stage the file in Git:

```bash
git add script.py

```

*Visual Check:* Open the "Source Control" (Git) explorer tab in VS Code. You will see `script.py` moved to the "Staged Changes" list.

Commit the file:

```bash
git commit -m "Initial commit with hello world script"

```

*Visual Check:* Look at the VS Code Git explorer again. The staging area is now clean, confirming your commit was saved to history.

---

### **4. Advanced Manipulation: Nesting, Finding, and Executing**

Let's simulate a bulk image optimization task. First, we need a nested folder structure.

```bash
mkdir -p assets/images/raw

```

> **How `-p` works:** The "parents" flag tells `mkdir` to build the entire chain. Without `-p`, this command would fail because `assets/` and `images/` don't exist yet. With `-p`, it creates them all in one go.

Create some dummy image files to work with:

```bash
touch assets/images/raw/hero.png assets/images/raw/logo.png

```

**Find and Check Sizes:**
Combine `find` with the list command (`ls -lh`) to see where your images are and how big they are:

```bash
find assets -name "*.png" -exec ls -lh {} +

```

- `find assets`: Look inside the assets folder.
- `-name "*.png"`: Only target PNG files.
- `-exec`: Run the following command (`ls -lh`) on whatever you find.
- `{} +`: Plugs the found files into the command and executes it.

**Find and Compress:**
Assuming you have `oxipng` installed, you can use the exact same logic to batch-compress every PNG deeply nested in your project, entirely replacing a tedious manual task:

```bash
find assets -name "*.png" -exec oxipng -o 4 {} +

```

### **5. Automating the Workflow with `just**`

By now, you have learned that the terminal is incredibly powerful, but typing out long commands like `find assets -name "*.png" -exec oxipng -o 4 {} +` every single time is tedious.

Developers use "command runners" to save these long scripts as short, memorable aliases. We are going to use [**`just`**](https://github.com/casey/just#quick-start), a modern and wildly popular command runner.

If you don't have it installed yet, you can usually grab it via your system's package manager (e.g., `brew install just` on macOS, `sudo apt install just` on Ubuntu, or `cargo install just` if you use Rust).

Let's turn your complex image-compression command into a permanent shortcut.

**1. Create a `justfile**`
A `justfile` (no extension) is where you define your "recipes" (commands). In your terminal, run:

```bash
touch justfile

```

**2. Write your recipes**
Open the `justfile` in VS Code and add the following lines exactly as shown. *(Note: `just` is flexible, but it's best practice to indent the commands under the recipe name).*

```justfile
# Default recipe (runs when you type 'just' alone)
default:
    @just --list

# Compress all PNG images in the assets directory
compress-images:
    @echo "Compressing images..."
    find assets -name "*.png" -exec oxipng -o 4 {} +

```

*(The `@` symbol simply tells `just` to run the command quietly without printing the raw command syntax to the screen first).*

**3. Test your new automation**
Back in your terminal, simply type:

```bash
just

```

Because of the `default` recipe we set up, this will automatically print a neatly formatted list of all available commands in your project. You should see `compress-images` listed.

Now, run your newly minted command:

```bash
just compress-images

```

Instead of memorizing flags, wildcards, and execution paths, you have permanently automated a complex task into two words. This is how professional developers turn the terminal from a scary blank screen into a customized productivity engine.

### **6. Keeping Code Clean: Enter `ruff**`

As you write more Python, your code will inevitably get messy. You need a **linter** (to catch errors before you run the code) and a **formatter** (to automatically fix spacing and style).

**Key Core Elements of [`ruff`](https://docs.astral.sh/ruff/):**

* **What it is:** An incredibly fast Python linter and formatter.
* **Why it wins:** It replaces a dozen older, slower tools (`flake8`, `black`, `isort`) with one single program.

Let's install it and wire it into our automation pipeline.

**Step 1: Install Ruff**
Since you are already working with Python, you can install it using Python's package manager (`pip`):

```bash
pip install ruff

```

**Step 2: Update your `justfile**`
Open your `justfile` in VS Code. We are going to add two new recipes below your `compress-images` block so you never have to memorize the `ruff` commands.

Append this text exactly:

```justfile
# Check for code errors and bad practices
lint:
    @echo "Linting Python code..."
    ruff check .

# Auto-format code to industry standards
format:
    @echo "Formatting Python code..."
    ruff format .

```

**Step 3: Test your new workflow**

1. Open your `script.py` in VS Code.
2. Intentionally mess up the formatting (add random spaces, extra blank lines, or single quotes instead of double quotes) and save it.
3. In your terminal, run your new command:

```bash
just format

```

When you look back at `script.py`, `ruff` will have instantly snapped your code back into perfect, standardized formatting. You now have a professional-grade development pipeline running entirely from your terminal.