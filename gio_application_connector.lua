local ffi = require("ffi")

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

-- Get the information for all applications known by Gtk
local function get_all_applications()
        local app_list = {}
        local list = gio.g_app_info_get_all()
        local node = list

        while node ~= nil and node ~= ffi.NULL do
                local appinfo = ffi.cast("GAppInfo*", node.data)
                local name = gio.g_app_info_get_name(appinfo)
                local id = gio.g_app_info_get_id(appinfo)
                local description = gio.g_app_info_get_description(appinfo)
                local icon = gio.g_app_info_get_icon(appinfo)
                local icon_str = nil
                if icon ~= nil then
                    icon_str = gio.g_icon_to_string(icon)
                end

                table.insert(app_list, {
                        name = name ~= nil and ffi.string(name) or "",
                        id = id ~= nil and ffi.string(id) or "",
                        description = description ~= nil and ffi.string(description) or "",
                        icon = icon_str ~= nil and ffi.string(icon_str) or "",
                        gAppInfo = appinfo
                })

                node = node.next
        end

        glib.g_list_free(list)

        return app_list
end

-- Launch an application using Gio from the provided GAppInfo
local function launch_application(gAppInfo)
    local err = ffi.new("GError*[1]")
    local result = gio.g_app_info_launch(gAppInfo, ffi.NULL, ffi.NULL, err)

    if result == 0 then
        return false
    else
        return true
    end
end

return {
        get_all_applications = get_all_applications,
        launch_application = launch_application
}
