-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_desmanche",src)
vSERVER = Tunnel.getInterface("vrp_desmanche")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehList = {}
local vehService = false
local listVehicles = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETLIST COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local telefones = {	
	{ 56.03,-1079.90,29.45 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESMANCHE COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local desCoords = {
	{ 2351.84,3132.78,48.21 },
	{ 1204.48,-3116.71,5.55 },
	{ 1427.97,6348.02,23.99 },
	{ 970.05,-1625.52,30.11 },
	{ 949.23,-2186.64,30.55 },
	{ 1509.00,-2098.32,76.75 },
	{ 1694.99,3589.22,35.65 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHSTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehStatus = {
	[1] = { "blista" },
	[2] = { "brioso" },
	[3] = { "dilettante" },
	[4] = { "issi2" },
	[5] = { "panto" },
	[6] = { "prairie" },
	[7] = { "rhapsody" },
	[8] = { "cogcabrio" },
	[9] = { "exemplar" },
	[10] = { "f620" },
	[11] = { "felon" },
	[12] = { "ingot" },
	[13] = { "felon2" },
	[14] = { "jackal" },
	[15] = { "oracle" },
	[16] = { "oracle2" },
	[17] = { "sentinel" },
	[18] = { "sentinel2" },
	[19] = { "windsor" },
	[20] = { "windsor2" },
	[21] = { "zion" },
	[22] = { "zion2" },
	[23] = { "blade" },
	[24] = { "buccaneer" },
	[25] = { "buccaneer2" },
	[26] = { "primo" },
	[27] = { "primo2" },
	[28] = { "chino" },
	[29] = { "chino2" },
	[30] = { "coquette3" },
	[31] = { "dominator" },
	[32] = { "dukes" },
	[33] = { "faction" },
	[34] = { "faction2" },
	[35] = { "faction3" },
	[36] = { "gauntlet" },
	[37] = { "hermes" },
	[38] = { "hotknife" },
	[39] = { "moonbeam" },
	[40] = { "moonbeam2" },
	[41] = { "nightshade" },
	[42] = { "picador" },
	[43] = { "ratloader2" },
	[44] = { "ruiner" },
	[45] = { "sabregt" },
	[46] = { "sabregt2" },
	[47] = { "slamvan" },
	[48] = { "slamvan2" },
	[49] = { "slamvan3" },
	[50] = { "stalion" },
	[51] = { "tampa" },
	[52] = { "vigero" },
	[53] = { "virgo" },
	[54] = { "virgo2" },
	[55] = { "virgo3" },
	[56] = { "voodoo" },
	[57] = { "yosemite" },
	[58] = { "bfinjection" },
	[59] = { "bifta" },
	[60] = { "bodhi2" },
	[61] = { "brawler" },
	[62] = { "trophytruck" },
	[63] = { "dubsta3" },
	[64] = { "mesa3" },
	[65] = { "rancherxl" },
	[66] = { "rebel" },
	[67] = { "rebel2" },
	[68] = { "riata" },
	[69] = { "dloader" },
	[70] = { "sandking" },
	[71] = { "sandking2" },
	[72] = { "baller" },
	[73] = { "baller2" },
	[74] = { "baller3" },
	[75] = { "baller4" },
	[76] = { "baller5" },
	[77] = { "baller6" },
	[78] = { "bjxl" },
	[79] = { "cavalcade" },
	[80] = { "cavalcade2" },
	[81] = { "contender" },
	[82] = { "dubsta" },
	[83] = { "dubsta2" },
	[84] = { "fq2" },
	[85] = { "granger" },
	[86] = { "gresley" },
	[87] = { "habanero" },
	[88] = { "seminole" },
	[89] = { "serrano" },
	[90] = { "xls" },
	[91] = { "xls2" },
	[92] = { "asea" },
	[93] = { "asterope" },
	[94] = { "cog55" },
	[95] = { "cog552" },
	[96] = { "cognoscenti" },
	[97] = { "cognoscenti2" },
	[98] = { "stanier" },
	[99] = { "stratum" },
	[100] = { "superd" },
	[101] = { "surge" },
	[102] = { "tailgater" },
	[103] = { "warrener" },
	[104] = { "washington" },
	[105] = { "alpha" },
	[106] = { "banshee" },
	[107] = { "bestiagts" },
	[108] = { "blista2" },
	[109] = { "blista3" },
	[110] = { "buffalo" },
	[111] = { "buffalo2" },
	[112] = { "carbonizzare" },
	[113] = { "comet2" },
	[114] = { "comet3" },
	[115] = { "coquette" },
	[116] = { "elegy" },
	[117] = { "elegy2" },
	[118] = { "feltzer2" },
	[119] = { "furoregt" },
	[120] = { "fusilade" },
	[121] = { "futo" },
	[122] = { "jester" },
	[123] = { "khamelion" },
	[124] = { "kuruma" },
	[125] = { "massacro" },
	[126] = { "ninef" },
	[127] = { "ninef2" },
	[128] = { "omnis" },
	[129] = { "pariah" },
	[130] = { "penumbra" },
	[131] = { "raiden" },
	[132] = { "rapidgt" },
	[133] = { "rapidgt2" },
	[134] = { "ruston" },
	[135] = { "schafter3" },
	[136] = { "schafter4" },
	[137] = { "schwarzer" },
	[138] = { "sentinel3" },
	[139] = { "seven70" },
	[140] = { "specter" },
	[141] = { "specter2" },
	[142] = { "streiter" },
	[143] = { "sultan" },
	[144] = { "surano" },
	[145] = { "tampa2" },
	[146] = { "tropos" },
	[147] = { "verlierer2" },
	[148] = { "btype" },
	[149] = { "btype2" },
	[150] = { "btype3" },
	[151] = { "casco" },
	[152] = { "cheetah" },
	[153] = { "coquette2" },
	[154] = { "feltzer3" },
	[155] = { "gt500" },
	[156] = { "infernus2" },
	[157] = { "jb700" },
	[158] = { "mamba" },
	[159] = { "manana" },
	[160] = { "monroe" },
	[161] = { "peyote" },
	[162] = { "pigalle" },
	[163] = { "rapidgt3" },
	[164] = { "retinue" },
	[165] = { "stinger" },
	[166] = { "stingergt" },
	[167] = { "torero" },
	[168] = { "tornado" },
	[169] = { "tornado2" },
	[170] = { "tornado5" },
	[171] = { "turismo2" },
	[172] = { "viseris" },
	[173] = { "ztype" },
	[174] = { "adder" },
	[175] = { "autarch" },
	[176] = { "banshee2" },
	[177] = { "bullet" },
	[178] = { "cheetah2" },
	[179] = { "entityxf" },
	[180] = { "fmj" },
	[181] = { "gp1" },
	[182] = { "infernus" },
	[183] = { "nero" },
	[184] = { "nero2" },
	[185] = { "osiris" },
	[186] = { "penetrator" },
	[187] = { "pfister811" },
	[188] = { "reaper" },
	[189] = { "sc1" },
	[190] = { "sultanrs" },
	[191] = { "t20" },
	[192] = { "tempesta" },
	[193] = { "turismor" },
	[194] = { "tyrus" },
	[195] = { "vacca" },
	[196] = { "visione" },
	[197] = { "voltic" },
	[198] = { "zentorno" },
	[199] = { "sadler" },
	[200] = { "bison" },
	[201] = { "bison2" },
	[202] = { "bobcatxl" },
	[203] = { "burrito" },
	[204] = { "burrito2" },
	[205] = { "burrito3" },
	[206] = { "burrito4" },
	[207] = { "minivan" },
	[208] = { "minivan2" },
	[209] = { "paradise" },
	[210] = { "pony" },
	[211] = { "pony2" },
	[212] = { "rumpo" },
	[213] = { "rumpo2" },
	[214] = { "rumpo3" },
	[215] = { "speedo" },
	[216] = { "surfer" },
	[217] = { "youga" },
	[218] = { "youga2" },
	[219] = { "huntley" },
	[220] = { "landstalker" },
	[221] = { "mesa" },
	[222] = { "patriot" },
	[223] = { "radi" },
	[224] = { "rocoto" },
	[225] = { "tyrant" },
	[226] = { "entity2" },
	[227] = { "cheburek" },
	[228] = { "hotring" },
	[229] = { "jester3" },
	[230] = { "flashgt" },
	[231] = { "ellie" },
	[232] = { "michelli" },
	[233] = { "fagaloa" },
	[234] = { "dominator3" },
	[235] = { "issi3" },
	[236] = { "taipan" },
	[237] = { "gb200" },
	[238] = { "stretch" },
	[239] = { "guardian" },
	[240] = { "kamacho" },
	[241] = { "neon" },
	[242] = { "cyclone" },
	[243] = { "italigtb" },
	[244] = { "italigtb2" },
	[245] = { "vagner" },
	[246] = { "xa21" },
	[247] = { "tezeract" },
	[248] = { "prototipo" },
	[249] = { "patriot2" },
	[250] = { "speedo4" },
	[251] = { "stafford" },
	[252] = { "swinger" },
	[253] = { "brutus" },
	[254] = { "clique" },
	[255] = { "deveste" },
	[256] = { "deviant" },
	[257] = { "impaler" },
	[258] = { "imperator" },
	[259] = { "italigto" },
	[260] = { "schlagen" },
	[261] = { "toros" },
	[262] = { "tulip" },
	[263] = { "vamos" },
	[264] = { "akuma" },
	[265] = { "avarus" },
	[266] = { "bagger" },
	[267] = { "bati" },
	[268] = { "bf400" },
	[269] = { "carbonrs" },
	[270] = { "chimera" },
	[271] = { "cliffhanger" },
	[272] = { "daemon" },
	[273] = { "daemon2" },
	[274] = { "defiler" },
	[275] = { "diablous" },
	[276] = { "diablous2" },
	[277] = { "double" },
	[278] = { "enduro" },
	[279] = { "esskey" },
	[280] = { "faggio" },
	[281] = { "faggio2" },
	[282] = { "faggio3" },
	[283] = { "fcr" },
	[284] = { "fcr2" },
	[285] = { "gargoyle" },
	[286] = { "hakuchou" },
	[287] = { "hakuchou2" },
	[288] = { "hexer" },
	[289] = { "innovation" },
	[290] = { "lectro" },
	[291] = { "manchez" },
	[292] = { "nemesis" },
	[293] = { "nightblade" },
	[294] = { "pcj" },
	[295] = { "ruffian" },
	[296] = { "sanchez" },
	[297] = { "sanchez2" },
	[298] = { "sanctus" },
	[299] = { "sovereign" },
	[300] = { "thrust" },
	[301] = { "vader" },
	[302] = { "vindicator" },
	[303] = { "vortex" },
	[304] = { "wolfsbane" },
	[305] = { "zombiea" },
	[306] = { "zombieb" },
	[307] = { "deathbike" },
	[308] = { "shotaro" },
	[309] = { "nissangtr" },
	[310] = { "dodgechargersrt" },
	[311] = { "ferrariitalia" },
	[312] = { "audirs6" },
	[313] = { "bmwm3f80" },
	[314] = { "bmwm4gts" },
	[315] = { "fordmustang" },
	[316] = { "lancerevolutionx" },
	[317] = { "mazdarx7" },
	[318] = { "nissangtrnismo" },
	[319] = { "nissanskyliner34" },
	[320] = { "teslaprior" },
	[321] = { "toyotasupra" },
	[322] = { "paganihuayra" },
	[323] = { "C7" },
	[324] = { "2016RS7" },
	[325] = { "m6f13" },
	[326] = { "trhawk" },
	[327] = { "BOSS429" },
	[328] = { "z4bmw" },
	[329] = { "x6m" },
	[330] = { "rmodmi8" },
	[331] = { "r8v10abt" },
	[332] = { "W900" },
	[333] = { "lp770r" },
	[334] = { "gt17" },
	[335] = { "panamera17turbo" },
	[336] = { "19ftype" },
	[337] = { "z1000" },
	[338] = { "bmws" },
	[339] = { "mule3" },
	[340] = { "mule" },
	[341] = { "zl12017" },
	[342] = { "16challenger" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if not inService then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				for k,v in pairs(telefones) do
					local distance = Vdist(x,y,z,v[1],v[2],v[3])
					if distance <= 20 then
						DrawMarker(21,v[1],v[2],v[3]-0.6,0,0,0,0.0,0,0,0.5,0.5,-0.4,255,255,255,25,0,0,0,1)
						if distance <= 1.1 and IsControlJustPressed(0,38) then
							vRP._CarregarObjeto("cellphone@","cellphone_call_in","prop_cs_hand_radio",50,28422)
							Citizen.Wait(5000)
							local vehCount = 0

							repeat
								Citizen.Wait(500)
								vehCount = vehCount + 1
								table.insert(vehList,{ vehStatus[math.random(#vehStatus)][1] })
								vRP._stopAnim(source,false)
								vRP._DeletarObjeto(source)
							until vehCount == 4

							vSERVER.startVehicleList(vehList)
							inService = true
							TriggerEvent("Notify","sucesso","Lista de <b>Veículos</b> liberada.")
						end
					end
				end
			end
		end
		Citizen.Wait(5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSEDVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if inService then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				for k,v in pairs(desCoords) do
					local distance = Vdist(x,y,z,v[1],v[2],v[3])
					if distance <= 50 then
						DrawMarker(23,v[1],v[2],v[3]-0.96,0,0,0,0,0,0,5.0,5.0,0.5,255,255,255,25,0,0,0,0)
						if distance <= 10.1 and IsControlJustPressed(0,38) then
							local vehicle,vname,vmodel,vplaca = vRP.vehDesmanche()
							if IsEntityAVehicle(vehicle) then
								for k,v in pairs(vehList) do
									if v[1] == vname and GetEntityModel(vehicle) == vmodel then
										FreezeEntityPosition(vehicle,true)
										TriggerEvent("cancelando",true)
										TriggerEvent("progress",30000,"removendo rastreador")
										SetTimeout(30500,function()
											TriggerEvent("cancelando",false)
											FreezeEntityPosition(vehicle,false)
											vSERVER.pressedVehicle(vehicle,vname,vplaca)
											DisableControlAction(0,38,true)
										end)
									end
								end
							end
						end
					end
				end
			end
			drawTxt(string.upper(listVehicles),4,0.5,0.96,0.40,255,255,255,180)
		end
		Citizen.Wait(5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.resetList()
	vehList = {}
	inService = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.setVehicles(status)
	listVehicles = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTXT
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end