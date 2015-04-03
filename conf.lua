require 'utils'

function love.conf(t)
	t.title             = "game"
	t.author            = "sambws"
	t.identity          = "android_test"
	t.release           = true
	t.window.vsync = true

	t.window.fullscreen = false
	
	t.window.width = 480 * scale
	t.window.height = 270 * scale

	t.console = true
end