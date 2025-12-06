-- mod-version:4 priority:0

local core = require "core"
local config = require "core.config"
local style = require "core.style"
local common = require "core.common"
local libgl = require "plugins.gl.renderer"


function renwindow:get_size() return .size() end
function renwindow.create() return setmetatable({}, renwindow) end
function renwindow.__restore() return setmetatable({}, renwindow) end

function system.set_window_title(window, title) return end
function system.set_window_mode(window) return 0 end
function system.get_window_mode(window) return 0 end
function system.set_window_size(window) end
