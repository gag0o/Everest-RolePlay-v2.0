resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_01_CLASS_ROCK" { url = "https://antenaone.crossradio.com.br/;stream.ogg;", volume = 0.5 }
supersede_radio "RADIO_02_POP" { url = "http://mixaac.crossradio.com.br:10000/stream/1;", volume = 0.5 }
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://192.99.150.31:8377/stream", volume = 0.5 }
supersede_radio "RADIO_04_PUNK" { url = "https://playerservices.streamtheworld.com/api/livestream-redirect/JP_SP_FMAAC.aac?dist=onlineradiobox", volume = 0.5 }
supersede_radio "RADIO_05_TALK_01" { url = "http://6d9a.webradio.upx.net.br:9061/stream", volume = 0.5 }
supersede_radio "RADIO_06_COUNTRY" { url = "http://192.99.8.221:6752/;", volume = 0.5 }
supersede_radio "RADIO_07_DANCE_01" { url = "http://192.99.150.31:9191/;stream.ogg", volume = 0.5 }
supersede_radio "RADIO_08_MEXICAN" { url = "http://stm43.conectastm.com:9822/;stream.ogg", volume = 0.5 }
supersede_radio "RADIO_09_HIPHOP_OLD" { url = "http://s7.streammonster.com:8260/;stream.nsv", volume = 0.5 }
supersede_radio "RADIO_12_REGGAE" { url = "http://streaming03.hstbr.net:8136/live", volume = 0.5 }
supersede_radio "RADIO_13_JAZZ" { url = "http://216.245.204.226:8028/live", volume = 0.5 }
supersede_radio "RADIO_14_DANCE_02" { url = "http://216.245.204.226:8028/live", volume = 0.5 }
supersede_radio "RADIO_15_MOTOWN" { url = "http://srv1.braudio.com.br:7014/;", volume = 0.5 }
supersede_radio "RADIO_16_SILVERLAKE" { url = "http://paineldj4.com.br:8306/stream", volume = 0.5 }
supersede_radio "RADIO_17_FUNK" { url = "http://stream.geracaoradios.com:8060/radio", volume = 0.5 }
supersede_radio "RADIO_18_90S_ROCK" { url = "http://r2.ciclano.io:10032/stream", volume = 0.5 }
supersede_radio "RADIO_19_USER" { url = "https://playerservices.streamtheworld.com/api/livestream-redirect/NOVABRASIL_SPAAC.aac", volume = 0.5 }
supersede_radio "RADIO_20_THELAB" { url = "http://ice.fabricahost.com.br/89aradiorocksp?compat=1", volume = 0.5 }
supersede_radio "RADIO_11_TALK_02" { url = "https://str2b.openstream.co/776", volume = 0.5 }
supersede_radio "RADIO_21_DLC_XM17" { url = "http://felizfm.sateg.com.br:11520/;stream.ogg", volume = 0.5 }
supersede_radio "RADIO_22_DLC_BATTLE_MIX1_RADIO" { url = "http://209.126.127.123:8885/stream", volume = 0.5 }


-- "RADIO_16_SILVERLAKE",              // Radio Mirror Park
--     "RADIO_17_FUNK",                    // Space 103.2
--     "RADIO_18_90S_ROCK",                // Vinewood Boulevard Radio
--     "RADIO_19_USER",                    // Self Radio
--     "RADIO_20_THELAB",                  // The Lab
--     "RADIO_11_TALK_02",                 // Blaine County Radio
--     "RADIO_21_DLC_XM17",                // Blonded Los Santos 97.8 FM
--     "RADIO_22_DLC_BATTLE_MIX1_RADIO"    // Los Santos Underground Radio


files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}
