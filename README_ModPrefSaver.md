# FS22Log LUA User Preference Saver for FS22

- [FS22Log LUA User Preference Saver for FS22](#fs22log-lua-user-preference-saver-for-fs22)
	- [Class Initialization](#class-initialization)
	- [Defaults Table](#defaults-table)
		- [Format 1](#format-1)
		- [Format 2](#format-2)
	- [Class Functions](#class-functions)
		- [Add Defaults](#add-defaults)
		- [Get Setting](#get-setting)
		- [Set Setting](#set-setting)
		- [Save Settings](#save-settings)
		- [Load Settings](#load-settings)
	- [Developer functions](#developer-functions)
		- [Print defaults](#print-defaults)
		- [Print settings](#print-settings)
		- [Get XML file name](#get-xml-file-name)
	- [Distribution & Licensing Terms](#distribution--licensing-terms)

## Class Initialization

```lua
yourSettings = FS22PrefSaver:new(modName, fileName, perSaveSlot, defaults, loadHookFunction, saveHookFunction, logClass)
```

- __modName__          : Name of your mod
- __fileName__         : Filename to save to (something.xml)
- __perSaveSlot__      : True to instance per savegame, false for global to installation
- __defaults__         : Table of default settings (see below)
- __loadHookFunction__ : A function to call post-load of settings
- __saveHookFunction__ : A function to call post-save of settings
- __logClass__         : A FS22Log logging class. If this is nil, this library will not log anything.

Note for the logClass, this library provides a *lot* of development debug logging. At a minimum you
may want to configure the logger to filter out `getValue` and `setValue`.  All logging from this library
is done at the FS22Log.LOG_LEVEL.VERBOSE or FS22Log.LOG_LEVEL.DEVEL level.

## Defaults Table

The defaults table takes options in two formats

### Format 1

```lua
local defaults = {
  optionName = "optionValue"
}
```

### Format 2

```lua
local defaults = {
  optionName = {"optionValue", "valueType"}
}
```

valueType is:

- __string__ : A string, typically auto-detected
- __bool__ : A boolean, typically auto-detected
- __float__ : A floating point number, all numbers are detected as floats
- __int__ : An integer, cannot be auto detected
- __color__ : A color table {r, g, b, a}, cannot be auto detected

You may mix and match between types.  Best practice is to only define the type when it cannot be
auto detected.  Note that you cannot used mixed types with the giants XML library
  (e.g. someOption = "string" or false)
"nil" Values will also cause failures.

## Class Functions

### Add Defaults

```lua
yourSettings:addDefaults(tableOfDefaults)
```

This adds the contents of `tableOfDefaults` to the list of default options.  In the case of a name
collision, the value of the option will be the newest one you assign.

### Get Setting

```lua
yourSettings:getValue(optionName)
```

Retrieve the value of `optionName`

### Set Setting

```lua
yourSettings:setValue(optionName, newValue)
```

Set the value of `optionName` to `newValue`

### Save Settings

```lua
yourSettings:saveSettings()
```

Save the settings to disk.  Note that this is not automatic, you must hook this function to the
game's save function. The save file will be created if it does not already exist.

### Load Settings

```lua
yourSettings:loadSettings()
```

Load the settings from disk.  This function will gracefully fail if they have not yet been saved.

## Developer functions

These functions may prove useful in debugging errors with the library or your mod.

### Print defaults

```lua
yourLogger:dumpDefaults()
```

Dumps the defaults to the log, using the logClass, __at FS22Log.LOG_LEVEL.DEVEL__

### Print settings

```lua
yourLogger:dumpSettings()
```

Dumps the settings to the log, using the logClass, __at FS22Log.LOG_LEVEL.DEVEL__

Note that UserPrefSaver sparsely populates the settings table the first time it is run, and returns
the default value until the setting is explicitly set, __or__ the settings are loaded from disk.

### Get XML file name

```lua
yourLogger:getXMLFileName()
```

Returns the full path and name of the XML file used for saving if you need to refer to it.

## Distribution & Licensing Terms

(c)JTSage Modding & FSG Modding.  You may reuse or alter this code to your needs as necessary with no prior permission.  No warranty implied or otherwise.
