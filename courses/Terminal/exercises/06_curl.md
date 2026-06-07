# Lesson 5. `curl`: Downloading from the Internet

By the end of this lesson, you'll fetch your public IP, check weather, download cat images, parse API JSON, watch terminal animations, and understand exactly why `curl ... | bash` can be dangerous.

---

## 1) Mental Model: What `curl` Actually Does

`curl` is a command-line tool that sends a request to a URL and prints the response.

```text
you -> curl -> internet -> bytes -> your terminal
```

Flags decide:

- where output goes (`-o`, `-O`)
- what you inspect (`-I`, `-i`, `-v`, `-s`)
- behavior on redirects/errors (`-L`, `-f`)

---

## 2) Setup and Sanity Check

> PowerShell note: in Windows PowerShell, `curl` is usually an alias for `Invoke-WebRequest`.  
> To run real curl behavior consistently, use `curl.exe`.

### Check your version

```bash
# Linux/macOS (bash)
curl --version
```

```powershell
# Windows (PowerShell)
curl.exe --version
```

If curl is missing:

- macOS: usually preinstalled, or `brew install curl`
- Debian/Ubuntu: `sudo apt install curl`
- Windows: bundled on modern Windows; otherwise install from official curl docs

---

## 3) First Request: Read a Page

```bash
# Linux/macOS/Windows (use curl.exe on Windows)
curl https://example.com
```

You will see the HTML body printed in the terminal.  
Like other terminal tools, success is often quiet and direct: it just prints output and returns control.

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20https%3A%2F%2Fexample.com)

---

## 4) Fun, Friction-Free API Commands

These examples are from [awesome-console-services](https://github.com/chubin/awesome-console-services), filtered to no-signup/no-key commands:

Your public IP:

```bash
curl ifconfig.me
```

Weather:

```bash
curl wttr.in
curl wttr.in/Berlin
```

Quick command cheat sheet:

```bash
curl cheat.sh/tar
```

Dad joke:

```bash
curl https://icanhazdadjoke.com
```

---

## 5) Save Output to Files: `-o` vs `-O`

We'll use Creative Commons cat images from [Wikimedia Commons: Category:Cats](https://commons.wikimedia.org/wiki/Category:Cats) through `Special:FilePath`.

```bash
# Pick the output filename yourself
curl -L -o my_cat.jpg https://commons.wikimedia.org/wiki/Category:Cats#/media/File:Cat_November_2010-1a.jpg
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-L%20-o%20my_cat.jpg%20https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FSpecial%3AFilePath%2FCat_on_Wood.jpg)

```bash
# Keep the server's filename
curl -L -O https://commons.wikimedia.org/wiki/Special:FilePath/Cat_in_Fez.jpg
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-L%20-O%20https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FSpecial%3AFilePath%2FCat_in_Fez.jpg)

Why `-L`? `Special:FilePath` responds with a redirect. Without `-L`, you can save redirect content instead of the real image bytes.

Check that files exist:

```bash
# Linux/macOS
ls -lh *.jpg
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=ls%20-lh%20*.jpg)

```powershell
# Windows PowerShell
Get-ChildItem *.jpg
```

---

## 6) Be Defensive on the Web: `-L`, `-I`, `-f`

```bash
# Headers only (HEAD request)
curl -I https://commons.wikimedia.org/wiki/Special:FilePath/Cat_on_Wood.jpg
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-I%20https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FSpecial%3AFilePath%2FCat_on_Wood.jpg)

```bash
# Fail on HTTP errors, follow redirects, save remote name
curl -fLO https://commons.wikimedia.org/wiki/Special:FilePath/Cat_in_Fez.jpg
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-fLO%20https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FSpecial%3AFilePath%2FCat_in_Fez.jpg)

Quick interpretation:

- `-I`: inspect headers without downloading body
- `-L`: follow redirects
- `-f`: treat HTTP failures as command failure instead of quietly saving error pages

---

## 7) First Pipe Lesson: `|`

This is your first pipe in this course.

`A | B` means: take what `A` prints, pass it as input to `B`.

### Non-curl warm-up

```bash
# Linux/macOS
echo "hello world" | wc -w
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=echo%20%22hello%20world%22%20%7C%20wc%20-w)

```powershell
# Windows PowerShell
"hello world" | Measure-Object -Word
```

### Pipe with curl

```bash
# Linux/macOS
curl -s https://example.com | wc -w
```

```powershell
# Windows PowerShell
curl.exe -s https://example.com | Measure-Object -Word
```

