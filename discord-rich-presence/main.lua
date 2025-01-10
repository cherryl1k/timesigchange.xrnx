local discordRPC = require("discordRPC")

local clientID = "YOUR_DISCORD_APP_CLIENT_ID"
local presence = {
    state = "Composing Music",
    details = "Using Renoise",
    largeImageKey = "renoise_logo",
    largeImageText = "Renoise",
    smallImageKey = "music_note",
    smallImageText = "Composing",
    startTimestamp = os.time()
}

local function updatePresence()
    local song = renoise.song()
    local songName = song.name
    local currentPattern = song.selected_pattern_index
    local isPlaying = song.transport.playing
    local isRendering = song.transport.rendering

    presence.details = songName ~= "" and songName or "Untitled Song"
    presence.state = isRendering and "Rendering" or (isPlaying and "Playing" or "Editing")
    presence.smallImageText = "Pattern: " .. currentPattern

    discordRPC.updatePresence(presence)
end

local function init()
    discordRPC.initialize(clientID, true)
    updatePresence()
end

local function shutdown()
    discordRPC.shutdown()
end

renoise.tool().app_new_document_observable:add_notifier(init)
renoise.tool().app_release_document_observable:add_notifier(shutdown)

-- Update presence every 15 seconds
renoise.tool().app_idle_observable:add_notifier(function()
    if os.time() % 15 == 0 then
        updatePresence()
    end
end)