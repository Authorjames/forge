forge.steam = {}
	--
	-- Credits to Freezebug
	-- for this tool
	--

    local apikey = forge.apikey
    local apiurl = "http://api.steampowered.com/"
    local jdec = util.JSONToTable // futile attempt to make things faster
    local jenc = util.TableToJSON // futile attempt to make things faster
    local function checkkey()
        assert(#apikey > 1,"No API key is defined. Set forge.apikey")
    end
    local function callbackCheck(code)
        assert(code~=401,"Authorization error (Is your key valid?)")
        assert(code~=500,"It seems the steam servers are having a hard time.") 
        assert(code~=404,"Not found.")
        assert(code~=400,"Bad module request.")
    end

        

    local function steamid_verify(id) 
        if string.find(id,"STEAM_") then 
            id = util.SteamIDTo64( tostring(id) ) 
        end
        assert(type(id)=="string" and id~=0,"An invalid steamid was passed. (Use Steam32 or Steam64)")
        return id
    end

    --[[---------------------------------------------------------
    Name: forge.steam.GetNewsForApp(appid,callback,[maxlen])
    Desc: Returns the news for a speicified app.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetNewsForApp(appid,callback,maxlen)
        checkkey()
        assert(type(appid)=="number", "argument #1 to GetNewsForApp, number expected; got " .. type(appid))
        assert(type(callback)=="function", "argument #2 to GetNewsForApp, function expected; got " .. type(callback))
        if !maxlen then maxlen = 300 end 
        http.Fetch(apiurl .. "ISteamNews/GetNewsForApp/v0002/?appid=" .. appid .. "&format=json&maxlen=" .. maxlen,
           function( body, _, _, code )
                  callbackCheck(code)
                  callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
    --[[---------------------------------------------------------
    Name: forge.steam.GetPlayerSummaries(steamid,callback)
    Desc: Returns the specified steamid's profile.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetPlayerSummaries(steamid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetPlayerSummaries, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetPlayerSummaries, function expected; got " .. type(callback))
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "ISteamUser/GetPlayerSummaries/v0002/?key=" .. apikey .. "&steamids=" .. steamid .. "&format=json",
           function( body, _, _, code )
               callbackCheck(code)
               callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
    --[[---------------------------------------------------------
    Name: forge.steam.GetFriendList(steamid,callback,[bool use 32 bit steamid] = false) ==WARNING, the third argument if true is EXPENSIVE.==
    Desc: Returns the specified steamid's friends. 
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetFriendList(steamid,callback,u32steam)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetFriendList, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetFriendList, function expected; got " .. type(callback))
        if !u32steam then u32steam = false end
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "ISteamUser/GetFriendList/v0001/?key=" .. apikey .. "&steamid=" .. steamid .. "&format=json",
        function( body, _, _, code )
            if u32steam==false then 
                callbackCheck(code)
                callback(jdec(body))
            else
                local x = jdec(body)
               
                for I,om in pairs(x["friendslist"]["friends"]) do
                    x["friendslist"]["friends"][I]["steamid"] = util.SteamIDFrom64(x["friendslist"]["friends"][I]["steamid"])
                end
                print(x)
                callback(x)
            end
            
                    
            
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
    
    --[[---------------------------------------------------------
    Name: forge.steam.GetPlayerAchievements(steamid,appid,callback)
    Desc: Returns the specified steamid's achievements for the specified appid.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetPlayerAchievements(steamid,appid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetPlayerAchievements, string expected; got " .. type(steamid))
        assert(type(appid)=="number", "argument #2 to GetPlayerAchievements, number expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #3 to GetPlayerAchievements, function expected; got " .. type(callback))

        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "ISteamUserStats/GetPlayerAchievements/v0001/?key=" .. apikey .. "&steamid=" .. steamid .. "&appid=" .. appid .. "&format=json",
           function( body, _, _, code )
                callbackCheck(code)
                callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
    
    
    --[[---------------------------------------------------------
    Name: forge.steam.GetOwnedGames(steamid,callback)
    Desc: Returns the specified steamid's games.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetOwnedGames(steamid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetOwnedGames, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetOwnedGames, function expected; got " .. type(callback))
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "IPlayerService/GetOwnedGames/v0001/?key=" .. apikey .. "&steamid=" .. steamid .. "&format=json",
           function( body, _, _, code )
           
                  callbackCheck(code)
                  callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
    
    --[[---------------------------------------------------------
    Name: forge.steam.GetUserGroupList(steamid,callback)
    Desc: Returns the specified steamid's groups.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetUserGroupList(steamid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetUserGroupList, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetUserGroupList, function expected; got " .. type(callback))
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "ISteamUser/GetUserGroupList/v1/?key=" .. apikey .. "&steamid=" .. steamid .. "&format=json",
           function( body, _, _, code )
                  callbackCheck(code)
                  callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end
    
    --[[---------------------------------------------------------
    Name: forge.steam.GetPlayerBans(steamid,callback)
    Desc: Returns any bans or restrictions the specified account may or may not have.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetPlayerBans(steamid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetPlayerBans, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetPlayerBans, function expected; got " .. type(callback))
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "ISteamUser/GetPlayerBans/v1/?key=" .. apikey .. "&steamids=" .. steamid .. "&format=json",
           function( body, _, _, code )
                callbackCheck(code)
                callback(jdec(body))
            end,
           function( error )
                  assert(false,error);
           end
        );
    end
    --[[---------------------------------------------------------
    Name: forge.steam.GetSteamLevel(steamid,callback)
    Desc: Returns How many HL3 conspiracy theories begun during the time it took to execute the API call. 
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetSteamLevel(steamid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetSteamLevel, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetSteamLevel, function expected; got " .. type(callback))
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "IPlayerService/GetSteamLevel/v1/?key=" .. apikey .. "&steamid=" .. steamid .. "&format=json",
           function( body, _, _, code )
                callbackCheck(code)
                callback(jdec(body))
            end,
           function( error )
                  assert(false,error);
           end
        );
    end
    
    
    --[[---------------------------------------------------------
    Name: forge.steam.GetBadges(steamid,callback)
    Desc: Returns a players badges.
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.GetBadges(steamid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to GetBadges, string expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #2 to GetBadges, function expected; got " .. type(callback))
        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "IPlayerService/GetBadges/v1/?key=" .. apikey .. "&steamid=" .. steamid .. "&format=json",
           function( body, _, _, code )
                callbackCheck(code)
                callback(jdec(body))
            end,
           function( error )
                  assert(false,error);
           end
        );
    end
    --[[---------------------------------------------------------
    Name: forge.steam.GetBadges(steamid,callback)
    Desc: Returns only the steamid of the player of which is lending the specified game appid ( Returns 0 if not sharing. )
    Callback: function(table)
    -----------------------------------------------------------]]
    function forge.steam.IsPlayingSharedGame(steamid,appid,callback)
        checkkey()
        assert(type(steamid)=="string", "argument #1 to IsPlayingSharedGame, string expected; got " .. type(steamid))
        assert(type(appid)=="number", "argument #2 to IsPlayingSharedGame, number expected; got " .. type(steamid))
        assert(type(callback)=="function", "argument #3 to IsPlayingSharedGame function expected; got " .. type(callback))

        steamid = steamid_verify(steamid)
        http.Fetch(apiurl .. "IPlayerService/IsPlayingSharedGame/v0001/?key=" .. apikey .. "&steamid=" .. steamid .. "&appid=" .. appid .. "&format=json",
           function( body, _, _, code )
                callbackCheck(code)
                callback(jdec(body))
           end,
           function( error )
                  assert(false,error);
           end
        );
    end