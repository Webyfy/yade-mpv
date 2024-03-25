-- audio visualization

if not (mp.get_property("options/lavfi-complex", "") == "") then
    return
end

if (mp.get_property("options/video", "") == "no") then
    return
end

local function get_visualizer(vtrack)
    local w, h, fps

    w = 1280
    fps = 60
    h = 480

    return "[aid1] asplit [ao]," ..
        "afifo," ..
        "aformat            =" ..
            "sample_rates   = 192000," ..
        "avectorscope       =" ..
            "size           =" .. w .. "x" .. h .. ":" ..
            "r              =" .. fps .. "," ..
        "format             = rgb0 [vo]"

end

local function select_visualizer(vtrack)
    if vtrack == nil then
        return get_visualizer(vtrack)
    end
    return ""
end

local function visualizer_hook()
    local count = mp.get_property_number("track-list/count", -1)
    if count <= 0 then
        return
    end

    local atrack = mp.get_property_native("current-tracks/audio")
    local vtrack = mp.get_property_native("current-tracks/video")

    --no tracks selected (yet)
    if atrack == nil and vtrack == nil then
        for id, track in ipairs(mp.get_property_native("track-list")) do
            if track.type == "video" and (vtrack == nil or vtrack.albumart == true) and mp.get_property("vid") ~= "no" then
                vtrack = track
            elseif track.type == "audio" then
                atrack = track
            end
        end
    end

    local lavfi = select_visualizer(vtrack)
    --prevent endless loop
    if lavfi ~= mp.get_property("options/lavfi-complex", "") then
        mp.set_property("options/lavfi-complex", lavfi)
    end
end

mp.add_hook("on_preloaded", 50, visualizer_hook)
mp.observe_property("current-tracks/audio", "native", visualizer_hook)
mp.observe_property("current-tracks/video", "native", visualizer_hook)