`-s` means "silent", useful when piping.

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-s%20https%3A%2F%2Fexample.com%20%7C%20wc%20-w)

Pipes become very powerful when output is structured data (JSON).

---

## 8) What is JSON, and Why Should You Care?

**JSON** (JavaScript Object Notation) is a text format for structured data.

If you know Python, think: nested `dict` + `list`.

Example JSON:

```json
{
  "name": "Linus Torvalds",
  "followers": 250000,
  "public_repos": 8
}
```

Equivalent Python shape:

```python
{
  "name": "Linus Torvalds",
  "followers": 250000,
  "public_repos": 8
}
```

Why it matters: most modern APIs return JSON.

---

## 9) `jq`: Query Specific JSON Fields

Fetch real JSON:

```bash
curl -s https://api.github.com/users/torvalds
```

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-s%20https%3A%2F%2Fapi.github.com%2Fusers%2Ftorvalds)

That output is large. `jq` extracts what you need.

Install instructions: [jqlang/jq](https://github.com/jqlang/jq)

Common installs:

- macOS: `brew install jq`
- Debian/Ubuntu: `sudo apt install jq`
- Windows: `winget install jqlang.jq` or `choco install jq`

Check install:

```bash
jq --version
```

Now query fields:

```bash
# Pretty-print JSON
curl -s https://api.github.com/users/torvalds | jq

# Pick one field
curl -s https://api.github.com/users/torvalds | jq '.name'
curl -s https://api.github.com/users/torvalds | jq '.public_repos'

# Build a smaller object
curl -s https://api.github.com/users/torvalds | jq '{name, followers, public_repos}'
```

```powershell
# Same idea in PowerShell (use curl.exe)
curl.exe -s https://api.github.com/users/torvalds | jq '.name'
```

Takeaway: **curl fetches, jq extracts.**

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-s%20https%3A%2F%2Fapi.github.com%2Fusers%2Ftorvalds%20%7C%20jq%20%27.name%27)

---

## 10) Entertainment Break (No Signup)

From [awesome-console-services entertainment](https://github.com/chubin/awesome-console-services#entertainment-and-games):

```bash
curl parrot.live
curl ascii.live/forrest
curl ascii.live/nyan
```

These are long-running streams. Press `Ctrl+C` to stop.

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20parrot.live)

---

## 11) Scripts from the Internet: Utility vs Security

### The seductive one-liner

```bash
# Linux/macOS
curl -sL https://raw.githubusercontent.com/HassanAlgoz/AAI/main/scripts/curl_demo/roll.py | python3
```

```powershell
# Windows PowerShell
curl.exe -sL https://raw.githubusercontent.com/HassanAlgoz/AAI/main/scripts/curl_demo/roll.py | python
```

It looks convenient, but it executes remote code immediately with your user permissions. This demo is harmless: it downloads and opens a short Creative Commons video. A real unknown script could do much worse.

> Inspect: [explainshell](https://explainshell.com/explain?cmd=curl%20-sL%20https%3A%2F%2Fraw.githubusercontent.com%2FHassanAlgoz%2FAAI%2Fmain%2Fscripts%2Fcurl_demo%2Froll.py%20%7C%20python3)

### Why this is risky

`curl | python3` means: "download code from the internet and execute it now."

If that URL changes or is malicious, damage happens before you can inspect anything.

### Safer 3-step workflow

1. Download first.
2. Read the file.
3. Run only if you understand and trust it.

```bash
# Linux/macOS
curl -fLO https://raw.githubusercontent.com/HassanAlgoz/AAI/main/scripts/curl_demo/roll.py
less roll.py
python3 roll.py
```

```powershell
# Windows PowerShell
curl.exe -fLO https://raw.githubusercontent.com/HassanAlgoz/AAI/main/scripts/curl_demo/roll.py
notepad roll.py
python roll.py
```

`sudo` note: `sudo` runs a command with elevated (admin/root) privileges. We did not use it here, but you should be careful to never combine unknown internet scripts, especially with `sudo`.

---

## 12) Safety Checklist

Before running copied network commands:

- Do I trust this host/domain?
- Am I downloading, or executing?
- If executing, did I inspect the script first?
- Am I using `-fL` to avoid silent bad downloads?
- Do I know how to stop long-running output (`Ctrl+C`)?

---

## 13) Recap

You learned:

- downloads: `-o`, `-O`
- inspection: `-I`, `-s`
- behavior flags: `-L`, `-f`
- first pipeline: `|`
- JSON field extraction with `jq`

And most important: convenience commands are useful, but **trust and verification** come first.