#!/usr/bin/python3
import os
import re
import sys

HEX_PATTERN = re.compile(r'#([0-9a-fA-F]{6})')

def rotate_until_target_dominates(hexcode, target):
    """Rotate hexcode until target channel is max, or return original if equal channels."""
    r = int(hexcode[0:2], 16)
    g = int(hexcode[2:4], 16)
    b = int(hexcode[4:6], 16)

    values = [r, g, b]
    target_index = {'r': 0, 'g': 1, 'b': 2}[target]

    # If all equal, just return original
    if values[0] == values[1] == values[2]:
        return hexcode

    # Rotate up to 3 times until target channel is highest
    for _ in range(3):
        if values[target_index] >= max(values):
            break
        values = values[1:] + values[:1]  # rotate left
    return ''.join(f"{v:02x}" for v in values)


def process_file(filepath, target):
    try:
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    except Exception as e:
        print(f"[!] Skipping unreadable file: {filepath} ({e})")
        return None

    def replacer(match):
        hexcode = match.group(1)
        newcode = rotate_until_target_dominates(hexcode, target)
        return f"#{newcode}"

    return HEX_PATTERN.sub(replacer, content)


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <directory> <r|g|b>")
        sys.exit(1)

    root_dir = os.path.expanduser(sys.argv[1])
    target = sys.argv[2].lower()
    if target not in ('r', 'g', 'b'):
        print("Target colour must be 'r', 'g', or 'b'")
        sys.exit(1)

    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            full_path = os.path.join(dirpath, filename)
            new_content = process_file(full_path, target)
            if new_content is None:
                continue

            # Write to new file (e.g., file.css -> file.css.new)
            new_path = full_path + ".new"
            with open(new_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print(f"[+] Processed: {full_path} -> {new_path}")


if __name__ == "__main__":
    main()
