fx_version 'cerulean'
game 'gta5'

description 'Custom Death Script'
author 'SMOC Development'
version '1.0.0'
lua54 'yes'

shared_scripts { '@ox_lib/init.lua' }

client_script 'client.lua'

ui_page 'html/death.html'

files {
    'html/death.html',
    'html/style.css',
    'html/blood.png'
}
