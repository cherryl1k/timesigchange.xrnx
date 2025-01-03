local function change_time_signature(beats_per_measure, beat_unit)
    local song = renoise.song()
    local lines_per_beat = song.transport.lpb
    local new_pattern_length = beats_per_measure * lines_per_beat

    if beats_per_measure < 1 or beat_unit < 1 then
        renoise.app():show_error("Invalid time signature values.")
        return
    end

    for _, pattern in ipairs(song.patterns) do
        pattern.number_of_lines = new_pattern_length
    end
end

local function show_time_signature_dialog()
    local vb = renoise.ViewBuilder()
    local dialog_content = vb:column {
        margin = 10,
        vb:text {
            text = "Set Custom Time Signature"
        },
        vb:row {
            vb:text {
                text = "Beats per Measure:"
            },
            vb:valuebox {
                id = "beats_per_measure",
                min = 1,
                max = 16,
                value = 4
            }
        },
        vb:row {
            vb:text {
                text = "Beat Unit:"
            },
            vb:valuebox {
                id = "beat_unit",
                min = 1,
                max = 16,
                value = 4
            }
        },
        vb:button {
            text = "Apply",
            notifier = function()
                local beats_per_measure = vb.views.beats_per_measure.value
                local beat_unit = vb.views.beat_unit.value
                if beats_per_measure < 1 or beat_unit < 1 then
                    renoise.app():show_error("Invalid time signature values.")
                    return
                end
                change_time_signature(beats_per_measure, beat_unit)
                renoise.app():show_message("Time signature changed to " .. beats_per_measure .. "/" .. beat_unit)
            end
        }
    }

    renoise.app():show_custom_dialog("Time Signature", dialog_content)
end

renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:catbot Time Signature Changer...",
    invoke = show_time_signature_dialog
}
