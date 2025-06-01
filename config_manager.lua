local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager:new(filename)
    local self = setmetatable({}, ConfigManager)
    self.filename = filename or "sheikah.conf"
    self.runes = 0
    self.applications = {}
    self:load()
    return self
end

-- Load application lauout and number of runes
function ConfigManager:load()
    if love.filesystem.getInfo(self.filename) then
        local contents = love.filesystem.read(self.filename)
        -- Match data between [app] and the next section or end of file
        local appSection = contents:match("%[app%](.-)\n%[") or contents:match("%[app%](.*)")
        if appSection then
            -- Get number of runes
            local runesMatch = appSection:match("runes%s*=%s*(%d+)")
            if runesMatch then
                self.runes = tonumber(runesMatch)
            else
                self.runes = 0
            end

            -- Parse applications
            self.applications = {}

            local inAppVariable = false
            for line in appSection:gmatch("[^\n]+") do
                if inAppVariable then
                    local appID = line:match("\t%s*(.+)")
                    if appID then
                        table.insert(self.applications, appID)
                    else
                        break
                    end
                else
                    local appID = line:match("app%s*=%s*(.+)")
                    if appID then
                        table.insert(self.applications, appID)
                    end
                    inAppVariable = true
                end
            end

            -- Rune minimum is the number of applications
            if self.runes < #self.applications then
                self.runes = #self.applications
            end
        else
            self.applications = {}
        end
    else
        self.applications = {}
    end
end

-- Save data to the config file
function ConfigManager:save()
    local contents = ""
    if love.filesystem.getInfo(self.filename) then
        contents = love.filesystem.read(self.filename)
    end

    -- Remove existing app section from file contents
    local newContents = contents
    if contents:find("%[app%]") then
        -- Remove [app] up to the next section or end of file
        newContents = contents:gsub("%[app%](.-)\n%[", "\n[")
        newContents = newContents:gsub("%[app%](.*)", "")
    end

    -- Print applications as tab indented lines
    local appLines = "app = " .. table.concat(self.applications, "\n\t")

    -- Re-add app section to the end
    newContents = newContents .. string.format("\n[app]\n%s\n", appLines)

    -- Print number of runes
    newContents = newContents .. string.format("runes = %d\n", self.runes)

    -- Rewrite config file
    love.filesystem.write(self.filename, newContents)
end

function ConfigManager:getApplications()
    return self.applications
end

function ConfigManager:getRunes()
    return self.runes
end

function ConfigManager:setApplicationsAndRunes(appIDs, runes)
    self.applications = appIDs or {}
    self.runes = runes or 0
    self:save()
end

return ConfigManager