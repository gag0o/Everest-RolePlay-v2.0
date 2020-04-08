local cfg = {}

cfg.text = {"\"",false}
cfg.name = {"\"[]{}+=?!_()#@%0123456789/\\|",false}
cfg.business_name = {"\"[]{}+=?!_#",false}
cfg.homename = { "abcdefghijklmnopqrstuvwxyz",true }

return cfg