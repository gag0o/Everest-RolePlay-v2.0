 -----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_garages",src)
vCLIENT = Tunnel.getInterface("vrp_garages")
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("creative/get_vehicle","SELECT * FROM vrp_vehicles WHERE user_id = @user_id")
vRP._prepare("creative/rem_vehicle","DELETE FROM vrp_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/get_vehicles","SELECT * FROM vrp_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_update_vehicles","UPDATE vrp_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_detido","UPDATE vrp_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_ipva","UPDATE vrp_vehicles SET ipva = @ipva WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/move_vehicle","UPDATE vrp_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/add_vehicle","INSERT IGNORE INTO vrp_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)")
vRP._prepare("creative/con_maxvehs","SELECT COUNT(vehicle) as qtd FROM vrp_vehicles WHERE user_id = @user_id")
vRP._prepare("creative/rem_srv_data","DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP._prepare("creative/get_estoque","SELECT * FROM vrp_estoque WHERE vehicle = @vehicle")
vRP._prepare("creative/set_estoque","UPDATE vrp_estoque SET quantidade = @quantidade WHERE vehicle = @vehicle")
vRP._prepare("creative/set_priColor","UPDATE vrp_vehicles SET colorR = @colorR, colorG = @colorG, colorB = @colorB WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_secColor","UPDATE vrp_vehicles SET color2R = @color2R, color2G = @color2G, color2B = @color2B WHERE user_id = @user_id AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehlist = {}
local trydoors = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNVEHICLESEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.returnVehicleEveryone(placa)
	return trydoors[placa]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("setPlateEveryone")
AddEventHandler("setPlateEveryone",function(placa)
	trydoors[placa] = true
	vCLIENT.syncTrydoors(-1,trydoors)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vCLIENT.syncTrydoors(source,trydoors)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local garages = {
	[1] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[2] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[3] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[4] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[5] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[6] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[7] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[8] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[9] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[10] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[11] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[12] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[13] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[14] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[15] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[16] = { ['name'] = "Policia", ['payment'] = false, ['perm'] = "policia.permissao" },
	[17] = { ['name'] = "Policia", ['payment'] = false, ['perm'] = "policia.permissao" },
	[18] = { ['name'] = "Policia", ['payment'] = false, ['perm'] = "policia.permissao" },
	[19] = { ['name'] = "Policia", ['payment'] = false, ['perm'] = "policia.permissao" },
	[20] = { ['name'] = "PoliciaB", ['payment'] = false, ['perm'] = "policia.permissao" },
	[21] = { ['name'] = "PoliciaH", ['payment'] = false, ['perm'] = "policia.permissao" },
	[22] = { ['name'] = "PoliciaA", ['payment'] = false, ['perm'] = "policia.permissao" },
	[23] = { ['name'] = "Paramedico", ['payment'] = false, ['perm'] = "paramedico.permissao" },
	[24] = { ['name'] = "Paramedico", ['payment'] = false, ['perm'] = "paramedico.permissao" },
	[25] = { ['name'] = "Paramedico", ['payment'] = false, ['perm'] = "paramedico.permissao" },
	[26] = { ['name'] = "ParamedicoH", ['payment'] = false, ['perm'] = "paramedico.permissao" },
	[27] = { ['name'] = "Mecanico", ['payment'] = false, ['perm'] = "mecanico.permissao" },
	[28] = { ['name'] = "Mecanico", ['payment'] = false, ['perm'] = "mecanico.permissao" },
	[29] = { ['name'] = "Taxista", ['payment'] = false, ['public'] = true },
	[30] = { ['name'] = "Motorista", ['payment'] = false, ['public'] = true },
	[31] = { ['name'] = "Carteiro", ['payment'] = false, ['public'] = true },
	[32] = { ['name'] = "Lixeiro", ['payment'] = false, ['public'] = true },
	[33] = { ['name'] = "Minerador", ['payment'] = false, ['public'] = true },
	[34] = { ['name'] = "Lenhador", ['payment'] = false, ['public'] = true },
	--[35] = { ['name'] = "Leiteiro", ['payment'] = false, ['public'] = true },
	[36] = { ['name'] = "Caminhoneiro", ['payment'] = false, ['public'] = true },
	[37] = { ['name'] = "Advogado", ['payment'] = true, ['perm'] = "advogado.permissao" },
	[38] = { ['name'] = "Embarcações", ['payment'] = false, ['public'] = true },
	[39] = { ['name'] = "Embarcações", ['payment'] = false, ['public'] = true },
	[40] = { ['name'] = "Embarcações", ['payment'] = false, ['public'] = true },
	[41] = { ['name'] = "Embarcações", ['payment'] = false, ['public'] = true },
	--[42] = { ['name'] = "Serpentes", ['payment'] = true, ['perm'] = "serpentes.permissao" },
	--[43] = { ['name'] = "SerpentesBarcos", ['payment'] = true, ['perm'] = "serpentes.permissao" },
--	[44] = { ['name'] = "Motoclub", ['payment'] = true, ['perm'] = "motoclub.permissao" },
	--[45] = { ['name'] = "Motoclub", ['payment'] = true, ['perm'] = "motoclub.permissao" },
	--[46] = { ['name'] = "Ballas", ['payment'] = true, ['perm'] = "ballas.permissao" },
	--[47] = { ['name'] = "Vagos", ['payment'] = true, ['perm'] = "vagos.permissao" },
	--[48] = { ['name'] = "Families", ['payment'] = true, ['perm'] = "families.permissao" },
	--[49] = { ['name'] = "Marabunta", ['payment'] = true, ['perm'] = "marabunta.permissao" },
	--[50] = { ['name'] = "Mafia", ['payment'] = true, ['perm'] = "mafia.permissao" },
--	[51] = { ['name'] = "Yakuza", ['payment'] = true, ['perm'] = "yakuza.permissao" },
--	[52] = { ['name'] = "Corleone", ['payment'] = true, ['perm'] = "corleone.permissao" },
--	[53] = { ['name'] = "Cosanostra", ['payment'] = true, ['perm'] = "cosanostra.permissao" },
--	[54] = { ['name'] = "Corredores", ['payment'] = false, ['perm'] = "corredores.permissao" },
	--[55] = { ['name'] = "Concessionaria", ['payment'] = false, ['public'] = true },
	--[56] = { ['name'] = "Exposicao", ['payment'] = false, ['perm'] = "conce.permissao" },
	--[57] = { ['name'] = "Exposicao", ['payment'] = false, ['perm'] = "conce.permissao" },
	[58] = { ['name'] = "Bicicletario", ['payment'] = true, ['public'] = true },
	[59] = { ['name'] = "Colheita", ['payment'] = false, ['public'] = true },
	[60] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "bennys.permissao" },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------FORTHILLS-----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[145] = { ['name'] = "FH01", ['payment'] = false, ['public'] = false },
	[148] = { ['name'] = "FH04", ['payment'] = false, ['public'] = false },
	[155] = { ['name'] = "FH11", ['payment'] = false, ['public'] = false },
	[159] = { ['name'] = "FH15", ['payment'] = false, ['public'] = false },
	[163] = { ['name'] = "FH19", ['payment'] = false, ['public'] = false },
	[167] = { ['name'] = "FH23", ['payment'] = false, ['public'] = false },
	[168] = { ['name'] = "FH24", ['payment'] = false, ['public'] = false },
	[170] = { ['name'] = "FH26", ['payment'] = false, ['public'] = false },
	[173] = { ['name'] = "FH29", ['payment'] = false, ['public'] = false },
	[175] = { ['name'] = "FH31", ['payment'] = false, ['public'] = false },
	[176] = { ['name'] = "FH32", ['payment'] = false, ['public'] = false },
	[189] = { ['name'] = "FH45", ['payment'] = false, ['public'] = false },
	[192] = { ['name'] = "FH48", ['payment'] = false, ['public'] = false },
	[193] = { ['name'] = "FH49", ['payment'] = false, ['public'] = false },
	[196] = { ['name'] = "FH52", ['payment'] = false, ['public'] = false },
	[198] = { ['name'] = "FH54", ['payment'] = false, ['public'] = false },
	[199] = { ['name'] = "FH55", ['payment'] = false, ['public'] = false },
	[202] = { ['name'] = "FH58", ['payment'] = false, ['public'] = false },
	[203] = { ['name'] = "FH59", ['payment'] = false, ['public'] = false },
	[212] = { ['name'] = "FH68", ['payment'] = false, ['public'] = false },
	[225] = { ['name'] = "FH81", ['payment'] = false, ['public'] = false },
	[235] = { ['name'] = "FH91", ['payment'] = false, ['public'] = false },
	[236] = { ['name'] = "FH92", ['payment'] = false, ['public'] = false },
	[237] = { ['name'] = "FH93", ['payment'] = false, ['public'] = false },
	[238] = { ['name'] = "FH94", ['payment'] = false, ['public'] = false },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------LUXURY--------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[245] = { ['name'] = "LX01", ['payment'] = false, ['public'] = false },
	[246] = { ['name'] = "LX02", ['payment'] = false, ['public'] = false },
	[247] = { ['name'] = "LX03", ['payment'] = false, ['public'] = false },
	[248] = { ['name'] = "LX04", ['payment'] = false, ['public'] = false },
	[249] = { ['name'] = "LX05", ['payment'] = false, ['public'] = false },
	[250] = { ['name'] = "LX06", ['payment'] = false, ['public'] = false },
	[251] = { ['name'] = "LX07", ['payment'] = false, ['public'] = false },
	[252] = { ['name'] = "LX08", ['payment'] = false, ['public'] = false },
	[253] = { ['name'] = "LX09", ['payment'] = false, ['public'] = false },
	[254] = { ['name'] = "LX10", ['payment'] = false, ['public'] = false },
	[255] = { ['name'] = "LX11", ['payment'] = false, ['public'] = false },
	[256] = { ['name'] = "LX12", ['payment'] = false, ['public'] = false },
	[257] = { ['name'] = "LX13", ['payment'] = false, ['public'] = false },
	[258] = { ['name'] = "LX14", ['payment'] = false, ['public'] = false },
	[259] = { ['name'] = "LX15", ['payment'] = false, ['public'] = false },
	[260] = { ['name'] = "LX16", ['payment'] = false, ['public'] = false },
	[261] = { ['name'] = "LX17", ['payment'] = false, ['public'] = false },
	[262] = { ['name'] = "LX18", ['payment'] = false, ['public'] = false },
	[263] = { ['name'] = "LX19", ['payment'] = false, ['public'] = false },
	[264] = { ['name'] = "LX20", ['payment'] = false, ['public'] = false },
	[265] = { ['name'] = "LX21", ['payment'] = false, ['public'] = false },
	[266] = { ['name'] = "LX22", ['payment'] = false, ['public'] = false },
	[267] = { ['name'] = "LX23", ['payment'] = false, ['public'] = false },
	[268] = { ['name'] = "LX24", ['payment'] = false, ['public'] = false },
	[269] = { ['name'] = "LX25", ['payment'] = false, ['public'] = false },
	[270] = { ['name'] = "LX26", ['payment'] = false, ['public'] = false },
	[271] = { ['name'] = "LX27", ['payment'] = false, ['public'] = false },
	[272] = { ['name'] = "LX28", ['payment'] = false, ['public'] = false },
	[273] = { ['name'] = "LX29", ['payment'] = false, ['public'] = false },
	[276] = { ['name'] = "LX32", ['payment'] = false, ['public'] = false },
	[278] = { ['name'] = "LX34", ['payment'] = false, ['public'] = false },
	[279] = { ['name'] = "LX35", ['payment'] = false, ['public'] = false },
	[280] = { ['name'] = "LX36", ['payment'] = false, ['public'] = false },
	[281] = { ['name'] = "LX37", ['payment'] = false, ['public'] = false },
	[282] = { ['name'] = "LX38", ['payment'] = false, ['public'] = false },
	[283] = { ['name'] = "LX39", ['payment'] = false, ['public'] = false },
	[284] = { ['name'] = "LX40", ['payment'] = false, ['public'] = false },
	[285] = { ['name'] = "LX41", ['payment'] = false, ['public'] = false },
	[286] = { ['name'] = "LX42", ['payment'] = false, ['public'] = false },
	[287] = { ['name'] = "LX43", ['payment'] = false, ['public'] = false },
	[288] = { ['name'] = "LX44", ['payment'] = false, ['public'] = false },
	[289] = { ['name'] = "LX45", ['payment'] = false, ['public'] = false },
	[290] = { ['name'] = "LX46", ['payment'] = false, ['public'] = false },
	[291] = { ['name'] = "LX47", ['payment'] = false, ['public'] = false },
	[292] = { ['name'] = "LX48", ['payment'] = false, ['public'] = false },
	[294] = { ['name'] = "LX50", ['payment'] = false, ['public'] = false },
	[295] = { ['name'] = "LX51", ['payment'] = false, ['public'] = false },
	[296] = { ['name'] = "LX52", ['payment'] = false, ['public'] = false },
	[297] = { ['name'] = "LX53", ['payment'] = false, ['public'] = false },
	[298] = { ['name'] = "LX54", ['payment'] = false, ['public'] = false },
	[299] = { ['name'] = "LX55", ['payment'] = false, ['public'] = false },
	[302] = { ['name'] = "LX58", ['payment'] = false, ['public'] = false },
	[303] = { ['name'] = "LX59", ['payment'] = false, ['public'] = false },
	[304] = { ['name'] = "LX60", ['payment'] = false, ['public'] = false },
	[305] = { ['name'] = "LX61", ['payment'] = false, ['public'] = false },
	[306] = { ['name'] = "LX62", ['payment'] = false, ['public'] = false },
	[307] = { ['name'] = "LX63", ['payment'] = false, ['public'] = false },
	[308] = { ['name'] = "LX64", ['payment'] = false, ['public'] = false },
	[309] = { ['name'] = "LX65", ['payment'] = false, ['public'] = false },
	[310] = { ['name'] = "LX66", ['payment'] = false, ['public'] = false },
	[311] = { ['name'] = "LX67", ['payment'] = false, ['public'] = false },
	[312] = { ['name'] = "LX68", ['payment'] = false, ['public'] = false },
	[313] = { ['name'] = "LX69", ['payment'] = false, ['public'] = false },
	[314] = { ['name'] = "LX70", ['payment'] = false, ['public'] = false },
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------SAMIR-------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[315] = { ['name'] = "LS01", ['payment'] = false, ['public'] = false },
	[316] = { ['name'] = "LS02", ['payment'] = false, ['public'] = false },
	[317] = { ['name'] = "LS03", ['payment'] = false, ['public'] = false },
	[318] = { ['name'] = "LS04", ['payment'] = false, ['public'] = false },
	[319] = { ['name'] = "LS05", ['payment'] = false, ['public'] = false },
	[320] = { ['name'] = "LS06", ['payment'] = false, ['public'] = false },
	[321] = { ['name'] = "LS07", ['payment'] = false, ['public'] = false },
	[322] = { ['name'] = "LS08", ['payment'] = false, ['public'] = false },
	[323] = { ['name'] = "LS09", ['payment'] = false, ['public'] = false },
	[324] = { ['name'] = "LS10", ['payment'] = false, ['public'] = false },
	[325] = { ['name'] = "LS11", ['payment'] = false, ['public'] = false },
	[326] = { ['name'] = "LS12", ['payment'] = false, ['public'] = false },
	[327] = { ['name'] = "LS13", ['payment'] = false, ['public'] = false },
	[328] = { ['name'] = "LS14", ['payment'] = false, ['public'] = false },
	[329] = { ['name'] = "LS15", ['payment'] = false, ['public'] = false },
	[330] = { ['name'] = "LS16", ['payment'] = false, ['public'] = false },
	[331] = { ['name'] = "LS17", ['payment'] = false, ['public'] = false },
	[332] = { ['name'] = "LS18", ['payment'] = false, ['public'] = false },
	[333] = { ['name'] = "LS19", ['payment'] = false, ['public'] = false },
	[334] = { ['name'] = "LS20", ['payment'] = false, ['public'] = false },
	[335] = { ['name'] = "LS21", ['payment'] = false, ['public'] = false },
	[336] = { ['name'] = "LS22", ['payment'] = false, ['public'] = false },
	[337] = { ['name'] = "LS23", ['payment'] = false, ['public'] = false },
	[338] = { ['name'] = "LS24", ['payment'] = false, ['public'] = false },
	[339] = { ['name'] = "LS25", ['payment'] = false, ['public'] = false },
	[340] = { ['name'] = "LS26", ['payment'] = false, ['public'] = false },
	[341] = { ['name'] = "LS27", ['payment'] = false, ['public'] = false },
	[342] = { ['name'] = "LS28", ['payment'] = false, ['public'] = false },
	[343] = { ['name'] = "LS29", ['payment'] = false, ['public'] = false },
	[344] = { ['name'] = "LS30", ['payment'] = false, ['public'] = false },
	[345] = { ['name'] = "LS31", ['payment'] = false, ['public'] = false },
	[346] = { ['name'] = "LS32", ['payment'] = false, ['public'] = false },
	[347] = { ['name'] = "LS33", ['payment'] = false, ['public'] = false },
	[348] = { ['name'] = "LS34", ['payment'] = false, ['public'] = false },
	[349] = { ['name'] = "LS35", ['payment'] = false, ['public'] = false },
	[350] = { ['name'] = "LS36", ['payment'] = false, ['public'] = false },
	[351] = { ['name'] = "LS37", ['payment'] = false, ['public'] = false },
	[352] = { ['name'] = "LS38", ['payment'] = false, ['public'] = false },
	[353] = { ['name'] = "LS39", ['payment'] = false, ['public'] = false },
	[354] = { ['name'] = "LS40", ['payment'] = false, ['public'] = false },
	[355] = { ['name'] = "LS41", ['payment'] = false, ['public'] = false },
	[356] = { ['name'] = "LS42", ['payment'] = false, ['public'] = false },
	[357] = { ['name'] = "LS43", ['payment'] = false, ['public'] = false },
	[358] = { ['name'] = "LS44", ['payment'] = false, ['public'] = false },
	[359] = { ['name'] = "LS45", ['payment'] = false, ['public'] = false },
	[360] = { ['name'] = "LS46", ['payment'] = false, ['public'] = false },
	[361] = { ['name'] = "LS47", ['payment'] = false, ['public'] = false },
	[362] = { ['name'] = "LS48", ['payment'] = false, ['public'] = false },
	[363] = { ['name'] = "LS49", ['payment'] = false, ['public'] = false },
	[364] = { ['name'] = "LS50", ['payment'] = false, ['public'] = false },
	[365] = { ['name'] = "LS51", ['payment'] = false, ['public'] = false },
	[366] = { ['name'] = "LS52", ['payment'] = false, ['public'] = false },
	[367] = { ['name'] = "LS53", ['payment'] = false, ['public'] = false },
	[368] = { ['name'] = "LS54", ['payment'] = false, ['public'] = false },
	[369] = { ['name'] = "LS55", ['payment'] = false, ['public'] = false },
	[370] = { ['name'] = "LS56", ['payment'] = false, ['public'] = false },
	[371] = { ['name'] = "LS57", ['payment'] = false, ['public'] = false },
	[372] = { ['name'] = "LS58", ['payment'] = false, ['public'] = false },
	[373] = { ['name'] = "LS59", ['payment'] = false, ['public'] = false },
	[374] = { ['name'] = "LS60", ['payment'] = false, ['public'] = false },
	[375] = { ['name'] = "LS61", ['payment'] = false, ['public'] = false },
	[376] = { ['name'] = "LS62", ['payment'] = false, ['public'] = false },
	[377] = { ['name'] = "LS63", ['payment'] = false, ['public'] = false },
	[378] = { ['name'] = "LS64", ['payment'] = false, ['public'] = false },
	[379] = { ['name'] = "LS65", ['payment'] = false, ['public'] = false },
	[380] = { ['name'] = "LS66", ['payment'] = false, ['public'] = false },
	[381] = { ['name'] = "LS67", ['payment'] = false, ['public'] = false },
	[382] = { ['name'] = "LS68", ['payment'] = false, ['public'] = false },
	[383] = { ['name'] = "LS69", ['payment'] = false, ['public'] = false },
	[384] = { ['name'] = "LS70", ['payment'] = false, ['public'] = false },
	[385] = { ['name'] = "LS71", ['payment'] = false, ['public'] = false },
	[386] = { ['name'] = "LS72", ['payment'] = false, ['public'] = false },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------KRONDORS------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[387] = { ['name'] = "KR01", ['payment'] = false, ['public'] = false },
	[388] = { ['name'] = "KR02", ['payment'] = false, ['public'] = false },
	[389] = { ['name'] = "KR03", ['payment'] = false, ['public'] = false },
	[390] = { ['name'] = "KR04", ['payment'] = false, ['public'] = false },
	[391] = { ['name'] = "KR05", ['payment'] = false, ['public'] = false },
	[392] = { ['name'] = "KR06", ['payment'] = false, ['public'] = false },
	[393] = { ['name'] = "KR07", ['payment'] = false, ['public'] = false },
	[394] = { ['name'] = "KR08", ['payment'] = false, ['public'] = false },
	[395] = { ['name'] = "KR09", ['payment'] = false, ['public'] = false },
	[396] = { ['name'] = "KR10", ['payment'] = false, ['public'] = false },
	[397] = { ['name'] = "KR11", ['payment'] = false, ['public'] = false },
	[398] = { ['name'] = "KR12", ['payment'] = false, ['public'] = false },
	[399] = { ['name'] = "KR13", ['payment'] = false, ['public'] = false },
	[400] = { ['name'] = "KR14", ['payment'] = false, ['public'] = false },
	[401] = { ['name'] = "KR15", ['payment'] = false, ['public'] = false },
	[402] = { ['name'] = "KR16", ['payment'] = false, ['public'] = false },
	[403] = { ['name'] = "KR17", ['payment'] = false, ['public'] = false },
	[404] = { ['name'] = "KR18", ['payment'] = false, ['public'] = false },
	[405] = { ['name'] = "KR19", ['payment'] = false, ['public'] = false },
	[406] = { ['name'] = "KR20", ['payment'] = false, ['public'] = false },
	[407] = { ['name'] = "KR21", ['payment'] = false, ['public'] = false },
	[408] = { ['name'] = "KR22", ['payment'] = false, ['public'] = false },
	[409] = { ['name'] = "KR23", ['payment'] = false, ['public'] = false },
	[410] = { ['name'] = "KR24", ['payment'] = false, ['public'] = false },
	[411] = { ['name'] = "KR25", ['payment'] = false, ['public'] = false },
	[412] = { ['name'] = "KR26", ['payment'] = false, ['public'] = false },
	[413] = { ['name'] = "KR27", ['payment'] = false, ['public'] = false },
	[414] = { ['name'] = "KR28", ['payment'] = false, ['public'] = false },
	[415] = { ['name'] = "KR29", ['payment'] = false, ['public'] = false },
	[416] = { ['name'] = "KR30", ['payment'] = false, ['public'] = false },
	[417] = { ['name'] = "KR31", ['payment'] = false, ['public'] = false },
	[418] = { ['name'] = "KR32", ['payment'] = false, ['public'] = false },
	[419] = { ['name'] = "KR33", ['payment'] = false, ['public'] = false },
	[420] = { ['name'] = "KR34", ['payment'] = false, ['public'] = false },
	[421] = { ['name'] = "KR35", ['payment'] = false, ['public'] = false },
	[422] = { ['name'] = "KR36", ['payment'] = false, ['public'] = false },
	[423] = { ['name'] = "KR37", ['payment'] = false, ['public'] = false },
	[424] = { ['name'] = "KR38", ['payment'] = false, ['public'] = false },
	[425] = { ['name'] = "KR39", ['payment'] = false, ['public'] = false },
	[426] = { ['name'] = "KR40", ['payment'] = false, ['public'] = false },
	[427] = { ['name'] = "KR41", ['payment'] = false, ['public'] = false },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------LOSVAGOS------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[428] = { ['name'] = "LV01", ['payment'] = false, ['public'] = false },
	[429] = { ['name'] = "LV02", ['payment'] = false, ['public'] = false },
	[430] = { ['name'] = "LV03", ['payment'] = false, ['public'] = false },
	[431] = { ['name'] = "LV04", ['payment'] = false, ['public'] = false },
	[432] = { ['name'] = "LV05", ['payment'] = false, ['public'] = false },
	[433] = { ['name'] = "LV06", ['payment'] = false, ['public'] = false },
	[434] = { ['name'] = "LV07", ['payment'] = false, ['public'] = false },
	[435] = { ['name'] = "LV08", ['payment'] = false, ['public'] = false },
	[436] = { ['name'] = "LV09", ['payment'] = false, ['public'] = false },
	[437] = { ['name'] = "LV10", ['payment'] = false, ['public'] = false },
	[438] = { ['name'] = "LV11", ['payment'] = false, ['public'] = false },
	[439] = { ['name'] = "LV12", ['payment'] = false, ['public'] = false },
	[440] = { ['name'] = "LV13", ['payment'] = false, ['public'] = false },
	[441] = { ['name'] = "LV14", ['payment'] = false, ['public'] = false },
	[442] = { ['name'] = "LV15", ['payment'] = false, ['public'] = false },
	[443] = { ['name'] = "LV16", ['payment'] = false, ['public'] = false },
	[444] = { ['name'] = "LV17", ['payment'] = false, ['public'] = false },
	[445] = { ['name'] = "LV18", ['payment'] = false, ['public'] = false },
	[446] = { ['name'] = "LV19", ['payment'] = false, ['public'] = false },
	[447] = { ['name'] = "LV20", ['payment'] = false, ['public'] = false },
	[448] = { ['name'] = "LV21", ['payment'] = false, ['public'] = false },
	[449] = { ['name'] = "LV22", ['payment'] = false, ['public'] = false },
	[450] = { ['name'] = "LV23", ['payment'] = false, ['public'] = false },
	[451] = { ['name'] = "LV24", ['payment'] = false, ['public'] = false },
	[452] = { ['name'] = "LV25", ['payment'] = false, ['public'] = false },
	[453] = { ['name'] = "LV26", ['payment'] = false, ['public'] = false },
	[454] = { ['name'] = "LV27", ['payment'] = false, ['public'] = false },
	[455] = { ['name'] = "LV28", ['payment'] = false, ['public'] = false },
	[456] = { ['name'] = "LV29", ['payment'] = false, ['public'] = false },
	[457] = { ['name'] = "LV30", ['payment'] = false, ['public'] = false },
	[458] = { ['name'] = "LV31", ['payment'] = false, ['public'] = false },
	[459] = { ['name'] = "LV32", ['payment'] = false, ['public'] = false },
	[460] = { ['name'] = "LV33", ['payment'] = false, ['public'] = false },
	[461] = { ['name'] = "LV34", ['payment'] = false, ['public'] = false },
	[462] = { ['name'] = "LV35", ['payment'] = false, ['public'] = false },
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------PALETOBAY-------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[463] = { ['name'] = "PB01", ['payment'] = false, ['public'] = false },
	[464] = { ['name'] = "PB02", ['payment'] = false, ['public'] = false },
	[465] = { ['name'] = "PB03", ['payment'] = false, ['public'] = false },
	[466] = { ['name'] = "PB04", ['payment'] = false, ['public'] = false },
	[467] = { ['name'] = "PB05", ['payment'] = false, ['public'] = false },
	[468] = { ['name'] = "PB06", ['payment'] = false, ['public'] = false },
	[469] = { ['name'] = "PB07", ['payment'] = false, ['public'] = false },
	[470] = { ['name'] = "PB08", ['payment'] = false, ['public'] = false },
	[471] = { ['name'] = "PB09", ['payment'] = false, ['public'] = false },
	[472] = { ['name'] = "PB10", ['payment'] = false, ['public'] = false },
	[473] = { ['name'] = "PB11", ['payment'] = false, ['public'] = false },
	[474] = { ['name'] = "PB12", ['payment'] = false, ['public'] = false },
	[475] = { ['name'] = "PB13", ['payment'] = false, ['public'] = false },
	[476] = { ['name'] = "PB14", ['payment'] = false, ['public'] = false },
	[477] = { ['name'] = "PB15", ['payment'] = false, ['public'] = false },
	[478] = { ['name'] = "PB16", ['payment'] = false, ['public'] = false },
	[479] = { ['name'] = "PB17", ['payment'] = false, ['public'] = false },
	[480] = { ['name'] = "PB18", ['payment'] = false, ['public'] = false },
	[481] = { ['name'] = "PB19", ['payment'] = false, ['public'] = false },
	[482] = { ['name'] = "PB20", ['payment'] = false, ['public'] = false },
	[483] = { ['name'] = "PB21", ['payment'] = false, ['public'] = false },
	[484] = { ['name'] = "PB22", ['payment'] = false, ['public'] = false },
	[485] = { ['name'] = "PB23", ['payment'] = false, ['public'] = false },
	[486] = { ['name'] = "PB24", ['payment'] = false, ['public'] = false },
	[487] = { ['name'] = "PB25", ['payment'] = false, ['public'] = false },
	[488] = { ['name'] = "PB26", ['payment'] = false, ['public'] = false },
	[489] = { ['name'] = "PB27", ['payment'] = false, ['public'] = false },
	[490] = { ['name'] = "PB28", ['payment'] = false, ['public'] = false },
	[491] = { ['name'] = "PB29", ['payment'] = false, ['public'] = false },
	[492] = { ['name'] = "PB30", ['payment'] = false, ['public'] = false },
	[493] = { ['name'] = "PB31", ['payment'] = false, ['public'] = false },
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------MANSAO------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	[600] = { ['name'] = "MS01", ['payment'] = false, ['public'] = false },
	[601] = { ['name'] = "MS02", ['payment'] = false, ['public'] = false },
	[602] = { ['name'] = "MS03", ['payment'] = false, ['public'] = false },
	[603] = { ['name'] = "MS04", ['payment'] = false, ['public'] = false },
	[604] = { ['name'] = "MS05", ['payment'] = false, ['public'] = false },
	[605] = { ['name'] = "MS09", ['payment'] = false, ['public'] = false },
	[606] = { ['name'] = "SS01", ['payment'] = false, ['public'] = false },

	[607] = { ['name'] = "MS08", ['payment'] = false, ['public'] = false },

	--[608] = { ['name'] = "Exposicao", ['payment'] = false, ['perm'] = "conce.permissao" },
	--[609] = { ['name'] = "FZ01", ['payment'] = false, ['public'] = false },
	--[610] = { ['name'] = "Piloto", ['payment'] = false, ['perm'] = "piloto.permissao" },	
	--[611] = { ['name'] = "Fotos", ['payment'] = false, ['perm'] = "admin.permissao" },

	[612] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "ballas.permissao" },
	[613] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "groove.permissao" },
	[614] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "vagos.permissao" },
	[615] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "mafia.permissao" },
	[616] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "bahamas.permissao" },
	[617] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "motoclub.permissao" },
	[618] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "bloods.permissao" },
	[619] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "yakuza.permissao" },
	[634] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "crips.permissao" },

	--[[[620] = { ['name'] = "Ballas Exclusivo", ['payment'] = false, ['perm'] = "ballas.permissao" },
	[621] = { ['name'] = "Groove Exclusivo", ['payment'] = false, ['perm'] = "groove.permissao" },
	[622] = { ['name'] = "Vagos Exclusivo", ['payment'] = false, ['perm'] = "vagos.permissao" },
	[623] = { ['name'] = "Mafia 01", ['payment'] = false, ['perm'] = "mafia.permissao" },
	[624] = { ['name'] = "Mafia 02", ['payment'] = false, ['perm'] = "mafia2.permissao" },
	[625] = { ['name'] = "MotoClub 01", ['payment'] = false, ['perm'] = "motoclub.permissao" },
	[626] = { ['name'] = "Bloods", ['payment'] = false, ['perm'] = "bloods.permissao" },
	--[627] = { ['name'] = "Yakuza Exclusivo", ['payment'] = false, ['perm'] = "yakuza.permissao" },
	[628] = { ['name'] = "Crips", ['payment'] = false, ['perm'] = "crips.permissao" },]]
	[629] = { ['name'] = "Test Drive 01", ['payment'] = false, ['perm'] = "conce.permissao" },
	[630] = { ['name'] = "Test Drive 02", ['payment'] = false, ['perm'] = "conce.permissao" },
	[631] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "mafia2.permissao" },
	[632] = { ['name'] = "Pizza", ['payment'] = false, ['public'] = true },
	[633] = { ['name'] = "Transporte", ['payment'] = false, ['public'] = true },
	[635] = { ['name'] = "Bahamas", ['payment'] = false, ['perm'] = "bahamas.permissao" },
	[636] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "bahamas.permissao" },
	[637] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[638] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[639] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	[640] = { ['name'] = "Garagem", ['payment'] = true, ['public'] = true },
	--[641] = { ['name'] = "Garagem", ['payment'] = false, ['perm'] = "liberty.permissao" },
	[642] = { ['name'] = "Garagem", ['payment'] = false, ['perm'] = "weazelnews.permissao" },
	[643] = { ['name'] = "Weazelnews", ['payment'] = false, ['perm'] = "weazelnews.permissao" },
	[644] = { ['name'] = "WeazelHeli", ['payment'] = false, ['perm'] = "weazelnews.permissao" },
	[645] = { ['name'] = "Aeroporto", ['payment'] = true, ['public'] = true },
	[646] = { ['name'] = "Aeroporto", ['payment'] = true, ['public'] = true },
	[647] = { ['name'] = "PoliciaH", ['payment'] = false, ['perm'] = "policia.permissao" },
	[648] = { ['name'] = "Policia", ['payment'] = false, ['perm'] = "policia.permissao" },
	[649] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "mafia.permissao" },
	[650] = { ['name'] = "Garagem", ['payment'] = true, ['perm'] = "mafia2.permissao" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
local workgarage = {
	["Policia"] = {
		"policiabmwr1200",  
		"policeb",
		"policiataurus",
		"policiacapricesid",
		"policiaschaftersid",
		"policiamustanggt",
		"policiacharger2018",
		"policiavictoria",
		"policiaexplorer",
		"policiatahoe",
		"policiasilverado",
		"fbi2"

	},
	["PoliciaB"] = {
		"pbus",
		"policet",
		"riot"
	},
	["PoliciaH"] = {
		"policiaheli"
	},
	["Paramedico"] = {
		"paramedicoambu",
		"paramedicobmwr1200",
		"paramedicosilverado",
		"paramedicocharger2014",
		"paramedicotahoe"
	},
	["ParamedicoH"] = {
		"paramedicoheli",
		"seasparrow"
	},
	["Motorista"] = {
		"coach",
		"bus"
	},
	["Aeroporto"] = {
		"faggio2"
	},
	["Mecanico"] = {
		"flatbed3",
		"towtruck2",
		"rebel"
	},
	["Mecanico LS"] = {
		"flatbed3",
		"towtruck2"
	},
	["Lenhador"] = {
		"ratloader"
	},
	["Minerador"] = {
		"rubble"
	},
	["Taxista"] = {
		"taxi"
	},
	["Carteiro"] = {
		"boxville2"
	},
	["Lixeiro"] = {
		"trash"
	},
	["Caminhoneiro"] = {
		"phantom",
		"packer"
	},
	["Bicicletario"] = {
		"tribike",
		"tribike2",
		"tribike3",
		"fixter",
		"cruiser",
		"bmx"
	},
	["Embarcações"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark3",
		"speeder",
		"speeder2",
		"squalo",
		"suntrap",
		"toro",
		"toro2",
		"tropic",
		"tropic2",
		"surfboard"
	},
	["Pilotos"] = {
		"supervolito",
		"supervolito2",
		"cuban800",
		"mammatus",
		"vestra",
		"velum2",
		"buzzard2",
		"frogger",
		"maverick"
	},
	["Trilhas"] = {
		"blazer",
		"blazer4"
	},
	["Caminhoneiro"] = {
		"phantom",
		"packer"
	},
	["Weazelnews"] = {
		"newsvan",
		"newsvan2"
	},
	["WeazelHeli"] = {
		"newsheli2"
	},
	["Ballas Exclusivo"] = {
		"buccaneer2",
		"bmx"
	},
	["Groove Exclusivo"] = {
		"chino",
		"bmx"
	},
	["Vagos Exclusivo"] = {
		"chino2",
		"bmx"
	},
	["Mafia 01"] = {
		"baller4",
		"dubsta3",
		"mesa3"
	},
	["Mafia 02"] = {
		"schafter4",
		"schafter6",
        "mesa3"
	},
	["MotoClub 01"] = {
		"zombieb",
		"gargoyle",
		"daemon",
		"gburrito",
		"slamvan2"
	},
	["MotoClub 02"] = {
		"deathbike",
		"gargoyle",
		"rebel",
		"ratbike",
		"rumpo3"
	},
	["Bloods"] = {
		"impaler",
		"bmx"
	},
	["Crips"] = {
		"nightshade",
		"buccaneer2",
		"bmx"
	},
	["Yakuza Exclusivo"] = {
		"superd",
		"schafter3"
	},
	["Test Drive 01"] = {
		"ferrariitalia",
		"fordmustang",
		"nissangtr",
		"nissangtrnismo",
		"teslaprior",
		"nissanskyliner34",
		"audirs6",
		"bmwm3f80",
		"bmwm4gts",
		"lancerevolutionx",
		"toyotasupra",
		"dodgechargersrt",
		"mazdarx7",
		"paganihuayra",
		"C7"
	},
	["Test Drive 02"] = {
		"2016RS7",
		"m6f13",
		"trhawk",
		"BOSS429",
		"z4bmw",
		"x6m",
		"rmodmi8",
		"r8v10abt",
		"W900",
		"lp770r",
		"gt17",
		"panamera17turbo",
		"19ftype",
		"z1000",
		"bmws",
		"veneno",
		"zl12017"
	},
	["Pizza"] = {
		"faggio2"
	},
	["Valores"] = {
		"stockade"
	},
	["Los Santos Customs"] = {
		"flatbed",
		"towtruck2"
	},
	["Bahamas"] = {
		"stretch",
		"baller4"
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.myVehicles(work)
	local source = source
	local user_id = vRP.getUserId(source)
	local myvehicles = {}
	local ipva = ""
	local status = ""
	if user_id then
		if workgarage[work] then
			for k,v in pairs(workgarage) do
				if k == work then
					for k2,v2 in pairs(v) do
						status = "<span class=\"green\">"..k.."</span>"
						ipva = "<span class=\"green\">Pago</span>"
						table.insert(myvehicles,{ name = v2, name2 = vRP.vehicleName(v2), engine = 100, body = 100, fuel = 100, status = status, ipva = ipva })
					end
				end
			end
			return myvehicles
		else
			local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(user_id) })
			local address = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) })
			if #address > 0 then
				for k,v in pairs(address) do
					if v.home == work then
						for k2,v2 in pairs(vehicle) do
							if parseInt(os.time()) <= parseInt(vehicle[k2].time+24*60*60) then
								status = "<span class=\"red\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.5)).."</span>"
							elseif vehicle[k2].detido == 1 then
								status = "<span class=\"orange\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.1)).."</span>"
							else
								status = "<span class=\"green\">Gratuita</span>"
							end

							if parseInt(os.time()) >= parseInt(vehicle[k2].ipva+24*10*60*60) then
								ipva = "<span class=\"red\">Atrasado</span>"
							else
								ipva = "<span class=\"green\">Pago</span>"
							end
							table.insert(myvehicles,{ name = vehicle[k2].vehicle, name2 = vRP.vehicleName(vehicle[k2].vehicle), engine = parseInt(vehicle[k2].engine*0.1), body = parseInt(vehicle[k2].body*0.1), fuel = parseInt(vehicle[k2].fuel), status = status, ipva = ipva })
						end
						return myvehicles
					else
						for k2,v2 in pairs(vehicle) do
							if parseInt(os.time()) <= parseInt(vehicle[k2].time+24*60*60) then
								status = "<span class=\"red\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.5)).."</span>"
							elseif vehicle[k2].detido == 1 then
								status = "<span class=\"orange\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.1)).."</span>"
							else
								status = "<span class=\"green\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.01)).."</span>"
							end

							if parseInt(os.time()) >= parseInt(vehicle[k2].ipva+24*10*60*60) then
								ipva = "<span class=\"red\">Atrasado</span>"
							else
								ipva = "<span class=\"green\">Pago</span>"
							end
							table.insert(myvehicles,{ name = vehicle[k2].vehicle, name2 = vRP.vehicleName(vehicle[k2].vehicle), engine = parseInt(vehicle[k2].engine*0.1), body = parseInt(vehicle[k2].body*0.1), fuel = parseInt(vehicle[k2].fuel), status = status, ipva = ipva })
						end
						return myvehicles
					end
				end
			else
				for k,v in pairs(vehicle) do
					if parseInt(os.time()) <= parseInt(vehicle[k].time+24*60*60) then
						status = "<span class=\"red\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.5)).."</span>"
					elseif vehicle[k].detido == 1 then
						status = "<span class=\"orange\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.1)).."</span>"
					else
						status = "<span class=\"green\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.01)).."</span>"
					end

					if parseInt(os.time()) >= parseInt(vehicle[k].ipva+24*10*60*60) then
						ipva = "<span class=\"red\">Atrasado</span>"
					else
						ipva = "<span class=\"green\">Pago</span>"
					end
					table.insert(myvehicles,{ name = vehicle[k].vehicle, name2 = vRP.vehicleName(vehicle[k].vehicle), engine = parseInt(vehicle[k].engine*0.1), body = parseInt(vehicle[k].body*0.1), fuel = parseInt(vehicle[k].fuel), status = status, ipva = ipva })
				end
				return myvehicles
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.spawnVehicles(name,use)
	if name then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			local identity = vRP.getUserIdentity(user_id)
			if not vCLIENT.returnVehicle(source,name) then
				local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })
				local tuning = vRP.getSData("custom:u"..user_id.."veh_"..name) or {}
				local custom = json.decode(tuning) or {}
				if vehicle[1] ~= nil then
					if parseInt(os.time()) <= parseInt(vehicle[1].time+24*60*60) then
						local ok = vRP.request(source,"Seu Veículo foi aprendido pela policia, deseja acionar o seguro pagando <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.5)).."</b> dólares?",60)
						if ok then
							if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.5)) then
								vRP.execute("creative/set_detido",{ user_id = parseInt(user_id), vehicle = name, detido = 0, time = 0 })
								TriggerClientEvent("Notify",source,"sucesso","Veículo liberado.",10000)
							else
								TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
							end
						end
					elseif parseInt(vehicle[1].detido) >= 1 then
						local ok = vRP.request(source,"Seu Veículo foi desmanchado  deseja acionar o seguro pagando <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.1)).."</b> dólares?",60)
						if ok then
							if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.1)) then
								vRP.execute("creative/set_detido",{ user_id = parseInt(user_id), vehicle = name, detido = 0, time = 0 })
								TriggerClientEvent("Notify",source,"sucesso","Veículo liberado.",10000)
							else
								TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
							end
						end
					else
						if parseInt(os.time()) <= parseInt(vehicle[1].ipva+24*10*60*60) then
							if garages[use].payment then
								if (vRP.getBankMoney(user_id)+vRP.getMoney(user_id)) >= parseInt(vRP.vehiclePrice(name)*0.01) then
									local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,vehicle[1].engine,vehicle[1].body,vehicle[1].fuel,custom,parseInt(vehicle[1].colorR),parseInt(vehicle[1].colorG),parseInt(vehicle[1].colorB),parseInt(vehicle[1].color2R),parseInt(vehicle[1].color2G),parseInt(vehicle[1].color2B),false)
									if spawnveh and vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.01)) then
										vehlist[vehid] = { user_id,name }
										TriggerEvent("setPlateEveryone",identity.registration)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
								end
							else
								local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,vehicle[1].engine,vehicle[1].body,vehicle[1].fuel,custom,parseInt(vehicle[1].colorR),parseInt(vehicle[1].colorG),parseInt(vehicle[1].colorB),parseInt(vehicle[1].color2R),parseInt(vehicle[1].color2G),parseInt(vehicle[1].color2B),false)
								if spawnveh then
									vehlist[vehid] = { user_id,name }
									TriggerEvent("setPlateEveryone",identity.registration)
								end
							end
						else
							local ok = vRP.request(source,"Deseja pagar o <b>Vehicle Tax</b> do veículo <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.10)).."</b> dólares?",60)
							if ok then
								if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.10)) then
									vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
									TriggerClientEvent("Notify",source,"sucesso","Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.",10000)
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
								end
							end
						end
					end
				else
					local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,1000,1000,100,custom,0,0,0,0,0,0,true)
					if spawnveh then
						vehlist[vehid] = { user_id,name }
						TriggerEvent("setPlateEveryone",identity.registration)
					end
				end
			else
				TriggerClientEvent("Notify",source,"aviso","Já possui um veículo deste modelo fora da garagem.",10000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.deleteVehicles()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRPclient.getNearestVehicle(source,20)
		if vehicle then
			vCLIENT.deleteVehicle(source,vehicle)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dv.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			vCLIENT.deleteVehicle(source,vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRIMARYCOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("primaryColors")
AddEventHandler("primaryColors",function(r,g,b,r2,g2,b2)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"bennys.permissao") or vRP.hasPermission(user_id,"liberty.permissao") and vRPclient.isInVehicle(source) then
		local vehicle,vnetid,placa,vname = vRPclient.vehList(source,7)
		if vehicle then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				vCLIENT.vehiclePrimary(source,vehicle,parseInt(r),parseInt(g),parseInt(b))
				local ok = vRP.request(source,"Deseja aplicar a cor selecionada no veículo?",30)
				if ok then
					if vRP.tryFullPayment(user_id,3000) then
						TriggerClientEvent("Notify",source,"sucesso","Aplicada com sucesso.",8000)
						vRP.execute("creative/set_priColor",{ user_id = puser_id, vehicle = vname, colorR = parseInt(r), colorG = parseInt(g), colorB = parseInt(b) })
					else
						vCLIENT.vehiclePrimary(source,vehicle,parseInt(r2),parseInt(g2),parseInt(b2))
					end
				else
					vCLIENT.vehiclePrimary(source,vehicle,parseInt(r2),parseInt(g2),parseInt(b2))
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRIMARYCOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("secondaryColors")
AddEventHandler("secondaryColors",function(r,g,b,r2,g2,b2)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"bennys.permissao") or vRP.hasPermission(user_id,"liberty.permissao") and vRPclient.isInVehicle(source) then
		local vehicle,vnetid,placa,vname = vRPclient.vehList(source,7)
		if vehicle then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				vCLIENT.vehicleSecondary(source,vehicle,parseInt(r),parseInt(g),parseInt(b))
				local ok = vRP.request(source,"Deseja aplicar a cor selecionada no veículo?",30)
				if ok then
					if vRP.tryFullPayment(user_id,3000) then
						TriggerClientEvent("Notify",source,"sucesso","Aplicada com sucesso.",8000)
						vRP.execute("creative/set_secColor",{ user_id = puser_id, vehicle = vname, color2R = parseInt(r), color2G = parseInt(g), color2B = parseInt(b) })
					else
						vCLIENT.vehiclePrimary(source,vehicle,parseInt(r2),parseInt(g2),parseInt(b2))
					end
				else
					vCLIENT.vehicleSecondary(source,vehicle,parseInt(r2),parseInt(g2),parseInt(b2))
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLELOCK
-----------------------------------------------------------------------------------------------------------------------------------------
function src.vehicleLock()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		if vehicle and placa then
			local placa_user_id = vRP.getUserByRegistration(placa)
			if user_id == placa_user_id then
				vCLIENT.vehicleClientLock(-1,vnetid,lock)
				TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
				vRPclient.playAnim(source,true,{{"anim@mp_player_intmenu@key_fob@","fob_click"}},false)
				if lock == 1 then
					TriggerClientEvent("Notify",source,"importante","Veículo <b>destrancado</b> com sucesso.",8000)
				else
					TriggerClientEvent("Notify",source,"importante","Veículo <b>trancado</b> com sucesso.",8000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.tryDelete(vehid,vehengine,vehbody,vehfuel)
	if vehlist[vehid] and vehid ~= 0 then
		local user_id = vehlist[vehid][1]
		local vehname = vehlist[vehid][2]
		local player = vRP.getUserSource(user_id)
		if player then
			vCLIENT.syncNameDelete(player,vehname)
		end

		if vehengine <= 100 then
			vehengine = 100
		end

		if vehbody <= 100 then
			vehbody = 100
		end

		if vehfuel >= 100 then
			vehfuel = 100
		end

		local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehname })
		if vehicle[1] ~= nil then
			vRP.execute("creative/set_update_vehicles",{ user_id = parseInt(user_id), vehicle = vehname, engine = parseInt(vehengine), body = parseInt(vehbody), fuel = parseInt(vehfuel) })
		end
	end
	vCLIENT.syncVehicle(-1,vehid)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryDeleteVehicle")
AddEventHandler("tryDeleteVehicle",function(vehid)
	vCLIENT.syncVehicle(-1,vehid)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNHOUSES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.returnHouses(nome,garage)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			local address = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) })
			if #address > 0 then
				for k,v in pairs(address) do
					if v.home == garages[garage].name then
						if parseInt(v.garage) == 1 then
							local resultOwner = vRP.query("homes/get_homeuseridowner",{ home = tostring(nome) })
							if resultOwner[1] then
								if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*10*60*60) then
									TriggerClientEvent("Notify",source,"aviso","A <b>Property Tax</b> da residência está atrasada.",10000)
									return false
								else
									vCLIENT.openGarage(source,nome,garage)
								end
							end
						end
					end
				end
			end
			if garages[garage].perm == "livre" then
				return vCLIENT.openGarage(source,nome,garage)
			elseif garages[garage].perm then
				if vRP.hasPermission(user_id,garages[garage].perm) then
					return vCLIENT.openGarage(source,nome,garage)
				end
			elseif garages[garage].public then
				return vCLIENT.openGarage(source,nome,garage)
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCORAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ancorar',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.isInVehicle(source) then
			local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
			if vehicle then
				vCLIENT.vehicleAnchor(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") then
			if args[1] then
				TriggerClientEvent('spawnarveiculo',source,args[1])
				TriggerEvent("setPlateEveryone",identity.registration)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('vehs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] and parseInt(args[2]) > 0 then
			local myvehicles = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(args[1]) })
			if myvehicles[1] then
				if vRP.vehicleType(tostring(args[1])) == "polpar" and not vRP.hasPermission(parseInt(args[2]),"polpar.permissao") then
					TriggerClientEvent("Notify",source,"negado","<b>"..vRP.vehicleName(tostring(args[1])).."</b> não pode ser transferido por ser um veículo <b>Premium</b>.",10000)
				else
					local maxvehs = vRP.query("creative/con_maxvehs",{ user_id = parseInt(args[2]) })
					local maxgars = vRP.query("creative/get_users",{ user_id = parseInt(args[2]) })
					if vRP.hasPermission(user_id,"conce.permissao") then
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 10 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					elseif vRP.hasPermission(user_id,"diamante.permissao") then
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 10 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					elseif vRP.hasPermission(user_id,"platina.permissao") then
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 8 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					elseif vRP.hasPermission(user_id,"ouro.permissao") then
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 6 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					elseif vRP.hasPermission(user_id,"prata.permissao") then
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 5 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					elseif vRP.hasPermission(user_id,"bronze.permissao") then
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 4 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					else
						if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 3 then
							TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos na garagem.",8000)
							return
						end
					end

					local identity = vRP.getUserIdentity(parseInt(args[2]))
					if vRP.request(source,"Deseja transferir o veículo <b>"..vRP.vehicleName(tostring(args[1])).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>?",30) then
						local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(args[2]), vehicle = tostring(args[1]) })
						if vehicle[1] then
							TriggerClientEvent("Notify",source,"negado","<b>"..identity.name.." "..identity.firstname.."</b> já possui este modelo de veículo.",10000)
						else
							vRP.execute("creative/move_vehicle",{ user_id = parseInt(user_id), nuser_id = parseInt(args[2]), vehicle = tostring(args[1]) })

							local custom = vRP.getSData("custom:u"..parseInt(user_id).."veh_"..tostring(args[1]))
							local custom2 = json.decode(custom) or {}
							if custom2 then
								vRP.setSData("custom:u"..parseInt(args[2]).."veh_"..tostring(args[1]),json.encode(custom2))
								vRP.execute("creative/rem_srv_data",{ dkey = "custom:u"..parseInt(user_id).."veh_"..tostring(args[1]) })
							end

							local chest = vRP.getSData("chest:u"..parseInt(user_id).."veh_"..tostring(args[1]))
							local chest2 = json.decode(chest) or {}
							if chest2 then
								vRP.setSData("chest:u"..parseInt(args[2]).."veh_"..tostring(args[1]),json.encode(chest2))
								vRP.execute("creative/rem_srv_data",{ dkey = "chest:u"..parseInt(user_id).."veh_"..tostring(args[1]) })
							end

							TriggerClientEvent("Notify",source,"sucesso","Transferência concluída com sucesso.",20000)
						end
					end
				end
			end
		else
			local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(user_id) })
			for k,v in pairs(vehicle) do
				if parseInt(os.time()) >= parseInt(v.ipva+24*10*60*60) then
					TriggerClientEvent("Notify",source,"negado","<b>Modelo:</b> "..v.vehicle.."<br><b>Veh Tax:</b> Atrasado",20000)
				else
					TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle.."<br>Taxa em "..vRP.getDayHours(parseInt(86400*10-(os.time()-v.ipva))),20000)
				end
			end
		end
	end
end)