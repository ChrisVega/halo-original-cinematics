local S = require("ce_sound")
local s = S.new(arg[1], arg[2], arg[3])
local names = { [[sound\dialog\x10\keyes02]], [[sound\dialog\x10\cor07]], [[sound\sinomatixx\x10_music01]], [[sound\sinomatixx_foley\x10_foley1]], [[sound\dialog\x10\sgt05]] }
for _, n in ipairs(names) do print(n, s:find(n)) end
local done, missing = s:prepare(names)
print("decoded", done, "missing", #missing)
for _, n in ipairs(names) do local w = s:wav(n); print(n, w and string.format("%.2fs", S.wav_seconds(w)) or "none") end
