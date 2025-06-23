fx_version 'cerulean'
game 'gta5'

description 'R1mus Advanced Character Registration System'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_camera.lua',
    'client/cl_spawn.lua',
    'client/cl_appearance.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/sv_data.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/fonts/*.ttf',
    'html/img/*.png',
    'html/img/*.jpg'
}
