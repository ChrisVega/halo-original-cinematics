import json

p = 'sheets/scenes.json'
d = json.load(open(p, encoding='utf-8'))
note = (" preroll_seconds: how long the creator's video runs, in seconds; the mod waits "
        "this long before its own scene takes over.")
if 'preroll_seconds' not in d['columns']:
    d['about'] = d['about'] + note
    d['columns'].append('preroll_seconds')
    for row in d['rows']:
        row.append(0)
    for row in d['rows']:
        if row[0] == 'a10_intro':
            row[d['columns'].index('preroll_seconds')] = 43
    json.dump(d, open(p, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
    print('scenes.json: preroll_seconds added')
else:
    print('already there')
