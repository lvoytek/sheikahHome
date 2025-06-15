local App = {}
App.__index = App

local function loadImageFromPath(filePath)
    local f = io.open(filePath, "rb")
    if f then
        local data = f:read("*all")
        f:close()
        if data then
            data = love.filesystem.newFileData(data, "temp")
            validImage, data = pcall(love.image.newImageData, data)
            if validImage then
                local image = love.graphics.newImage(data)
                return image
            end
        end
    end
    return nil
end

function App:new()
    local self = setmetatable({}, App)
    self.appID = nil
    self.name = ""
    self.description = ""
    self.iconStr = ""
    self.icon = nil
    self.executeFunction = nil
    self.cAppInfo = nil
    self.freeCAppInfoFunction = nil
    return self
end

function App:setAppID(id)
    self.appID = id
    return self
end

function App:getAppID()
    return self.appID
end

function App:setName(name)
    if type(name) == "string" then
        self.name = name
    end
    return self
end

function App:getName()
    return self.name
end

function App:setDescription(description)
    if type(description) == "string" then
        self.description = description
    end
    return self
end

function App:getDescription()
    return self.description
end

-- Set the icon by providing its file path, do not load image
function App:setIcon(iconStr)
    if type(iconStr) == "string" then
        self.iconStr = iconStr
    end

    return self
end

-- Get the icon as a love2d image object, loading here initially
function App:getIcon()
    if self.iconStr ~= "" and not self.icon then
        self.icon = loadImageFromPath(self.iconStr)
    end

    return self.icon
end

-- Set the application launch function
function App:setExecuteFunction(func)
    self.executeFunction = func
    return self
end

-- Run the function to launch the application
function App:execute()
    if self.executeFunction and self.cAppInfo then
        return self.executeFunction(self.cAppInfo)
    end
    return false
end

-- Set application info provided by C bindings
function App:setCAppInfo(cAppInfo)
    self.cAppInfo = cAppInfo
    return self
end

-- Set function for freeing memory of app info C struct
function App:setCAppInfoFreeFunction(func)
    self.freeCAppInfoFunction = func
    return self
end

-- Free the C struct app info if it was set
function App:freeCAppInfo()
    if self.freeCAppInfoFunction and self.cAppInfo then
        self.freeCAppInfoFunction(self.cAppInfo)
        self.cAppInfo = nil
    end
    return self
end

return App