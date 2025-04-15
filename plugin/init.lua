package.path = package.path .. ";" .. (select(2, ...):gsub("init.lua$", "?.lua"))

local wezterm = require "wezterm"

return {
    apply_to_config = function(config) end,

    MostRecentWorkspace = function()
        return function()
            if not wezterm.GLOBAL.sessionizer then return {} end
            if not wezterm.GLOBAL.sessionizer.history then return {} end
            return { { label = wezterm.GLOBAL.sessionizer.history.label, id = wezterm.GLOBAL.sessionizer.history.id } }
        end
    end,
    Wrapper = function(callback)
        return function(window, pane, id, label)
            if id and label then
                if not wezterm.GLOBAL.sessionizer then wezterm.GLOBAL.sessionizer = {} end
                local previous_workspace = wezterm.mux.get_active_workspace()
                wezterm.GLOBAL.sessionizer.history = {
                    label = "Recent (" .. previous_workspace .. ")",
                    id = previous_workspace,
                }
            end
            callback(window, pane, id, label)
        end
    end,
    switch_to_most_recent_workspace = wezterm.action_callback(function(window, pane)
        if not wezterm.GLOBAL.sessionizer then wezterm.GLOBAL.sessionizer = {} end
        local previous_workspace = wezterm.mux.get_active_workspace()
        window:perform_action(wezterm.action.SwitchToWorkspace({
            name = wezterm.GLOBAL.sessionizer.history.id,
            spawn = { cwd = wezterm.GLOBAL.sessionizer.history.id }
        }), pane)

        wezterm.GLOBAL.sessionizer.history = {
            label = "Recent (" .. previous_workspace .. ")",
            id = previous_workspace,
        }
    end)
}
