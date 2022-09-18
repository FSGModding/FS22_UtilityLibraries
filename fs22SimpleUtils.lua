-- FS22 Simple Utilities
--
-- Included:
--
-- JTSUtil.hslToRgb(h, s, l, a)
--  Convert a HSL color to sRGBa
--
--  Paramaters
--   h : hue [0-1]
--   s : saturation [0-1]
--   l : luminosity [0-1]
--   a : alpha [0-1]
--  Return
--   { r, g, b, ,a}
--  Expects h,s,l,a to be in the range of [0-1]
--  Returns a table {r,g,b,a}
--
--
-- JTSUtil.colorPercent(percent, reverse, fractional)
--  Return a color based on percentage (green->red) (or the colorblind equivelent)
--
--  Paramaters
--   percent : percent to get color for [0-1] OR [0-100]
--   reverse : false = 100% == green, true = 100% == red
--   fractional : true = percent is [0-1], false = percent is [0-100]
--
--  Return
--   { r, g, b, a }
--
--
-- JTSUtil.calcPercent(level, capacity, text)
--  Safely calculate a percentage
--
--  Paramaters
--   level : amount
--   capacity: total
--   text: true = append a "%" sign to the output
--
--  Return
--   [0-100] (number) OR [0%-100%] (string)
--
--
-- JTSUtil.qConcatS(...)
--  Safely concatenate all parameters with a space between each.
--  Automatically converts all parameters to strings.
--
--
-- JTSUtil.qConcat(...)
--  Safely concatenate all parameters.
--  Automatically converts all parameters to strings.
--
--
-- JTSUtil.sortTableByKey(inputTable, key)
--  Sort a table by a key name, where the table is of the style
--   {
--     { key1 = "value1", key2 = "sortMeCCC"},
--     { key1 = "value2", key2 = "sortMeBBB"},
--     { key1 = "value3", key2 = "sortMeFFF"},
--     { key1 = "value4", key2 = "sortMeAAA"},
--   }
--  In this case, sorting by "key2" would order the table "sortMeAAA", "sortMeBBB", etc.
--
--
-- JTSUtil.stackNewRow(inputTable)
-- JTSUtil.stackAddToNewRow(inputTable, entry)
-- JTSUtil.stackAddToRow(inputTable, entry)
-- JTSUtil.dispStackAdd(inputTable, text, color, newRow)
-- JTSUtil.dispGetLine(inputTable, index, reverse)
--  Very simple implementation of a table stack, used in several of my mods.
--  Look at the code for more info.
--
--
-- JTSUtil.stringSplit(str, sep)
--   Splits string "str" by seperator "sep"
--
--
-- (c)JTSage Modding & FSG Modding.  You may reuse or alter this code to your needs as nessesary with
-- no prior permission.  No warrenty implied or otherwise.


JTSUtil = {}

function  JTSUtil.hslToRgb(h, s, l, a)
	local r, g, b

	if s == 0 then
		r, g, b = l, l, l -- achromatic
	else
		local function hue2rgb(p, q, t)
			if t < 0   then t = t + 1 end
			if t > 1   then t = t - 1 end
			if t < 1/6 then return p + (q - p) * 6 * t end
			if t < 1/2 then return q end
			if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
			return p
		end

		local q
		if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
		local p = 2 * l - q

		r = hue2rgb(p, q, h + 1/3)
		g = hue2rgb(p, q, h)
		b = hue2rgb(p, q, h - 1/3)
	end
	return { r, g, b, a }
end

function JTSUtil.colorPercent(percent, reverse, fractional)
	if not fractional then
		percent = percent / 100
	end

	if reverse then
		percent = 1 - percent
	end

	if not g_gameSettings:getValue('useColorblindMode') then
		return JTSUtil.hslToRgb(
			(math.min(percent / 0.9, 1) * 120) / 360,
			1,
			0.5,
			1
		)
	else
		return JTSUtil.hslToRgb(
			(360 - (math.min(percent / 0.9, 1) * 120)) / 360,
			1,
			0.5,
			1
		)
	end
end

function JTSUtil.calcPercent(level, capacity, text)
	local percent = 0

	if capacity ~= nil and capacity > 0 and level ~= nil then
		percent = math.floor(level / capacity * 100)

		if percent > 99 and level < capacity then
			percent = 99
		elseif percent < 1 and level > 0 then
			percent = 1
		end
	end

	if text then
		return tostring(percent) .. "%"
	end
	return percent
end


function JTSUtil.qConcatS(...)
	return JTSUtil.qConcatFull(true, unpack({...}))
end

function JTSUtil.qConcat(...)
	return JTSUtil.qConcatFull(false, unpack({...}))
end

function JTSUtil.qConcatFull(space, ...)
	local retty = ""
	for i = 1, select("#", ...) do
		if i > 1 and space then retty = retty .. " " end
		retty = retty .. tostring(select(i, ...))
	end
	return retty
end

function JTSUtil.sortTableByKey(inputTable, key)
	local function sorter(a,b) return a[key] < b[key] end
	table.sort(inputTable, sorter)
end

function JTSUtil.stackNewRow(inputTable)
	table.insert(inputTable, {})
end

function JTSUtil.stackAddToNewRow(inputTable, entry)
	table.insert(inputTable, {})
	table.insert(inputTable[#inputTable], entry)
end

function JTSUtil.stackAddToRow(inputTable, entry)
	table.insert(inputTable[#inputTable], entry)
end

function JTSUtil.dispStackAdd(inputTable, text, color, newRow)
	if newRow then
		JTSUtil.stackAddToNewRow(inputTable, { text = tostring(text), color = color})
	else
		JTSUtil.stackAddToRow(inputTable, {text = tostring(text), color = color})
	end
end

function JTSUtil.dispGetLine(inputTable, index, reverse)
	if not reverse then
		return inputTable[index]
	end

	local rev_table = {}
	for i=#inputTable[index], 1, -1 do
		rev_table[#rev_table+1] = inputTable[index][i]
	end
	return rev_table
end

function JTSUtil.stringSplit(str, sep)
	if sep == nil then
		sep = '%s'
	end

	local res = {}
	local func = function(w)
		table.insert(res, w)
	end

	_ = string.gsub(str, '[^'..sep..']+', func)
	return res
end
