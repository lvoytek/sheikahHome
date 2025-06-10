local linuxGtkAppConnector = require("gio_application_connector")

local AppManager = {}
AppManager.__index = AppManager

local allApps = nil

function AppManager:new()
    local self = setmetatable({}, AppManager)
    return self
end

-- Reload all applications using the application connector
function AppManager:refresh()
    if allApps then
        for _, app in ipairs(allApps) do
            app.freeCAppInfo()
        end
    end

    allApps = linuxGtkAppConnector.getAllApplications()
end

-- Provide all apps, extracting by hooking into connector if not yet available
function AppManager:getAllApps()
    if not allApps then
        self:refresh()
    end

    return allApps
end

return AppManager