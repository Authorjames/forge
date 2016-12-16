local meta = FindMetaTable("Player")

--Returns time in minutes
function meta:GetPlayTime(callback)
	forge.steam.GetOwnedGames(self:SteamID(), function(ret)
		for k, v in pairs(ret.response.games) do
			if v.appid == 4000 then
				callback(v.playtime_forever)
				return
			end
		end

		callback(nil)
	end)
end
--player.GetByID(1):GetPlayTime(function(ret) PrintTable(string.FormattedTime(ret)) end)

--[[ Returns:
CommunityBanned	=	false
DaysSinceLastBan	=	0
EconomyBan	=	none
NumberOfGameBans	=	0
NumberOfVACBans	=	0
SteamId	=	76561198076402038
VACBanned	=	false
]]--
function meta:GetBans(callback)
	forge.steam.GetPlayerBans(self:SteamID(), function(ret)
		callback(ret.players[1])
	end)
end
--player.GetByID(1):GetBans(function(ret) PrintTable(ret) end)

--[[ Returns:
avatar	=	https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/dd/dd8353bfc0df7be500c5fdcebf4e544fe155d2dc.jpg
avatarfull	=	https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/dd/dd8353bfc0df7be500c5fdcebf4e544fe155d2dc_full.jpg
avatarmedium	=	https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/dd/dd8353bfc0df7be500c5fdcebf4e544fe155d2dc_medium.jpg
commentpermission	=	1
communityvisibilitystate	=	3
gameextrainfo	=	Garry's Mod
gameid	=	4000
gameserverip	=	51.174.137.255:0
gameserversteamid	=	90105772754850822
lastlogoff	=	1481837272
loccountrycode	=	NO
personaname	=	Author.
personastate	=	1
personastateflags	=	0
primaryclanid	=	103582791455692306
profilestate	=	1
profileurl	=	http://steamcommunity.com/id/Authorjames/
steamid	=	76561198076402038
timecreated	=	1353569001
]]
function meta:GetPlayer(callback)
	forge.steam.GetPlayerSummaries(self:SteamID(), function(ret)
		callback(ret.response.players[1])
	end)
end

--player.GetByID(1):GetPlayer(function(r) PrintTable(r) end)

--[[ Returns table with example value:
76561198315319862 = {
	friend_since	=	1481639704,
	relationship	=	"friend",
}
]]
function meta:GetFriendsList(callback)
	forge.steam.GetFriendList(self:SteamID(), function(ret)
		local t = {}
		for k, v in pairs(ret.friendslist.friends) do
			t[v.steamid] = {friend_since = v.friend_since, relationship = v.relationship}
		end

		callback(t)
	end)
end
--player.GetByID(1):GetFriendsList(function(r) PrintTable(r) end)

function meta:IsSharing(callback)
	forge.steam.IsPlayingSharedGame(self:SteamID(), 4000, function(ret)
		local is = ret.response.lender_steamid
		if (is == "0") then
			callback(false)
		else
			callback(is)
		end
	end)
end
--player.GetByID(1):IsSharing(function(r) print(r) end)