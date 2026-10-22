"""Contact sheet: python sheet.py <dir> <out.jpg> <every> [start] [count]"""
import sys, os
from PIL import Image, ImageDraw
d, out, every = sys.argv[1], sys.argv[2], int(sys.argv[3])
start = int(sys.argv[4]) if len(sys.argv) > 4 else 0
count = int(sys.argv[5]) if len(sys.argv) > 5 else 24
files = sorted(f for f in os.listdir(d) if f.endswith(".bmp"))[start::every][:count]
W, H, cols = 400, 225, 4
rows = (len(files) + cols - 1) // cols
sheet = Image.new("RGB", (W * cols, H * rows))
for i, f in enumerate(files):
    im = Image.open(os.path.join(d, f)).convert("RGB").resize((W, H))
    ImageDraw.Draw(im).text((5, 5), f[5:10], fill=(255, 255, 0))
    sheet.paste(im, ((i % cols) * W, (i // cols) * H))
sheet.save(out, quality=85)
print(len(files), "frames")
