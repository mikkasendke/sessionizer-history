# sessionizer-history
This provides a generator function and a wrapper for the callback to have access to the most recent workspace used in [sessionizer.wezterm](https://github.com/mikkasendke/sessionizer.wezterm).

## Usage
1. Require the plugin:
```lua
local history = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer-history.git"
```
2. Integrate into your schema:
```lua
local schema = {
  options = {
    callback = history.Wrapper(sessionizer.DefaultCallback), -- so it knows when you select and switch to a workspace.
  },
  history.MostRecentWorkspace {}, -- generator function to display the most recent workspace
}
```  
3. Key binding
```lua
-- use this:
config.keys = {
  -- ...
  -- ... other binds
  {
    key = "m",
    mods = "ALT",
    action = history.switch_to_most_recent_workspace,
  },
  -- other binds ...
  -- ...
}
```
done :)
