RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,mensagem)
	SendNUIMessage({ css = css, mensagem = mensagem, time = 7000 })
end)
