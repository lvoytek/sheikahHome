local ffi = require("ffi")
local App = require("app")

-- Required Gtk c bindings for handling applications
ffi.cdef[[
typedef struct _GList {
    void *data;
    struct _GList *next;
    struct _GList *prev;
} GList;

typedef struct _GError {
    int domain;
    int code;
    const char* message;
} GError;

typedef struct _GAppInfo GAppInfo;
typedef struct _GIcon GIcon;

GList* g_app_info_get_all(void);
void g_list_free(GList *list);
const char* g_app_info_get_name(GAppInfo *appinfo);
const char* g_app_info_get_id(GAppInfo *appinfo);
const char* g_app_info_get_description(GAppInfo *appinfo);
GIcon* g_app_info_get_icon(GAppInfo *appinfo);
const char* g_icon_to_string(GIcon *icon);
void g_object_unref(void *object);
void g_free(void *mem);
int g_app_info_launch(GAppInfo *appinfo, void *files, void *context, GError** error);
]]

-- Gtk library imports
local gio = ffi.load("gio-2.0.so")
local glib = ffi.load("glib-2.0.so")
local gobject = ffi.load("gobject-2.0.so")

-- Launch an application using Gio from the provided GAppInfo
local function launchApplication(gAppInfo)
    local err = ffi.new("GError*[1]")
    local result = gio.g_app_info_launch(gAppInfo, ffi.NULL, ffi.NULL, err)

    if result == 0 then
        return false
    else
        return true
    end
end

-- Free the memory used by a GAppInfo object
local function freeAppInfo(gAppInfo)
    if gAppInfo ~= nil and gAppInfo ~= ffi.NULL then
        -- Unref the GAppInfo object to free it
        gobject.g_object_unref(gAppInfo)
    end
end

-- Get the information for all applications known by Gtk
local function getAllApplications()
        local appList = {}
        local gioAppList = gio.g_app_info_get_all()
        local node = gioAppList

        while node ~= nil and node ~= ffi.NULL do
                local appinfo = ffi.cast("GAppInfo*", node.data)
                local name = gio.g_app_info_get_name(appinfo)
                local id = gio.g_app_info_get_id(appinfo)
                local description = gio.g_app_info_get_description(appinfo)

                local icon = gio.g_app_info_get_icon(appinfo)
                local iconStr = nil
                if icon ~= nil then
                    iconStr = gio.g_icon_to_string(icon)
                end

                -- Create a new App instance and set its properties
                local nextApp = App:new()
                nextApp:setName(name ~= nil and ffi.string(name) or "")
                nextApp:setAppID(id ~= nil and ffi.string(id) or "")
                nextApp:setDescription(description ~= nil and ffi.string(description) or "")
                nextApp:setIcon(iconStr ~= nil and ffi.string(iconStr) or "")
                nextApp:setCAppInfo(appinfo)
                nextApp:setExecuteFunction(launchApplication)
                nextApp:setCAppInfoFreeFunction(freeAppInfo)

                table.insert(appList, nextApp)
                node = node.next
        end

        -- Free the c struct app list, not the app info
        glib.g_list_free(gioAppList)

        return appList
end

return {
        getAllApplications = getAllApplications,
        launchApplication = launchApplication
}
