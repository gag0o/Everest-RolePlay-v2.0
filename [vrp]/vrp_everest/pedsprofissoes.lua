local pedlist = {
	{ ['x'] = 2432.78, ['y'] = 4802.78, ['z'] = 34.82, ['h'] = 128.22, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 2440.98, ['y'] = 4794.38, ['z'] = 34.66, ['h'] = 128.22, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 2449.0, ['y'] = 4786.67, ['z'] = 34.65, ['h'] = 128.22, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 2457.28, ['y'] = 4778.75, ['z'] = 34.52, ['h'] = 128.22, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 2464.67, ['y'] = 4770.23, ['z'] = 34.38, ['h'] = 128.22, ['hash'] = 0xFCFA9E1E, ['hash2'] = "A_C_Cow" },
	{ ['x'] = 1151.77, ['y'] = -3248.77, ['z'] = 5.90, ['h'] = 181.03, ['hash'] = 0x6C9B2849, ['hash2'] = "a_m_m_hillbilly_01" },
	{ ['x'] = 1152.27, ['y'] = -3248.77, ['z'] = 5.90, ['h'] = 181.03, ['hash'] = 0x349F33E1, ['hash2'] = "a_c_retriever" },
	{ ['x'] = 1151.26, ['y'] = -3248.77, ['z'] = 5.90, ['h'] = 181.03, ['hash'] = 0x9563221D, ['hash2'] = "a_c_rottweiler" }
}

Citizen.CreateThread(function()
	for k,v in pairs(pedlist) do
		RequestModel(GetHashKey(v.hash2))
		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Citizen.Wait(10)
		end

		local ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
	end
end)