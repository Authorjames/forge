forge.menu = {}
forge.menu.jobs = include("methods/jobs.lua")

function forge.menu.open()
	local frame = semantic.add("frame", {
		w = scalew(80),
		h = scale(75),
		center = true,
		title = "Forge",
		footer = "Version 1.0.1 by Author.",
	})

	local sidebar = frame:addto("sidebar", {
		dock = LEFT,
		w = frame:GetWide(),

		items = {
			forge.menu.jobs,
		},
	})
end

concommand.Add("forge", function()
	forge.menu.open()
end)