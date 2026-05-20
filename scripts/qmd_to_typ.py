#!/usr/bin/env python3
import sys
import re

def convert_qmd_to_typ(content):
    # Base Touying presentation template to prepend
    typst_output = ""

    # 1. Handle Frontmatter & Extract Title
    frontmatter_match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, flags=re.DOTALL)
    if frontmatter_match:
        yaml_content = frontmatter_match.group(1)
        title_match = re.search(r'^title:\s*["\']?(.*?)["\']?$', yaml_content, flags=re.MULTILINE)

        if title_match:
            title_value = title_match.group(1)
            typst_output += f'#set document(title: "{title_value}")\n\n'

        # Remove the YAML frontmatter block from the rest of the body content
        content = re.sub(r'^---\s*\n.*?\n---\s*\n', '', content, flags=re.DOTALL)

    # Prepend the template configuration to the actual body content
    content = typst_output + content

    # 2. Convert Headers: '# Heading' -> '= Heading'
    content = re.sub(r'^(#{1,6})\s+(.+)$', lambda m: "=" * len(m.group(1)) + " " + m.group(2), content, flags=re.MULTILINE)

    # 3. Convert Bold FIRST: **bold** -> *bold*
    content = re.sub(r'\*\*(.*?)\*\*', r'*\1*', content)

    # 4. Convert Italic SECOND: *italic* -> _italic_
    content = re.sub(r'(?<!\*)\*(?!\*)(.*?)(?<!\*)\*(?!\*)', r'_\1_', content)

    # 5. Convert Numbered Lists: '1. Item' -> '+ Item'
    content = re.sub(r'^\s*\d+\.\s+', r'+ ', content, flags=re.MULTILINE)

    # 6. Convert Images with optional CSS classes: ![Alt](URL){.class} -> #image("URL")
    content = re.sub(r'!\[([^\]]*)\]\(([^)]+)\)(?:\{[^}]*\})?', r'#image("\2")', content)

    # 7. Convert Links: [Text](URL) -> #link("URL")[Text]
    content = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'#link("\2")[\1]', content)

    # 8. Convert Display Math: $$math$$ -> $ math $
    content = re.sub(r'\$\$(.*?)\$\$', r'$ \1 $', content, flags=re.DOTALL)

    return content

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 qmd_to_typ.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    if not input_file.endswith('.qmd'):
        return # Skip non-qmd files safely

    output_file = input_file.rsplit('.', 1)[0] + '.typ'

    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            qmd_text = f.read()

        typ_text = convert_qmd_to_typ(qmd_text)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(typ_text)

        print(r"Converted: {} -> {}".format(input_file, output_file))
    except Exception as e:
        print(r"Error processing {}: {}".format(input_file, e), file=sys.stderr)

if __name__ == "__main__":
    main()
