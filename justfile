set ignore-comments

# List available recipes by default
default:
    @just --list

# Pick a .typ file with fzf and start `typst watch` on it
watch:
    # How it breaks down:
    # fzf: Recursively lists all files in your current directory and opens an interactive, searchable interface.
    # Just start typing any part of the filename or path.
    # xargs -o: Takes the file path you selected and appends it to the next command.
    # The -o flag is crucial here—it ensures `typst watch` can still safely take control of your terminal input.
    fzf | xargs -o typst watch --root .

# Compress PNG assets in-place with oxipng
compress:
    @echo "Compressing PNG assets..."
    @find assets/ -type f -name '*.png' -print0 | xargs -0 -I{} oxipng -o 4 --strip safe --alpha {}

# Compile every .typ under courses/ to pdf/<name>.pdf. Pass force=1 to overwrite.
compile force="0":
    #!/usr/bin/env bash
    set -euo pipefail
    while IFS= read -r file; do
        filename=$(basename "$file" .typ)
        target="pdf/${filename}.pdf"
        if [ -f "$target" ] && [ "{{force}}" != "1" ]; then
            echo "Skipping ${filename}.pdf (already exists)"
        else
            echo "Compiling $file -> $target"
            typst compile "$file" "$target" --root .
        fi
    done < <(find courses/ -name "*.typ")

# Force recompile of all .typ files
recompile: (compile "1")

# Compile every .typ under courses/ to pdf/<course>_<name>.pdf (mirrors the release-pdfs GitHub workflow)
release:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p pdf
    while IFS= read -r file; do
        name=$(basename "$file" .typ)
        course=$(echo "$file" | cut -d/ -f2)
        out="pdf/${course}_${name}.pdf"
        echo "Compiling $file -> $out"
        typst compile "$file" "$out" --root . --font-path /usr/share/fonts
    done < <(find courses/ -name '*.typ')

# Run every executable script in scripts/check/
check:
    #!/usr/bin/env bash
    set -e
    echo "Running all scripts in scripts/check/..."
    for script in scripts/check/*; do
        if [ -x "$script" ]; then
            echo "Running $script..."
            "$script"
        else
            echo "Skipping $script (not executable)"
        fi
    done
