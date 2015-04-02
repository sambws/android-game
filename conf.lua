require 'utils'

function love.conf(t)
	t.title             = "game"
	t.author            = "sambws"
	t.identity          = "android_test"
	t.release           = true

	t.window.fullscreen = false
	
	if phone == false then
		t.window.width = 480
		t.window.height = 270
	end

	t.console = true
end