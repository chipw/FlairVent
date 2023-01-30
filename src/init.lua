local Driver = require('st.driver')
local caps   = require('st.capabilities')
local log    = require('log')

-- local imports
local discovery  = require('discovery')
local lifecycles = require('lifecycles')
local commands   = require('commands')

--------------------
-- Driver definition
local driver =
  Driver(
    'Flair-Vent-Driver',
    {
      discovery          = discovery.handle_discovery,
      lifecycle_handlers = lifecycles,
      supported_capabilities = {
        caps.switch,
        caps.switchLevel,
        caps.battery,
        caps.refresh
      },
      capability_handlers = {
     -- Switch command handler
        [caps.switch.ID] = {
          [caps.switch.commands.on.NAME] = commands.on_off,
          [caps.switch.commands.off.NAME] = commands.on_off
        },
      
        -- Refresh command handler
        [caps.refresh.ID] = {
           [caps.refresh.commands.refresh.NAME] = commands.refresh
        },
        
        -- setLevel

        [caps.switchLevel.ID] = {
           [caps.switchLevel.commands.setLevel.NAME]  = commands.set_level --,
           --[caps.switchLevel.commands.close.NAME] = commands.push
        }
        
      }
    }
  )

---------------------------------------
-- Switch control for external commands
function driver:on_off(device, on_off)
  if on_off == 'off' then
    return device:emit_event(caps.switch.switch.off())
  end
  return device:emit_event(caps.switch.switch.on())
end

---------------------------------------------
-- Switch level control for external commands
function driver:set_level(device, lvl)
  if lvl == 0 then
    device:emit_event(caps.switch.switch.off())
  else
    device:emit_event(caps.switch.switch.on())
  end
  return device:emit_event(caps.switchLevel.level(lvl))
end

---------------------

--------------------
-- Initialize Driver
driver:run()
