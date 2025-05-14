obs           = obslua
source_name   = ""
total_sessions = 4
work_duration = 25
break_duration = 5
start_message = "Time to focus!"
break_message = "Take a break!"
current_session = 1
is_break = false
is_running = false
is_paused = false
time_left = 0
display_timer = 0

function script_description()
    return "Pomodoro Timer for OBS with session tracking, break messages, and GDI+ Text display."
end

function script_properties()
    local props = obs.obs_properties_create()

    obs.obs_properties_add_int(props, "total_sessions", "Number of Sessions", 1, 100, 1)
    obs.obs_properties_add_int(props, "work_duration", "Work Duration (minutes)", 1, 180, 1)
    obs.obs_properties_add_int(props, "break_duration", "Break Duration (minutes)", 1, 60, 1)
    obs.obs_properties_add_text(props, "start_message", "Start Message", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "break_message", "Break Message", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "source_name", "Text Source (GDI+)", obs.OBS_TEXT_DEFAULT)

    obs.obs_properties_add_button(props, "start_button", "Start Timer", start_timer)
    obs.obs_properties_add_button(props, "pause_button", "Pause/Resume", toggle_pause)
    obs.obs_properties_add_button(props, "stop_button", "Stop Timer", stop_timer)

    return props
end

function script_update(settings)
    total_sessions = obs.obs_data_get_int(settings, "total_sessions")
    work_duration = obs.obs_data_get_int(settings, "work_duration")
    break_duration = obs.obs_data_get_int(settings, "break_duration")
    start_message = obs.obs_data_get_string(settings, "start_message")
    break_message = obs.obs_data_get_string(settings, "break_message")
    source_name = obs.obs_data_get_string(settings, "source_name")
end

function start_timer()
    if not is_running then
        is_running = true
        is_paused = false
        is_break = false
        current_session = 1
        time_left = work_duration * 60
        show_temp_message(start_message)
        obs.timer_add(update_timer, 1000)
    end
end

function toggle_pause()
    if is_running then
        is_paused = not is_paused
    end
end

function stop_timer()
    is_running = false
    is_paused = false
    obs.timer_remove(update_timer)
    update_text_source("00:00", "")
end

function update_timer()
    if is_paused then return end

    if time_left > 0 then
        time_left = time_left - 1
        local minutes = math.floor(time_left / 60)
        local seconds = time_left % 60
        local label = is_break and "Break" or "Focus"
        update_text_source(string.format("%02d:%02d", minutes, seconds), label)
    else
        if is_break then
            current_session = current_session + 1
            if current_session > total_sessions then
                stop_timer()
                return
            end
        end
        is_break = not is_break
        if is_break then
            time_left = break_duration * 60
            show_temp_message(break_message)
        else
            time_left = work_duration * 60
            show_temp_message(start_message)
        end
    end
end

function show_temp_message(message)
    display_timer = 2
    update_text_source(message, "")
    obs.timer_add(display_message_timer, 1000)
end

function display_message_timer()
    display_timer = display_timer - 1
    if display_timer <= 0 then
        obs.timer_remove(display_message_timer)
        local minutes = math.floor(time_left / 60)
        local seconds = time_left % 60
        local label = is_break and "Break" or "Focus"
        update_text_source(string.format("%02d:%02d", minutes, seconds), label)
    end
end

function update_text_source(timer_text, label)
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        local full_text = timer_text
        if is_running then
            full_text = full_text .. string.format(" Pomo %d/%d", current_session, total_sessions)
            if label ~= "" then
                full_text = full_text .. "\n" .. label
            end
        end
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", full_text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end
