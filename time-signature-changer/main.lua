local function change_time_signature(beats_per_measure)
    local song = renoise.song()
    local lines_per_beat = song.transport.lpb
    local new_pattern_length = beats_per_measure * lines_per_beat

    if beats_per_measure < 1 then
        renoise.app():show_error("Invalid time signature values.")
        return
    end

    local selected_pattern_index = song.selected_pattern_index
    song.patterns[selected_pattern_index].number_of_lines = new_pattern_length
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
        vb:button {
            text = "Apply",
            notifier = function()
                local beats_per_measure = vb.views.beats_per_measure.value
                if beats_per_measure < 1 then
                    renoise.app():show_error("Invalid time signature values.")
                    return
                end
                change_time_signature(beats_per_measure)
                renoise.app():show_message("Time signature changed to " .. beats_per_measure .. " beats per measure")
            end
        }
    }

    renoise.app():show_custom_dialog("Time Signature", dialog_content)
end

renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:catbot Time Signature Changer...",
    invoke = show_time_signature_dialog
}