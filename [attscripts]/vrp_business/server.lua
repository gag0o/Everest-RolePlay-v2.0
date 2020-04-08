--CREATE TABLE IF NOT EXISTS `nav_business`(
--	`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--	`user_id` int(11) NOT NULL,
--	`shop_id` int(11) NOT NULL,
--	`capital` int(11) NOT NULL,
--	`launded` int(11) NOT NULL,
--	`timelap` int(11) NOT NULL,
--	PRIMARY KEY (`id`)
--) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--
--ALTER TABLE `nav_business` ADD KEY `user_id` (`user_id`);
--ALTER TABLE `nav_business` ADD KEY `shop_id` (`shop_id`);
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
Tunnel.bindInterface("vrp_business",src)
vCLIENT = Tunnel.getInterface("vrp_business")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("nav/get_business","SELECT * FROM nav_business WHERE shop_id = @shop_id AND owner = @owner")
vRP._prepare("nav/get_allbusiness","SELECT * FROM nav_business WHERE shop_id = @shop_id")
vRP._prepare("nav/check_business","SELECT * FROM nav_business WHERE user_id = @user_id AND shop_id = @shop_id AND owner = 1")
vRP._prepare("nav/use_business","SELECT * FROM nav_business WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/add_invest","UPDATE nav_business SET capital = capital + @capital WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/add_launded","UPDATE nav_business SET launded = launded + @launded WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/del_business","DELETE FROM nav_business WHERE shop_id = @shop_id")
vRP._prepare("nav/rem_permission","DELETE FROM nav_business WHERE shop_id = @shop_id AND user_id = @user_id")
vRP._prepare("nav/put_business","INSERT IGNORE INTO nav_business(user_id,shop_id,capital,launded,timelap,owner) VALUES(@user_id,@shop_id,@capital,@launded,@timelap,@owner)")
vRP._prepare("nav/res_business","UPDATE nav_business SET launded = 0, timelap = @timelap WHERE user_id = @user_id AND shop_id = @shop_id")
vRP._prepare("nav/count_business","SELECT COUNT(*) as qtd FROM nav_business WHERE shop_id = @shop_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local shoplist = { -- price,max,%minium,%maxium,name,qtdd de donos
	[1] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[2] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[3] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[4] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[5] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[6] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[7] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[8] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[9] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[10] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[11] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[12] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[13] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[14] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[15] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[16] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[17] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[18] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[19] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[20] = { 750000,500000,85,95,"Loja de Departamento",2 },
	[21] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[22] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[23] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[24] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[25] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[26] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[27] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[28] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[29] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[30] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[31] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[32] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[33] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[34] = { 500000,350000,85,95,"Loja de Roupas",2 },
	[35] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[36] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[37] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[38] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[39] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[40] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[41] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[42] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[43] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[44] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[45] = { 1000000,750000,85,95,"Loja de Armamentos",2 },
	[46] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[47] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[48] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[49] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[50] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[51] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[52] = { 850000,600000,85,95,"Salão de Beleza",2 },
	[53] = { 1250000,1000000,85,95,"Loja de Tatuagens",2 },
	[54] = { 1250000,1000000,85,95,"Loja de Tatuagens",2 },
	[55] = { 1250000,1000000,85,95,"Loja de Tatuagens",2 },
	[56] = { 1250000,1000000,85,95,"Loja de Tatuagens",2 },
	[57] = { 1250000,1000000,85,95,"Loja de Tatuagens",2 },
	[58] = { 1250000,1000000,85,95,"Loja de Tatuagens",2 },
	[59] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[60] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[61] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[62] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[63] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[64] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[65] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[66] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[67] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[68] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[69] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[70] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[71] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[72] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[73] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[74] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[75] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[76] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[77] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[78] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[79] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[80] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[81] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[82] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[83] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[84] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[85] = { 2000000,1500000,85,95,"Posto de Gasolina",2 },
	[86] = { 5000000,4800000,85,95,"Bar",3 },
	[87] = { 5000000,4800000,85,95,"Bar",3 },
	[88] = { 5000000,4800000,85,95,"Bar",3 },
	[89] = { 5000000,4800000,85,95,"Bar",3 },
	[90] = { 5000000,4800000,85,95,"Bar",3 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.buyBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
		if business[1] ~= nil then
			TriggerClientEvent("Notify",source,"negado","<b>"..shoplist[shopid][5].."</b> já possui um proprietário.",8000)
		else
			if vRP.tryFullPayment(user_id,parseInt(shoplist[shopid][1])) then
				vRP.execute("nav/put_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid), capital = parseInt(shoplist[shopid][2]*0.1), launded = 0, timelap = parseInt(os.time()), owner = 1 })
				TriggerClientEvent("Notify",source,"sucesso","Compra da <b>"..shoplist[shopid][5].."</b> concluída.",8000)
			else
				TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sellBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			vRP.giveMoney(user_id,parseInt(shoplist[shopid][1]*0.7))
			vRP.execute("nav/del_business",{ shop_id = parseInt(shopid) })
			TriggerClientEvent("Notify",source,"sucesso","Venda da <b>"..shoplist[shopid][5].."</b> concluída.",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LAUNDBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.laundBusiness(shopid,launded)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local permBuss = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
			if parseInt(os.time()) >= parseInt(permBuss[1].timelap+24*3*60*60) then
				vRP.execute("nav/res_business",{ user_id = parseInt(permBuss[1].user_id), timelap = parseInt(os.time()), shop_id = parseInt(shopid) })
			end
			if parseInt(launded) > 0 and parseInt(launded) <= parseInt(permBuss[1].capital-permBuss[1].launded) then
				local random = math.random(parseInt(shoplist[shopid][3]),parseInt(shoplist[shopid][4]))
				if vRP.tryGetInventoryItem(user_id,"dinheirosujo",parseInt(launded)) then
					vRP.giveMoney(user_id,parseInt(launded*("0."..random)))
					vRP.execute("nav/add_launded",{ user_id = parseInt(permBuss[1].user_id), launded = parseInt(launded), shop_id = parseInt(shopid) })
					TriggerClientEvent("Notify",source,"sucesso","Lavagem de <b>$"..vRP.format(parseInt(launded)).." dólares</b> concluído e recebido <b>$"..vRP.format(parseInt(launded*("0."..random))).." dólares</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro sujo insuficiente.",8000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Capital insuficiente.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.investBusiness(shopid,invest)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil and parseInt(invest) >= 2 then
			local permBuss = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
			if parseInt(permBuss[1].capital+(invest*0.85)) <= parseInt(shoplist[shopid][2]) then
				if vRP.tryGetInventoryItem(user_id,"dinheirosujo",parseInt(invest)) then
					vRP.execute("nav/add_invest",{ user_id = parseInt(permBuss[1].user_id), capital = parseInt(invest*0.85), shop_id = parseInt(shopid) })
					TriggerClientEvent("Notify",source,"sucesso","Investimento de <b>$"..vRP.format(parseInt(invest*0.85)).."</b> concluído.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro sujo insuficiente.",8000)
				end
			else
				TriggerClientEvent("Notify",source,"importante","A empresa atingiu o limite de <b>$"..vRP.format(parseInt(shoplist[shopid][2])).." dólares</b> em seus investimentos.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/use_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local allPerms = vRP.query("nav/get_allbusiness",{ shop_id = parseInt(shopid) })
			local permissoes = ""
			for k,v in pairs(allPerms) do
				local identity = vRP.getUserIdentity(v.user_id)
				if identity then
					permissoes = permissoes.."<b>Nome:</b> "..identity.name.." "..identity.firstname.."   -   <b>Passaporte:</b> "..v.user_id
					if k ~= #allPerms then
						permissoes = permissoes.."<br>"
					end
				end
			end

			local bussInfo = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })

			if parseInt(os.time()-bussInfo[1].timelap) <= 259200 then
				TriggerClientEvent("Notify",source,"importante","<b>Capital Geral:</b> $"..vRP.format(parseInt(bussInfo[1].capital)).."<br><b>Capital Purificado:</b> $"..vRP.format(parseInt(bussInfo[1].launded)).."<br><b>Investimento Máximo:</b> $"..vRP.format(shoplist[shopid][2]).."<br>Reinicialização em "..vRP.getDayHours(parseInt(259200-(os.time()-bussInfo[1].timelap))).."<br><br>"..permissoes,30000)
			else
				TriggerClientEvent("Notify",source,"importante","<b>Capital Geral:</b> $"..vRP.format(parseInt(bussInfo[1].capital)).."<br><b>Capital Purificado:</b> "..vRP.format(parseInt(bussInfo[1].launded)).."<br><b>Investimento Máximo:</b> $"..vRP.format(shoplist[shopid][2]).."<br><br>"..permissoes,30000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFOBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.infoBusiness(shopid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/get_business",{ shop_id = parseInt(shopid), owner = 1 })
		if business[1] and business[1] ~= nil then
			local identity = vRP.getUserIdentity(parseInt(business[1].user_id))
			if identity then
				TriggerClientEvent("Notify",source,"importante","<b>Proprietário:</b> "..identity.name.." "..identity.firstname,8000)
			end
		else
			TriggerClientEvent("Notify",source,"negado","<b>Valor:</b> $"..vRP.format(parseInt(shoplist[shopid][1])),8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.addBusiness(shopid,nuserid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local countBuss = vRP.query("nav/count_business",{ shop_id = parseInt(shopid) })
			if parseInt(countBuss[1].qtd) >= parseInt(shoplist[shopid][6]) then
				TriggerClientEvent("Notify",source,"negado","<b>"..shoplist[shopid][5].."</b> atingiu o máximo de sócios.",10000)
				return
			else
				vRP.execute("nav/put_business",{ user_id = parseInt(nuserid), shop_id = parseInt(shopid), capital = 0, launded = 0, timelap = 0, owner = 0 })
				local identity = vRP.getUserIdentity(parseInt(nuserid))
				if identity then
					TriggerClientEvent("Notify",source,"sucesso","Sociedade adicionada para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.remBusiness(shopid,nuserid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local permList = vRP.query("nav/use_business",{ user_id = parseInt(nuserid), shop_id = parseInt(shopid) })
			if permList[1] then
				vRP.execute("nav/rem_permission",{ shop_id = parseInt(shopid), user_id = parseInt(nuserid) })
				local identity = vRP.getUserIdentity(parseInt(nuserid))
				if identity then
					TriggerClientEvent("Notify",source,"sucesso","Sociedade removida de <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSBUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.transBusiness(shopid,nuserid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(shopid) > 0 and not vRP.searchReturn(source,user_id) then
		local business = vRP.query("nav/check_business",{ user_id = parseInt(user_id), shop_id = parseInt(shopid) })
		if business[1] and business[1] ~= nil then
			local identity = vRP.getUserIdentity(parseInt(nuserid))
			if identity then
				local ok = vRP.request(source,"Transferir a <b>"..tostring(shoplist[shopid][5]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>?",30)
				if ok then
					vRP.execute("nav/del_business",{ shop_id = parseInt(shopid) })
					vRP.execute("nav/put_business",{ user_id = parseInt(nuserid), shop_id = parseInt(shopid), capital = parseInt(business[1].capital), launded = parseInt(business[1].launded), timelap = parseInt(business[1].timelap), owner = 1 })
					TriggerClientEvent("Notify",source,"importante","Transferiu a <b>"..tostring(shoplist[shopid][5]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
				end
			end
		end
	end
end