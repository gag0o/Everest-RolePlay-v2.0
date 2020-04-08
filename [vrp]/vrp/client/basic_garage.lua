function tvRP.getNearestVehicles(radius)
	local r = {}
	local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)

	for _,veh in pairs(vehs) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = Vdist(x,y,z,px,py,pz)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end

function tvRP.getNearestVehicle(radius)
	local veh
	local vehs = tvRP.getNearestVehicles(radius)
	local min = radius+0.0001
	for _veh,dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh 
end

function tvRP.ejectVehicle()
	local ped = PlayerPedId()
	if IsPedSittingInAnyVehicle(ped) then
		TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
	end
end

function tvRP.isInVehicle()
	return IsPedSittingInAnyVehicle(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local vehList = {
	{ "blista",-344943009,false },
	{ "brioso",1549126457,false },
	{ "dilettante",-1130810103,false },
	{ "issi2",-1177863319,false },
	{ "panto",-431692672,false },
	{ "prairie",-1450650718,false },
	{ "rhapsody",841808271,false },
	{ "cogcabrio",330661258,false },
	{ "exemplar",-5153954,false },
	{ "f620",-591610296,false },
	{ "felon",-391594584,false },
	{ "ingot",-1289722222,false },
	{ "police3",19112215274,false },
	{ "felon2",-89291282,false },
	{ "jackal",-624529134,false },
	{ "oracle",1348744438,false },
	{ "oracle2",-511601230,false },
	{ "sentinel",1349725314,false },
	{ "sentinel2",873639469,false },
	{ "windsor",1581459400,false },
	{ "windsor2",-1930048799,false },
	{ "zion",-1122289213,false },
	{ "zion2",-1193103848,false },
	{ "blade",-1205801634,false },
	{ "policeb",-34623805,false },
	{ "buccaneer",-682211828,false },
	{ "buccaneer2",-1013450936,false },
	{ "primo",-1150599089,false },
	{ "primo2",-2040426790,false },
	{ "chino",349605904,false },
	{ "chino2",-1361687965,false },
	{ "coquette3",784565758,false },
	{ "dominator",80636076,false },
	{ "dukes",723973206,false },
	{ "faction",-2119578145,false },
	{ "faction2",-1790546981,false },
	{ "faction3",-2039755226,false },
	{ "gauntlet",-1800170043,false },
	{ "hermes",15219735,false },
	{ "hotknife",37348240,false },
	{ "moonbeam",525509695,false },
	{ "moonbeam2",1896491931,false },
	{ "nightshade",-1943285540,false },
	{ "picador",1507916787,false },
	{ "ratloader2",-589178377,false },
	{ "ruiner",-227741703,false },
	{ "sabregt",-1685021548,false },
	{ "sabregt2",223258115,false },
	{ "slamvan",729783779,false },
	{ "slamvan2",833469436,false },
	{ "slamvan3",1119641113,false },
	{ "stalion",1923400478,false },
	{ "tampa",972671128,false },
	{ "vigero",-825837129,false },
	{ "virgo",-498054846,false },
	{ "virgo2",-899509638,false },
	{ "virgo3",16646064,false },
	{ "voodoo",2006667053,false },
	{ "yosemite",1871995513,false },
	{ "bfinjection",1126868326,false },
	{ "bifta",-349601129,false },
	{ "brickade",-305727417,false },
	{ "bodhi2",-1435919434,false },
	{ "foxharley1",554599358,false },
	{ "brawler",-1479664699,false },
	{ "trophytruck",101905590,false },
	{ "dubsta3",-1237253773,false },
	{ "mesa3",-2064372143,false },
	{ "rancherxl",1645267888,false },
	{ "rebel",-1207771834,false },
	{ "rebel2",-2045594037,false },
	{ "riata",-1532697517,false },
	{ "dloader",1770332643,false },
	{ "sandking",-1189015600,false },
	{ "sandking2",989381445,false },
	{ "raptor2017",624514487,false },
	{ "porsche992",859592619,false },
	{ "porschemacan",-1134424733,false },
	{ "baller",-808831384,false },
	{ "baller2",142944341,false },
	{ "baller3",1878062887,false },
	{ "baller4",634118882,false },
	{ "baller5",470404958,false },
	{ "baller6",666166960,false },
	{ "bjxl",850565707,false },
	{ "cavalcade",2006918058,false },
	{ "cavalcade2",-789894171,false },
	{ "contender",683047626,false },
	{ "dubsta",1177543287,false },
	{ "dubsta2",-394074634,false },
	{ "fq2",-1137532101,false },
	{ "granger",-1775728740,false },
	{ "gresley",-1543762099,false },
	{ "habanero",884422927,false },
	{ "seminole",1221512915,false },
	{ "serrano",1337041428,false },
	{ "xls",1203490606,false },
	{ "xls2",-432008408,false },
	{ "asea",-1809822327,false },
	{ "asterope",-1903012613,false },
	{ "cog55",906642318,false },
	{ "cog552",704435172,false },
	{ "cognoscenti",-2030171296,false },
	{ "cognoscenti2",-604842630,false },
	{ "stanier",-1477580979,false },
	{ "stratum",1723137093,false },
	{ "superd",1123216662,false },
	{ "surge",-1894894188,false },
	{ "tailgater",-1008861746,false },
	{ "warrener",1373123368,false },
	{ "washington",1777363799,false },
	{ "alpha",767087018,false },
	{ "banshee",-1041692462,false },
	{ "bestiagts",1274868363,false },
	{ "blista2",1039032026,false },
	{ "blista3",-591651781,false },
	{ "buffalo",-304802106,false },
	{ "buffalo2",736902334,false },
	{ "carbonizzare",2072687711,false },
	{ "comet2",-1045541610,false },
	{ "comet3",-2022483795,false },
	{ "coquette",108773431,false },
	{ "elegy",196747873,false },
	{ "elegy2",-566387422,false },
	{ "feltzer2",-1995326987,false },
	{ "furoregt",-1089039904,false },
	{ "fusilade",499169875,false },
	{ "futo",2016857647,false },
	{ "jester",-1297672541,false },
	{ "khamelion",544021352,false },
	{ "kuruma",-1372848492,false },
	{ "massacro",-142942670,false },
	{ "ninef",1032823388 ,false},
	{ "ninef2",-1461482751,false },
	{ "omnis",-777172681,false },
	{ "pariah",867799010,false },
	{ "penumbra",-377465520,false },
	{ "raiden",-1529242755,false },
	{ "rapidgt",-1934452204,false },
	{ "rapidgt2",1737773231,false },
	{ "ruston",719660200,false },
	{ "schafter3",-1485523546,false },
	{ "schafter4",1489967196,false },
	{ "schwarzer",-746882698,false },
	{ "sentinel3",1104234922,false },
	{ "seven70",-1757836725,false },
	{ "specter",1886268224,false },
	{ "specter2",1074745671,false },
	{ "streiter",1741861769,false },
	{ "sultan",970598228,false },
	{ "surano",384071873,false },
	{ "tampa2",-1071380347,false },
	{ "tropos",1887331236,false },
	{ "verlierer2",1102544804,false },
	{ "btype",117401876,false },
	{ "btype2",-831834716,false },
	{ "btype3",-602287871,false },
	{ "casco",941800958,false },
	{ "cheetah",-1311154784,false },
	{ "coquette2",1011753235,false },
	{ "feltzer3",-1566741232,false },
	{ "gt500",-2079788230,false },
	{ "infernus2",-1405937764,false },
	{ "jb700",1051415893,false },
	{ "mamba",-1660945322,false },
	{ "manana",-2124201592,false },
	{ "monroe",-433375717,false },
	{ "peyote",1830407356,false },
	{ "pigalle",1078682497,false },
	{ "rapidgt3",2049897956,false },
	{ "retinue",1841130506,false },
	{ "stinger",1545842587,false },
	{ "stingergt",-2098947590,false },
	{ "torero",1504306544,false },
	{ "tornado",464687292,false },
	{ "tornado2",1531094468,false },
	{ "tornado5",-1797613329,false },
	{ "turismo2",-982130927,false },
	{ "viseris",-391595372,false },
	{ "ztype",758895617,false },
	{ "adder",-1216765807,false },
	{ "autarch",-313185164,false },
	{ "banshee2",633712403,false },
	{ "bullet",-1696146015,false },
	{ "cheetah2",223240013,false },
	{ "entityxf",-1291952903,false },
	{ "fmj",1426219628,false },
	{ "gp1",1234311532,false },
	{ "ratbike",1873600305,false },
	{ "rumpo3",1475773103,false },
	{ "infernus",418536135,false },
	{ "nero",1034187331,false },
	{ "nero2",1093792632,false },
	{ "osiris",1987142870,false },
	{ "penetrator",-1758137366,false },
	{ "pfister811",-1829802492,false },
	{ "reaper",234062309,false },
	{ "sc1",1352136073,false },
	{ "sultanrs",-295689028,false },
	{ "t20",1663218586,false },
	{ "tempesta",272929391,false },
	{ "turismor",408192225,false },
	{ "tyrus",2067820283,false },
	{ "vacca",338562499,false },
	{ "rc",-2049243343,false },
	{ "zx10r",-714386060,false },
	{ "foxsupra",16473409,false },
	{ "tonkat",-2009005332,false },
	{ "foxshelby",69730216,false },
	{ "foxevo",-14212258057,false },
	{ "bobber",-1830458836,false },
	{ "bobbes2",-1221749859,false },
	{ "911tbs",-716699448,false },
	{ "foxsian",182795887,false },
	{ "visione",-998177792,false },
	{ "voltic",-1622444098,false },
	{ "zentorno",-1403128555,false },
	{ "sadler",-599568815,false },
	{ "bison",-16948145,false },
	{ "bison2",2072156101,false },
	{ "bobcatxl",1069929536,false },
	{ "burrito",-1346687836,false },
	{ "burrito2",-907477130,false },
	{ "burrito3",-1743316013,false },
	{ "burrito4",893081117,false },
	{ "minivan",-310465116,false },
	{ "minivan2",-1126264336,false },
	{ "paradise",1488164764,false },
	{ "pony",-119658072,false },
	{ "pony2",943752001,false },
	{ "rumpo",1162065741,false },
	{ "rumpo2",-1776615689,false },
	{ "rumpo3",1475773103,false },
	{ "speedo",-810318068,false },
	{ "surfer",699456151,false },
	{ "youga",65402552,false },
	{ "youga2",1026149675,false },
	{ "huntley",486987393,false },
	{ "landstalker",1269098716,false },
	{ "mesa",914654722,false },
	{ "patriot",-808457413,false },
	{ "radi",-1651067813,false },
	{ "rocoto",2136773105,false },
	{ "tyrant",-376434238,false },
	{ "entity2",-2120700196,false },
	{ "cheburek",-988501280,false },
	{ "hotring",1115909093,false },
	{ "jester3",-214906006,false },
	{ "flashgt",-1259134696,false },
	{ "ellie",-1267543371,false },
	{ "michelli",1046206681,false },
	{ "fagaloa",1617472902,false },
	{ "dominator3",-986944621,false },
	{ "issi3",931280609,false },
	{ "taipan",-1134706562,false },
	{ "gb200",1909189272,false },
	{ "stretch",-1961627517,false },
	{ "guardian",-2107990196,false },
	{ "kamacho",-121446169,false },
	{ "neon",-1848994066,false },
	{ "cyclone",1392481335,false },
	{ "italigtb",-2048333973,false },
	{ "italigtb2",-482719877,false },
	{ "vagner",1939284556,false },
	{ "xa21",917809321,false },
	{ "tezeract",1031562256,false },
	{ "prototipo",2123327359,false },
	{ "patriot2",-420911112,false },
	{ "speedo4",219613597,false },
	{ "stafford",321186144,false },
	{ "swinger",500482303,false },
	{ "brutus",2139203625,false },
	{ "clique",-1566607184,false },
	{ "deveste",1591739866,false },
	{ "deviant",1279262537,false },
	{ "impaler",-2096690334,false },
	{ "imperator",444994115,false },
	{ "italigto",-331467772,false },
	{ "schlagen",-507495760,false },
	{ "toros",-1168952148,false },
	{ "tulip",1456744817,false },
	{ "vamos",-49115651,false },
	{ "akuma",1672195559,false },
	{ "avarus",-2115793025,false },
	{ "bagger",-2140431165,false },
	{ "bati",-114291515,false },
	{ "bf400",86520421,false },
	{ "carbonrs",11251904,false },
	{ "chimera",6774487,false },
	{ "cliffhanger",390201602,false },
	{ "daemon",2006142190,false },
	{ "daemon2",-1404136503,false },
	{ "defiler",822018448,false },
	{ "diablous",-239841468,false },
	{ "diablous2",1790834270,false },
	{ "double",-1670998136,false },
	{ "enduro",1753414259,false },
	{ "esskey",2035069708,false },
	{ "faggio",-1842748181,false },
	{ "faggio2",55628203,false },
	{ "faggio3",-1289178744,false },
	{ "fcr",627535535,false },
	{ "fcr2",-757735410,false },
	{ "gargoyle",741090084,false },
	{ "hakuchou",1265391242,false },
	{ "hakuchou2",-255678177,false },
	{ "hexer",301427732,false },
	{ "innovation",-159126838,false },
	{ "lectro",640818791,false },
	{ "manchez",-1523428744,false },
	{ "nemesis",-634879114,false },
	{ "nightblade",-1606187161,false },
	{ "pcj",-909201658,false },
	{ "ruffian",-893578776,false },
	{ "sanchez",788045382,false },
	{ "sanchez2",-1453280962,false },
	{ "sanctus",1491277511,false },
	{ "sovereign",743478836,false },
	{ "thrust",1836027715,false },
	{ "vader",-140902153,false },
	{ "vindicator",-1353081087,false },
	{ "vortex",-609625092,false },
	{ "wolfsbane",-618617997,false },
	{ "zombiea",-1009268949,false },
	{ "zombieb",-570033273,false },
	{ "blazer",-2128233223,true },
	{ "blazer4",-440768424,true },
	{ "deathbike",-27326686,false },
	{ "shotaro",-405626514,false },
	{ "chevtahoe",-785783570,true },
	{ "charger2014",-989214245,true },
	{ "crownvictoria",1799969023,true },
	{ "fordexplorer",-1022830589,true },
	{ "fordmustanggt",1106910537,true },
	{ "sovereign2",708830657,true },
	{ "powheli",-257959713,true },
	{ "ambulance",1171614426,true },
	{ "riot",-1205689942,true },
	{ "coach",-2072933068,true },
	{ "bus",-713569950,true },
	{ "flatbed",1353720154,true },
	{ "towtruck2",-442313018,true },
	{ "ratloader",-667151410,true },
	{ "rubble",-1705304628,true },
	{ "taxi",-956048545,true },
	{ "boxville2",-233098306,true },
	{ "trash",1917016601,true },
	{ "scorcher",-186537451,true },
	{ "tribike",1127861609,true },
	{ "tribike2",-1233807380,true },
	{ "tribike3",-400295096,true },
	{ "fixter",-836512833,true },
	{ "cruiser",448402357,true },
	{ "bmx",1131912276,true },
	{ "dinghy",1033245328,true },
	{ "jetmax",861409633,true },
	{ "marquis",-1043459709,true },
	{ "seashark3",-311022263,true },
	{ "speeder",231083307,true },
	{ "speeder2",437538602,true },
	{ "squalo",400514754,true },
	{ "suntrap",-282946103,true },
	{ "toro",1070967343,true },
	{ "toro2",908897389,true },
	{ "tropic",290013743,true },
	{ "tropic2",1448677353,true },
	{ "phantom",-2137348917,true },
	{ "packer",569305213,true },
	{ "supervolito",710198397,true },
	{ "supervolito2",-1671539132,true },
	{ "cuban800",-644710429,true },
	{ "mammatus",-1746576111,true },
	{ "vestra",1341619767,true },
	{ "velum2",1077420264,true },
	{ "buzzard2",745926877,true },
	{ "frogger",744705981,true },
	{ "maverick",-1660661558,true },
	{ "tanker2",1956216962,true },
	{ "armytanker",-1207431159,true },
	{ "tvtrailer",-1770643266,true },
	{ "trailerlogs",2016027501,true },
	{ "tr4",2091594960,true },
	{ "fbi2",-1647941228,true },
	{ "policiamustanggt",796154746,true },
	{ "policiaexplorer",-377693317,true },
	{ "policiacharger2018",1743739647,true },
	{ "policiasilverado",1884511084,true },
	{ "policiatahoe",1865641415,true },
	{ "policiataurus",112218935,true },
	{ "policiavictoria",1611501436,true },
	{ "policiabmwr1200",-1624991916,true },
	{ "policiaheli",-875050963,true },
	{ "paramedicoambu",-792745162,true },
	{ "paramedicocharger2014",108063727,true },
	{ "paramedicoheli",2020690903,true },
	{ "paramedicotahoe",2040793826,true },
	{ "pbus",-2007026063,true },
	{ "policiacapricesid",81717913,true },
	{ "policiaschaftersid",81717913,true },
	{ "newsvan",-74027062,true },
	{ "newsvan2",79613282,true },
	{ "newsheli2",-1426962726,true },
	{ "nissangtr",-60313827,false },
	{ "nissangtr2",520007028,false },
	{ "dodgechargersrt",1601422646,false },
	{ "ferrariitalia",-1173768715,false },
	{ "audirs6",1676738519,false },
	{ "hvrod",-1474280704,false },
	{ "bmwm3f80",-157095615,false },
	{ "bmwm4gts",-13524981,false },
	--{ "chevcorvette",1586284669,false },
	{ "fordmustang",-1573350092,false },
	{ "lamborghinihuracan",1114244595,false },
	{ "lancerevolutionx",1978088379,false },
	--{ "civictyper",2004548589,false },
	{ "mazdarx7",2034235290,false },
	{ "nissangtrnismo",670022011,false },
	{ "nissanskyliner34",-4816535,false },
	{ "nissan370z",-2015218779,false },
	{ "teslaprior",351980252,false },
	{ "toyotasupra",723779872,false },
	{ "veneno",-42051018,false },
	{ "bmwm3e36",-1749831384,false },
	{ "mercedesgt63",-418486680,false },
	{ "ferrarif12",-1151600959,false },
	{ "bmwi8",-1540353819,false },
	{ "silvias15",-1390169318,false },
	{ "mule",904750859,false },
	{ "mule3",-2052737935,false },
	{ "benson",2053223216,false },
	{ "pounder",2112052861,false },
	{ "regina",14495224,false },
	{ "paganihuayra",-1683569033,false },
	{ "C7",874739883,false },
	{ "SVR14",-1820486602,false },
	{ "2016RS7",-1071770374,false },
	{ "m6f13",1897898727,false },
	{ "trhawk",231217483,false },
	{ "BOSS429",-368114364,false },
	{ "FMGT",-372000475,false },
	{ "z4bmw",745393879,false },
	{ "x6m",-506359117,false },
	{ "rmodmi8",-851992109,false },
	{ "r8v10abt",1836728757,false },
	{ "W900",730959932,false },
	{ "lp770r",1803173660,false },
	{ "gt17",-2011325074,false },
	{ "panamera17turbo",194366558,false },
	{ "19ftype",1224601968,false },
	{ "z1000",1744543800,false },
	{ "bmws",2047166283,false },
	{ "zl12017",531756283,false }, 
	{ "16challenger",-216150906,false },
	{ "silveradopmrj",-1162586405,true },
	{ "lp700r",949614817,false },
	{ "s10pmrj",1047561449,true },
	{ "s10bope",-1723962664,true },
	{ "corollapm",-1931820059,true },
	{ "sw4pmerj",592469868,true },
	{ "sw4n",-1745044289,true },
	{ "sprintersamu",252412752,true },
	{ "s10",-110704625,false },
	{ "palio",-1621506835,false },
	{ "206",-854631421,false },
	{ "amarok",493030188,false },
	{ "fusca",1924372706,false },
	{ "chevette",-1456558572,false },
	{ "civic",-493679946,false },
	{ "corolla",-1702326766,false },
	{ "corsa",-1236192914,false },
	{ "cruze",-810451130,false },
	{ "crv",-155981310,false },
	{ "ftipo",-585039494,false },
	{ "ftoro",-252643265,false },
	{ "golfgti",-2019386221,false },
	{ "jetta",701696699,false },
	{ "ix35",713340065,false },
	{ "monza",-1707353429,false },
	{ "pop110",-234700505,false },
	{ "vwsava",131498600,false },
	{ "veln",1696740208,false },
	{ "way",-223763391,false },
	{ "punto",-361155694,false },
	{ "santafe",-404110988,false },
	{ "golfgti",-2019386221,false },
	{ "passat",-1773424714,false },
	{ "stilo",-1501293606,false },
	{ "tempra",-26702245,false },
	{ "vwstance",192820287,false },
	{ "fiesta",-2007010518,true },
	{ "blazerpmerj",1829633059,true },
	{ "xj",-14519558,false },
	{ "hornet",-1761239425,false },
	{ "stockade",1747439474,false },
	{ "raptor",-1761239425,false },
	{ "senna",-433961724,false },
	{ "p1",-189438188,false },
	{ "flatbed3",2037834373,false },
	{ "camper",1747439474,false },
	{ "senna",-433961724,false }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.vehList(radius)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if not IsPedInAnyVehicle(ped) then
		veh = tvRP.getNearestVehicle(radius)
	end
	if IsEntityAVehicle(veh) then
		local lock = GetVehicleDoorsLockedForPlayer(veh,PlayerId())
		local trunk = GetVehicleDoorAngleRatio(v,5)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for k,v in pairs(vehList) do
			if v[2] == GetEntityModel(veh) then
				if v[1] then
					local tuning = { GetNumVehicleMods(veh,13),GetNumVehicleMods(veh,12),GetNumVehicleMods(veh,15),GetNumVehicleMods(veh,11),GetNumVehicleMods(veh,16) }
					return veh,VehToNet(veh),GetVehicleNumberPlateText(veh),v[1],lock,v[3],trunk,GetDisplayNameFromVehicleModel(v[1]),GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z)),tuning,v[2]
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.vehDesmanche()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(veh) then
		for k,v in pairs(vehList) do
			if v[2] == GetEntityModel(veh) then
				return veh,v[1],v[2],GetVehicleNumberPlateText(veh)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getVehplate()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if IsPedInAnyVehicle(ped) then
		local veh = GetVehiclePedIsUsing(ped)
		if IsEntityAVehicle(veh) then
			if GetPedInVehicleSeat(veh,-1) == ped then
				return veh,GetVehicleNumberPlateText(veh),GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getSeatVehicle()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if IsPedInAnyVehicle(ped) then
		local veh = GetVehiclePedIsUsing(ped)
		if IsEntityAVehicle(veh) then
			if GetPedInVehicleSeat(veh,0) == ped then
				return 1,VehToNet(veh),GetVehicleNumberPlateText(veh),GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
			elseif GetPedInVehicleSeat(veh,1) == ped then
				return 2,VehToNet(veh),GetVehicleNumberPlateText(veh),GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
			elseif GetPedInVehicleSeat(veh,2) == ped then
				return 3,VehToNet(veh),GetVehicleNumberPlateText(veh),GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
			end
		end
	end
end
