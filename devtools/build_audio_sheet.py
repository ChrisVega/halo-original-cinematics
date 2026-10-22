"""Build the audio sheet from the original cutscene's decoded audio.

Every file in research/audio/original_ce came out of the player's own Master Chief
Collection (the original Halo CE sound banks) with vgmstream. The sheet lists them
with their length; the moment each one starts in the cutscene comes from the
original's own cutscene script and is filled in as the timing is worked out.
"""
import json
import os
import re
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, ".."))
AUDIO = os.path.join(ROOT, "research", "audio", "original_ce")
FFMPEG = os.path.join(ROOT, "mod", "OriginalCinematics", "tools", "ffmpeg", "ffmpeg.exe")
SPEAKERS = {
    "keyes": "Captain Keyes",
    "cor": "Cortana",
    "sgt": "Sergeant Johnson",
    "mar": "the technician (Mar)",
    "tec": "the technician (Mar)",
    "ass": "the assault trooper",
}


def speaker_of(name):
    m = re.search(r"x10_([a-z]+?)\d", name)
    return SPEAKERS.get(m.group(1), "unknown") if m else ""


def kind_of(name):
    if "music" in name:
        return "music"
    if "foley" in name:
        return "foley"
    return "voice"


def length_of(path):
    out = subprocess.run([FFMPEG, "-hide_banner", "-i", path], capture_output=True, text=True)
    m = re.search(r"Duration: (\d+):(\d+):(\d+\.\d+)", out.stderr)
    if not m:
        return None
    h, mnt, s = int(m.group(1)), int(m.group(2)), float(m.group(3))
    return round(h * 3600 + mnt * 60 + s, 3)


def main():
    rows = []
    for name in sorted(os.listdir(AUDIO)):
        if not name.endswith(".wav"):
            continue
        rows.append({
            "file": name,
            "speaker": speaker_of(name),
            "kind": kind_of(name),
            "length_s": length_of(os.path.join(AUDIO, name)),
            "starts_at_s": None,
            "source": "Halo CE sound banks, the player's own Master Chief Collection",
        })
    sheet = {
        "what": "one row = one sound of the original's A10 cutscene (x10)",
        "note": "starts_at_s is filled from the original's own cutscene script; "
                "nothing is guessed",
        "columns": ["file", "speaker", "kind", "length_s", "starts_at_s", "source"],
        "rows": rows,
    }
    out = os.path.join(ROOT, "sheets", "audio.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(sheet, f, indent=2, ensure_ascii=False)
    print("wrote", out, len(rows), "rows")


if __name__ == "__main__":
    main()
