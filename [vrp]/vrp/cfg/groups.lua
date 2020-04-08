local cfg = {}

cfg.groups = {
	["admin"] = {
		"admin.permissao",
		"polpar.permissao",
		"moderador.permissao",
		"moderador2.permissao",
		"dv.permissao"
	},
	["moderador"] = {
		"moderador.permissao",
		"polpar.permissao",
		"dv.permissao"
	},
	["moderador2"] = {
		"moderador2.permissao"
	},
	["concessionaria"] = {
		_config = {
			title = "Concessionaria",
			gtype = "job"
		},
		"conce.permissao",
		"dv.permissao"
	},
	["Policia"] = {
		_config = {
			title = "Policia",
			gtype = "job"
		},
		"policia.permissao",
		"polpar.permissao",
		"dv.permissao"
	},
	["Paramedico"] = {
		_config = {
			title = "Paramedico",
			gtype = "job"
		},
		"paramedico.permissao",
		"polpar.permissao"
	},
	["PaisanaPolicia"] = {
		_config = {
			title = "Policial",
			gtype = "job"
		},
		"paisanapolicia.permissao"
	},
	["PaisanaParamedico"] = {
		_config = {
			title = "Paramedico",
			gtype = "job"
		},
		"paisanaparamedico.permissao"
	},
	["Mecanico"] = {
		_config = {
			title = "Mecanico",
			gtype = "job"
		},
		"mecanico.permissao",
		"dv.permissao"
	},
	["PaisanaMecanico"] = {
		_config = {
			title = "Mecanico",
			gtype = "job"
		},
		"paisanamecanico.permissao"
	},
	["Taxista"] = {
		_config = {
			title = "Taxista",
			-- gtype = "job"
		},
		"taxista.permissao"
	},
	["Ilegal"] = {
		_config = {
			title = "Ilegal",
			-- gtype = "job"
		},
		"ilegal.permissao"
	},
	["PaisanaTaxista"] = {
		_config = {
			title = "Taxista",
			-- gtype = "job"
		},
		"paisanataxista.permissao"
	},
	["Advogado"] = {
		_config = {
			title = "Advogado",
			gtype = "job"
		},
		"advogado.permissao"
	},
	["Crips"] = {
		_config = {
			title = "Crips",
			gtype = "job"
		},
		"crips.permissao"
	},
	["Liberty"] = {
		_config = {
			title = "Liberty",
			gtype = "job"
		},
		"liberty.permissao",
		"dv.permissao"
	},
	["Bennys"] = {
		_config = {
			title = "Bennys",
			gtype = "job"
		},
		"bennys.permissao",
		"dv.permissao"
	},
	["Bronze"] = {
		_config = {
			title = "Bronze",
			gtype = "vip"
		},
		"bronze.permissao"
	},
	["Prata"] = {
		_config = {
			title = "Prata",
			gtype = "vip"
		},
		"prata.permissao"
	},
	["Ouro"] = {
		_config = {
			title = "Ouro",
			gtype = "vip"
		},
		"ouro.permissao",
		"mochila.permissao"
	},
	["Platina"] = {
		_config = {
			title = "Platina",
			gtype = "vip"
		},
		"platina.permissao",
		"mochila.permissao"
	},
	["Booster"] = {
		_config = {
			title = "Booster",
			gtype = "vip"
		},
		"booster.permissao",
		"mochila.permissao"
	},
	["Mochila"] = {
		_config = {
			title = "Mochila",
			gtype = "vip"
		},
		"mochila.permissao"
	},
	["Caminhoneiro"] = {
		_config = {
			title = "Caminhoneiro",
		},
		"caminhoneiro.permissao",
		"entrada.permissao"
	},
	["Juridico"] = {
		_config = {
			title = "Juridico",
			gtype = "job"
		},
		"juridico.permissao",
		"entrada.permissao"
	},
	["Juiz"] = {
		_config = {

			title = "Juiz",
			gtype = "job"
		},
		"juiz.permissao",
		"entrada.permissao"
	},
    ["Psicologia"] = {
		_config = {
			title = "Psicologia",
			gtype = "job"
		},
		"psicologia.permissao",
		"entrada.permissao"
	},
	["Vanilla"] = {
		_config = {
			title = "Vanilla",
			gtype = "job"
		},
		"vanilla.permissao",
		"entrada.permissao"
	},
	["Portepistol"] = {
		_config = {
			title = "Portepistol",
		},
		"portepistol.permissao",
		"entrada.permissao"
	},
	["Motoclub"] = {
		_config = {
			title = "Motoclub",
			gtype = "job"
		},
		"motoclub.permissao",
		"entrada.permissao"
	},
	["Motoclub2"] = {
		_config = {
			title = "Motoclub2",
			gtype = "job"
		},
		"motoclub2.permissao",
		"entrada.permissao"
	},
	["Bahamas"] = {
		_config = {
			title = "Bahamas",
			gtype = "job"
		},
		"bahamas.permissao",
		"entrada.permissao"
	},
	["Mafia"] = {
		_config = {
			title = "Mafia",
			gtype = "job"
		},
		"mafia.permissao",
		"entrada.permissao"
	},
	["Ballas"] = {
		_config = {
			title = "Ballas",
			gtype = "job"
		},
		"ballas.permissao",
		"entrada.permissao"
	},
	["Groove"] = {
		_config = {
			title = "Groove",
			gtype = "job"
		},
		"groove.permissao",
		"entrada.permissao"
	},
	["Vagos"] = {
		_config = {
			title = "Vagos",
			gtype = "job"
		},
		"vagos.permissao",
		"entrada.permissao"
	},
	["Mafia2"] = {
		_config = {
			title = "Mafia2",
			gtype = "job"
		},
		"mafia2.permissao",
		"entrada.permissao"
	},
	["Bloods"] = {
		_config = {
			title = "Bloods",
			gtype = "job"
		},
		"bloods.permissao",
		"entrada.permissao"
	},
	["Weazelnews"] = {
		_config = {
			title = "Weazelnews",
			gtype = "job"
		},
		"weazelnews.permissao",
		"entrada.permissao"
	},
}

cfg.users = {
	[1] = { "admin" },
	[2] = { "admin" }
}

cfg.selectors = {}

return cfg