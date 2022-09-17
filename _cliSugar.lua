-- CLI sugar file
--
-- please don't use this - it defines some game functions in a poor way so that the demos
-- can run on the command line.  It's ugly.
--
function Class(members, baseClass)
	members = members or {}
	local __index = members
	local mt = {
		__metatable = members,
		__index = __index
	}

	if baseClass ~= nil then
		setmetatable(members, {
			__index = baseClass
		})
	end

	local function new(_, init)
		return setmetatable(init or {}, mt)
	end

	local function copy(obj, ...)
		local newobj = obj.new(unpack(arg))

		for n, v in pairs(obj) do
			newobj[n] = v
		end

		return newobj
	end

	function members:class()
		return members
	end

	function members:superClass()
		return baseClass
	end

	function members:isa(other)
		local curClass = members

		while curClass ~= nil do
			if curClass == other then
				return true
			else
				curClass = curClass:superClass()
			end
		end

		return false
	end

	members.new = members.new or new
	members.copy = members.copy or copy

	return mt
end
FSCareerMissionInfo = {
}

Utils = {
	getNoNil = function (value, setTo)
		if value == nil then
			return setTo
		end

		return value
	end,
	appendedFunction = function(old, new)
		return old
	end
}

function printError(text)
	local c27 = string.char(27)
	print(c27 .. '[1;31m' .. text .. c27 .. '[0m')
end

function printWarning(text)
	local c27 = string.char(27)
	print(c27 .. '[1;33m' .. text .. c27 .. '[0m')
end


function getUserProfileAppPath()
	return "./"
end
function fileExists(_)
	return true
end
function createXMLFile(_, name, _)
	return name
end
function saveXMLFile(_)
	return true
end
function loadXMLFile(_, name)
	return name
end
function setXML(type, file, key, value)
	print("SetXML:" .. type .. ":" ..  file .. "::" .. key .. "::" .. tostring(value))
end
function setXMLFloat(file, key, value)
	setXML("float", file, key, value)
end
function setXMLInt(file, key, value)
	setXML("int", file, key, value)
end
function setXMLString(file, key, value)
	setXML("string", file, key, value)
end
function setXMLBool(file, key, value)
	setXML("bool", file, key, value)
end
function getXML(type, file, key)
	print("GetXML:" .. type .. ":" ..  file .. "::" .. key)
	return nil
end
function getXMLInt(file, key)
	return getXML("int", file, key)
end
function getXMLFloat(file, key)
	return getXML("float", file, key)
end
function getXMLBool(file, key)
	return getXML("bool", file, key)
end
function getXMLString(file, key)
	return getXML("string", file, key)
end
function delete(_)
	return
end