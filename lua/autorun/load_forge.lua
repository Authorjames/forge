forge = forge or {}
forge.version = "1.0"

local color_debug_text=Color(255,255,255)
local color_debug_client=Color(245,184,0)
local color_debug_server=Color(0,200,255)

function forge.debugprint(...)

	local s="";
	for k,v in ipairs{...}do
		local part;

		if type(v) == "table" then
			part=util.TableToJSON(v)
		elseif type(v) == "Entity" and v:IsPlayer() and IsValid(v) then
			part=v:Nick()
		else
			part=tostring(v)
		end

		s=s.." "..part
	end
	s=s.."\n";

	MsgC(SERVER and color_debug_server or color_debug_client,"[forge "..forge.version.."]")
	MsgC(color_debug_text,s)

	return 0
end

local color_error=Color(240,30,0)
local color_error_text=Color(190,190,190)
function forge.Error(error,...)
	local s="";
	for k,v in ipairs{...}do
		local part;

		if type(v) == "table" then
			part=util.TableToJSON(v)
		elseif type(v) == "Entity" and v:IsPlayer() and IsValid(v) then
			part=v:Nick()
		else
			part=tostring(v)
		end

		s=s.." "..part
	end
	s=s.."\n";

	MsgC(color_error,"[forge "..forge.version.."] ERROR: ")
	MsgC(color_debug_text,error);
	MsgC(color_error_text," "..s);

	hook.Call("forgeError",GAMEMODE,error,s)

	return -1
end

forge.debugprint("Initializing forge @ version "..forge.version)

local path = "forge"
function forge.includefile(name, folder, runtype)

	if not runtype then
		runtype = string.Left(name, 2)
	end

	if not runtype or ( runtype ~= "sv" and runtype ~= "sh" and runtype ~= "cl" ) then forge.Error("include_NO_PREFIX","Could not include file, no prefix!") return false end

	path = ""

	if folder then
		path = path .. folder .. "/"
	end

	path = path .. name

	if SERVER then
		if runtype == "sv" then
			forge.debugprint("> Loading... "..path)
			include(path)
		elseif runtype == "sh" then
			forge.debugprint("> Loading... "..path)
			include(path)
			AddCSLuaFile(path)
		elseif runtype == "cl" then
			AddCSLuaFile(path)
		end
	elseif CLIENT then
		if (runtype == "sh" or runtype == "cl") then
			forge.debugprint("> Loading... "..path)
			include(path)
		end
	end

	return true
end


function forge.includefolder(folder,runtype)
	forge.debugprint("Initializing "..folder)

	local exp=(string.Explode("/",folder,false))[1]

	for k, v in pairs(file.Find(folder.."/*.lua","LUA")) do
		forge.includefile(v, folder, runtype)
	end
end

//
// Include
//

forge.includefolder("forge")
forge.includefolder("forge/methods", "cl")