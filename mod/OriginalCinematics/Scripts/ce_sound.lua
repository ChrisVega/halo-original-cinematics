-- Original CE sounds from the player's MCC sound banks (halo1\sound\pc):
-- each bank's .lst.bin maps a sound tag name ("sound\dialog\x10\keyes02") to
-- a stream index in the matching .fsb; the bundled vgmstream decoder turns the
-- needed ones into .wav files in the mod's cache. Nothing from the game ships
-- with the mod. Music prefers the original score (sound\old_music\...).

local S = {}
S.__index = S

local unpack = string.unpack

local BANKS = { "sounds_dialogs", "sounds_stream", "sounds_music" }

function S.read_list(path)
    local f = io.open(path, "rb"); if not f then return {} end
    local d = f:read("a"); f:close()
    local _, count = unpack("<I4I4", d, 1)
    local p, names = 9, {}
    for _ = 1, count do
        local n = unpack("<I4", d, p); p = p + 4
        local name = d:sub(p, p + n - 1):match("^[^%z]*"); p = p + n
        local first, cnt = unpack("<I4I4", d, p); p = p + 8
        names[name:lower()] = { index = first, count = cnt }
    end
    return names
end

local function exists(path)
    local f = io.open(path, "rb"); if f then f:close(); return true end
    return false
end

-- sound_dir: <MCC>\halo1\sound\pc ; tool: vgmstream-cli.exe ; cache: writable folder
-- encoder (optional): ffmpeg.exe, turns each .wav into an AAC .mp4 the remake's
-- media player (Electra) can play.
function S.new(sound_dir, tool, cache, encoder)
    local self = setmetatable({ dir = sound_dir, tool = tool, cache = cache, encoder = encoder, lists = {} }, S)
    for _, b in ipairs(BANKS) do self.lists[b] = S.read_list(sound_dir .. "\\lst\\" .. b .. ".lst.bin") end
    return self
end

-- Bank and stream index for a sound tag name (music: the original score first).
function S:find(tag_name)
    local n = tag_name:lower()
    local old = n:gsub("^sound\\sinomatixx\\", "sound\\old_music\\sinomatixx\\")
    for _, cand in ipairs({ old, n }) do
        for _, b in ipairs(BANKS) do
            local e = self.lists[b][cand]
            if e then return b, e.index end
        end
    end
end

function S:wav_path(tag_name)
    return self.cache .. "\\" .. tag_name:gsub("[\\/ ]", "_") .. ".wav"
end

-- Decodes every listed sound that isn't cached yet, in one batch (one hidden
-- console run). Returns the number decoded and the names it could not find.
function S:prepare(names)
    local lines, missing, todo = { "@echo off" }, {}, 0
    for _, name in ipairs(names) do
        local out = self:wav_path(name)
        local mp4 = self:mp4_path(name)
        local bank, index = self:find(name)
        if not bank then
            missing[#missing + 1] = name
        else
            if not exists(out) then
                lines[#lines + 1] = string.format('"%s" -s %d -o "%s" "%s\\%s.fsb" >nul 2>&1',
                    self.tool, index + 1, out, self.dir, bank)
                todo = todo + 1
            end
            if self.encoder and not exists(mp4) then
                -- Shaped like the remake's own movies, which Electra plays: a
                -- (tiny, black) H.264 picture, 48 kHz stereo AAC, index first.
                lines[#lines + 1] = string.format('"%s" -hide_banner -loglevel error -y -f lavfi -i "color=c=black:s=64x64:r=10" -i "%s" '
                    .. '-map 0:v -map 1:a -af apad=pad_dur=0.6 -shortest -c:v libopenh264 -pix_fmt yuv420p -c:a aac -ar 48000 -ac 2 -b:a 192k '
                    .. '-movflags +faststart "%s" >nul 2>&1', self.encoder, out, mp4)
                todo = todo + 1
            end
        end
    end
    if todo > 0 then
        local bat = self.cache .. "\\decode.cmd"
        local f = assert(io.open(bat, "wb")); f:write(table.concat(lines, "\r\n"), "\r\n"); f:close()
        os.execute('start /b cmd /c ""' .. bat .. '""')
    end
    return todo, missing
end

function S:mp4_path(tag_name)
    -- v3: padded with silence at the end; the media player drops the last
    -- fraction of a second of a clip, which cut the ends of lines off
    return self.cache .. "\\" .. tag_name:gsub("[\\/ ]", "_") .. ".v3.mp4"
end

function S:wav(tag_name)
    local out = self:wav_path(tag_name)
    if exists(out) then return out end
end

-- What the remake plays: the .mp4 when an encoder is set, else the .wav.
function S:playable(tag_name)
    local p = self.encoder and self:mp4_path(tag_name) or self:wav_path(tag_name)
    if exists(p) then return p end
end

-- Length in seconds of a PCM wav written by the decoder.
function S.wav_seconds(path)
    local f = io.open(path, "rb"); if not f then return 0 end
    local h = f:read(4096); f:close()
    if not h or #h < 44 then return 0 end
    local channels, rate = unpack("<I2I4", h, 23)
    local bits = unpack("<I2", h, 35)
    local p = 13
    while p + 8 <= #h do
        local id, size = h:sub(p, p + 3), unpack("<I4", h, p + 4)
        if id == "data" then return size / (rate * channels * math.max(1, bits // 8)) end
        p = p + 8 + size
    end
    return 0
end

-- Loudness of a PCM16 wav, one RMS value (0..1) per 1/fps second: what drives
-- a speaker's mouth while the line plays.
function S.envelope(path, fps)
    fps = fps or 30
    local f = io.open(path, "rb"); if not f then return nil end
    local d = f:read("a"); f:close()
    if #d < 44 or d:sub(1, 4) ~= "RIFF" then return nil end
    local channels, rate, bits, data_at, data_len
    local p = 13
    while p + 8 <= #d do
        local id, size = d:sub(p, p + 3), unpack("<I4", d, p + 4)
        if id == "fmt " then
            channels, rate = unpack("<I2I4", d, p + 10)
            bits = unpack("<I2", d, p + 22)
        elseif id == "data" then
            data_at, data_len = p + 8, math.min(size, #d - p - 7); break
        end
        p = p + 8 + size + (size % 2)
    end
    if not (data_at and channels and rate and bits == 16) then return nil end
    local frame_bytes = 2 * channels
    local per = math.max(1, rate // fps)
    local total = data_len // frame_bytes
    local out = {}
    local step = math.max(1, per // 64)  -- sample a subset; loudness only
    for w = 0, total // per - 1 do
        local acc, n = 0, 0
        for i = w * per, w * per + per - 1, step do
            local v = unpack("<i2", d, data_at + i * frame_bytes)
            acc = acc + v * v; n = n + 1
        end
        out[#out + 1] = math.sqrt(acc / math.max(1, n)) / 32768
    end
    return out
end

return S
