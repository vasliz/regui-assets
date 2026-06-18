local cloneref = (function()
	local Native = cloneref
	if not Native then
		return function(Object)
			return Object
		end
	end

	local Cache = setmetatable({}, { __mode = "v" })

	return function(Object)
		if not Object then
			return nil
		end

		local Id = Object:GetDebugId()
		local Cached = Cache[Id]
		if Cached then
			return Cached
		end

		local Cloned = Native(Object)
		Cache[Id] = Cloned

		return Cloned
	end
end)()

local RawGetChildren = game.GetChildren
local RawGetDescendants = game.GetDescendants

local function ClonerefInstance(Object)
	if cloneref then
		local Good, Cloned = pcall(cloneref, Object)
		if Good then
			return Cloned
		end
	end

	return Object
end

local function WeakGetChildren(Object)
	local Good, Raw = pcall(RawGetChildren, Object)
	if not Good or type(Raw) ~= "table" then
		return setmetatable({}, { __mode = "v" })
	end

	setmetatable(Raw, { __mode = "v" })
	local Out = {}
	for Index = 1, #Raw do
		Out[Index] = ClonerefInstance(Raw[Index])
	end

	return Out
end

local function WeakGetDescendants(Object)
	local Good, Raw = pcall(RawGetDescendants, Object)
	if not Good or type(Raw) ~= "table" then
		return setmetatable({}, { __mode = "v" })
	end

	setmetatable(Raw, { __mode = "v" })
	local Out = {}
	for Index = 1, #Raw do
		Out[Index] = ClonerefInstance(Raw[Index])
	end

	return Out
end

return cloneref, WeakGetChildren, WeakGetDescendants
