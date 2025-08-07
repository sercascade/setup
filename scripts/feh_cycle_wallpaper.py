#!/usr/bin/env python3

import os
import sys
import time
import random
import subprocess
from pathlib import Path
from inotify_simple import INotify, flags

IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.bmp', '.gif', '.webp'}

def is_image(file_path):
    return Path(file_path).suffix.lower() in IMAGE_EXTENSIONS

def set_wallpaper(image_path):
    subprocess.run(['feh', '--bg-fill', str(image_path)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def get_images_from_folder(folder):
    return [f for f in Path(folder).iterdir() if f.is_file() and is_image(f)]

def cycle_images(folder, interval):
    inotify = INotify()
    watch_flags = flags.CREATE | flags.MOVED_TO | flags.DELETE | flags.MOVED_FROM
    wd = inotify.add_watch(folder, watch_flags)

    current_list = get_images_from_folder(folder)
    while True:
        if not current_list:
            time.sleep(1)
            continue
        random.shuffle(current_list)
        for image in current_list:
            if not image.exists():  # In case it was deleted mid-cycle
                continue
            set_wallpaper(image)
            # Wait or break early if directory changes
            timeout = interval
            while timeout > 0:
                try:
                    events = inotify.read(timeout=1000)
                except BlockingIOError:
                    events = []

                if events:
                    current_list = get_images_from_folder(folder)
                    break
                timeout -= 1

def main():
    if len(sys.argv) != 3:
        print("Usage: wallpaper_cycle.py <path-to-folder-or-image> <interval-seconds>")
        sys.exit(1)

    path = Path(sys.argv[1]).expanduser().resolve()
    interval = int(sys.argv[2])

    if not path.exists():
        print(f"Path not found: {path}")
        sys.exit(1)

    if path.is_file() and is_image(path):
        while True:
            set_wallpaper(path)
            time.sleep(interval)
    elif path.is_dir():
        cycle_images(path, interval)
    else:
        print("Not a valid image file or directory containing images.")
        sys.exit(1)

if __name__ == "__main__":
    main()

