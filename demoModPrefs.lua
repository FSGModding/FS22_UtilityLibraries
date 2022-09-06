require '_cliSugar'
require '_testData'
require 'fs22ModPrefSaver'
require 'fs22Logger'

printWarning("Demo Script - Mod Preferences")
print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")

local myLoggerPrefs = FS22Log:new(
	"demoSample",
	FS22Log.DEBUG_MODE.VERBOSE
	--{"getValue"}
)

function saveFunction()
	print("save Function ran")
end

local myPrefs = FS22PrefSaver:new(
	"demoSample",
	"demoSample.xml",
	false,
	nil,
	nil,
	saveFunction,
	myLoggerPrefs
)


myPrefs:addDefaults({
	displayOrder  = "someOrder",
	displayMode   = { 1, "int" },
	displayMode5X = 2.5,
	displayMode5Y = 0.8,
	displayMe     = true
})
--myPrefs:dumpDefaults()

print(myPrefs:getValue("displayOrder"))
print(myPrefs:getValue("badSetting"))
myPrefs:setValue("displayOrder", "howdy")
print(myPrefs:getValue("displayOrder"))

--myPrefs:saveSettings()
myPrefs:loadSettings()
print(myPrefs:getValue("displayMode5X"))
-- myPrefs:dumpSettings()

