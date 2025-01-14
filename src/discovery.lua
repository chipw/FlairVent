local log    = require('log')
local cosock = require "cosock"
local http   = cosock.asyncify "socket.http"
local json   = require('dkjson')
local ltn12  = require('ltn12')

local apiEndpoint = "http://192.168.1.2:80"
local discovery = {}

function discovery.handle_discovery(driver, _should_continue)
   log.info("Starting Flair Vent Discovery")

   local url = apiEndpoint .. "/flair/flairFindVents.php"
   local response = {}
   local _, code = http.request({
      url=url,
      sink=ltn12.sink.table(response)
   }) 
  
   
   if code == 200 then
      response = table.concat(response)
      log.debug("Response: "..response)

      local vents = json.decode(response)
 
      for key,value in pairs(vents) do 
         local id = value["id"]
         local name = value["name"]
         log.debug("ID: "..id)
         log.debug("Name: "..name)
         local metadata = {
            type = "LAN",
            device_network_id = id,
            label = name,
            profile = "flairVent.v2",
            manufacturer = "josep-cw",
            model = "v2",
            vendor_provided_label = name
         }
         driver:call_with_delay(
            1,
            function() 
               return driver:try_create_device(metadata)
            end 
         )
      end
   end   
end

return discovery
