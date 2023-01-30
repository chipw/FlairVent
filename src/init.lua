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
        
        -- Push
        [caps.switchLevel.ID] = {
           [caps.switchLevel.commands.setLevel.NAME]  = commands.set_level --,
           --[caps.switchLevel.commands.close.NAME] = commands.push
        }
        
      }
    }
  )

--------------------
-- Initialize Driver
driver:run()
