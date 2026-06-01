
### **Appendix: Windows `cmd` Translation Guide**

If you ever find yourself on a Windows machine without a Unix-like shell, here are the native equivalents for the commands you just learned:

| **Unix/macOS** | **Windows cmd Equivalent**            | **Purpose**         |
| -------------- | ------------------------------------- | ------------------- |
| `touch`        | `type nul > file.txt`                 | Create empty file   |
| `mkdir`        | `mkdir`                               | Create directory    |
| `cp`           | `copy` (files) / `xcopy` (folders)    | Copy items          |
| `mv`           | `move` (or `ren` to rename)           | Move/Rename         |
| `cat`          | `type`                                | Print file contents |
| `less`         | `more`                                | Scroll large files  |
| `head`         | `more +1` (rough equivalent)          | First lines         |
| `tail`         | `more -20` (rough equivalent)         | Last lines          |
| `find`         | `dir /s /b *.py`                      | Search files        |
| `cmp`          | `fc /b`                               | Compare files       |
| `df`           | `wmic logicaldisk get size,freespace` | Check disk space    |



| Command | Purpose | Example |
| --- | --- | --- |
| `pwd` | Print current working directory | `pwd` |
| `ls` | List directory contents | `ls -lah <dir>` |
| `file` | Determine file type / content info | `file script.sh` |
| `less` | View file contents with scrolling | `less log.txt` |
| `head` / `tail` | View beginning / end of a file | `tail -f log.txt` |
| `grep` | Search inside files for patterns | `grep "error" log.txt` |
