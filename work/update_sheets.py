import json

# --- scenes.json: add the preroll_video column ---
p = 'sheets/scenes.json'
d = json.load(open(p, encoding='utf-8'))
note = (" preroll_video: a video of the creator's own, played in the remake's video slot "
        "before the original scene takes over (the remake's own video is swapped for it and "
        "its sound muted); the path is relative to the mod folder. The remake's cutscene is "
        "ended when the video is over, then the original scene plays, then the mission starts.")
if 'preroll_video' not in d['columns']:
    d['about'] = d['about'] + note
    d['columns'].append('preroll_video')
    for row in d['rows']:
        row.append('')
    for row in d['rows']:
        if row[0] == 'a10_intro':
            row[d['columns'].index('preroll_video')] = 'media/into_outer.mp4'
    json.dump(d, open(p, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
    print('scenes.json: preroll_video added')

# --- flights.json: the B30 Pelican work is abandoned, drop the row ---
p = 'sheets/flights.json'
d = json.load(open(p, encoding='utf-8'))
if d['rows']:
    d['about'] = d['about'] + ' (The B30 Pelican ride work was abandoned; this sheet is empty.)'
    d['rows'] = []
    json.dump(d, open(p, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
    print('flights.json: row removed')
