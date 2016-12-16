forge.author = "Author."
forge.apikey = "0EC4B5A177958EBFBB0A760F37051DFA"

forge.grouplist = forge.grouplist or {}
forge.whitelist = {
	groups = {
		"kraglestudios",
	},	
}

function forge.buildgroups()
	for k, id in pairs(forge.whitelist.groups) do
		http.Fetch("http://steamcommunity.com/groups/".. id .."/memberslistxml?xml=1", function(body)
			local s = "<steamID64>(.-)</steamID64>"
			local members = {}
			for match in body:gmatch(s) do
				table.insert(members, match)
			end

			forge.grouplist[id] = members
		end)
	end
end

hook.Add("CheckPassword", "core", function(steamid64, ip, password, guess, name)
	local steamid = util.SteamIDFrom64(steamid64)
	print("CheckPassword")

	for k, v in pairs(forge.whitelist.groups) do
		for _k, _v in pairs(forge.grouplist[v] or {}) do
			print(v, _v) 
		end
	end
end)

local httpready = false
local function checkhtml()
    http.Post("https://google.com", {}, function()
        hook.Call("HTTPLoaded",GAMEMODE)
        httpready = true
    end, function()
        hook.Call("HTTPLoaded",GAMEMODE)
        httpready = true
    end)
    if httpready then return true else return false end
end 

hook.Add("HTTPLoaded","Fix This HTTP BULL SHIT", function()
	forge.buildgroups()

    hook.Remove("HTTPLoaded","Fix This HTTP BULL SHIT")
end)

hook.Add("InitPostEntity", "CreateAFuckingBot",function()
    print("Adding a bot to kick things off")
    game.ConsoleCommand("bot\n")
    hook.Remove("CreateAFuckingBot")
end)
local LastThink = CurTime()
hook.Add("Think", "CanWeHTTP", function() 
    if CurTime() >=  LastThink + 2 then
        if checkhtml() then 
            hook.Remove("Think","CanWeHTTP") 
        end 
    end
end)