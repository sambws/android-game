cd C:\love-android-sdl2\assets
del game.zip
del game.love
CScript C:\NDK\zip.vbs C:\love\game C:\love-android-sdl2\assets\game.zip
ren game.zip game.love
cd ..
ant debug
cd C:\Users\sam\AppData\Local\Android\android-sdk\platform-tools
adb push C:\love-android-sdl2\bin\love_android_sdl2-debug.apk /sdcard/game.apk