# FS22Log LUA Logger Class for FS22

- [FS22Log LUA Logger Class for FS22](#fs22log-lua-logger-class-for-fs22)
  - [Class Initialization](#class-initialization)
  - [Class Functions](#class-functions)
    - [Print text to the log](#print-text-to-the-log)
    - [Print variable contents to the log - recursively prints tables](#print-variable-contents-to-the-log---recursively-prints-tables)
  - [Top-Level Functions](#top-level-functions)
    - [Print function call arguments](#print-function-call-arguments)
  - [Run Levels](#run-levels)
  - [Log Levels](#log-levels)
  - [Search Types](#search-types)
  - [Examples](#examples)
    - [Logger Class](#logger-class)
      - [Class initiated](#class-initiated)
      - [Simple text](#simple-text)
      - [Simple Variable](#simple-variable)
      - [Simple Variable - IsTable](#simple-variable---istable)
      - [Table Output](#table-output)
      - [Searching Tables Output](#searching-tables-output)
    - [Function Argument Printer](#function-argument-printer)
    - [Dynamic run level](#dynamic-run-level)
  - [VSCode Snippets](#vscode-snippets)
  - [Distribution & Licensing Terms](#distribution--licensing-terms)

## Class Initialization

```lua
yourLogger = FS22Log:new(callerName, debugMode, filterOut, filterExclusive)
```

- __callerName__      : Name of your mod, or logging section
- __debugMode__       : one of the `DEBUG_MODE` below, `.WARNINGS` suggested for production mode
- __filterOut__       : names to filter __OUT__ of printed output
- __filterExclusive__ : names to __ONLY__ print, takes precedence

## Class Functions

### Print text to the log

```lua
yourLogger:print(text, logLevel, filter)
```

- __text__     : Text to print
- __logLevel__ : Log level from LOG_LEVEL below, default is `.DEVEL`
- __filter__   : Text string for `[filterOut]` and `[filterExclusive]`, default is `--`

### Print variable contents to the log - recursively prints tables

```lua
yourLogger.printVariable(output, logLevel, filter, depthLimit, prefix, searchTerms)
```

```lua
yourLogger.printVariableIsTable(output, logLevel, filter, depthLimit, prefix, searchTerms)
```

The __IsTable__ variant will auto-upgrade the logLevel to `WARNING` when the variable is not a table, and `ERROR` if the variable is `undefined` or `nil`

```lua
yourLogger.printVariableOnce(output, logLevel, filter, depthLimit, prefix, searchTerms)
```

The __Once__ variant will print the variable only once, based on the name given to `filter`

```lua
yourLogger.printVariableIfChanged(output, logLevel, filter, depthLimit, prefix, searchTerms)
```

The __IfChanged__ variant will print only if the contents of the variable have changed since last
time it was called, based on the name given to `filter`.  Note that this is not deep-recursive, only
the first level of the table is looked at for changes.

- __output__      : Variable to print
- __logLevel__    : Log level from LOG_LEVEL below, default is `.DEVEL`
- __filter__      : Text string for `[filterOut]` and `[filterExclusive]`, default is "--"
- __depthLimit__  : How deep to traverse tables, default is 2 levels
  - (1 based argument - e.g 2 == show 2 levels total)
- __prefix__      : Text string for name of variable, defaults to `[filter]`
- __searchTerms__ : Terms to search - options:
  - `"string"`
    - Search for `"string"` in KEYS only
  - `{ "string", SEARCH.TYPE }`
    - Search for `"string"` using `SEARCH.TYPE` fromm below.
  - `{ {"table", "of", "strings"}, SEARCH.TYPE }`
    - Search for all strings in table using `SEARCH.TYPE` from below.

## Top-Level Functions

### Print function call arguments

Intercept function calls to print the arguments it's being called with.  This method call is similar to how Utils.prependedFunction() works.

Note that if you pass an invalid function, _when in debug mode_, a valid function with an error message will be returned

```lua
originFunction = FS22LogFunction(logLevel, originMod, originFunctionName, originFunction)
```

- __logLevel__           : Log level from `LOG_LEVEL` below, has no function is set to `.WARNINGS` or `.ERRORS` or `.NONE`
- __originMod__          : Name of your mod for printing purposes
- __originFunctionName__ : Name of the original function (string)
- __originFunction__     : Original function (literal)

## Run Levels

 It is highly recommended that your store this value locally in your mod, and pass it to the constructor / calls to FS22LogFunction() so you can quickly toggle the level for released mods without having to remove all your logging calls.

- _FS22Log.DEBUG_MODE_.__NONE__     - Print nothing, ever
- _FS22Log.DEBUG_MODE_.__ERRORS__   - Print errors
- _FS22Log.DEBUG_MODE_.__WARNINGS__ - Print warnings, suggested or "production" mode
- _FS22Log.DEBUG_MODE_.__INFO__     - Print information
- _FS22Log.DEBUG_MODE_.__DEVEL__    - Print Development information
- _FS22Log.DEBUG_MODE_.__VERBOSE__  - Print Verbose Development information

## Log Levels

These correspond to the above run levels.  If the error level matches, or is of higher precedence than the current run level, the log message is printed.

- _FS22Log.LOG_LEVEL_.__ERROR__   - Errors only
- _FS22Log.LOG_LEVEL_.__WARNING__ - Warnings, suggested for "production" mode
- _FS22Log.LOG_LEVEL_.__INFO__    - Information level
- _FS22Log.LOG_LEVEL_.__DEVEL__   - Development information
- _FS22Log.LOG_LEVEL_.__VERBOSE__ - Verbose Development information

## Search Types

Types for the search feature

- _FS22Log.SEARCH_.__KEYS__            - Search keys only
- _FS22Log.SEARCH_.__VALUES__          - Search values only
- _FS22Log.SEARCH_.__BOTH__            - Search both keys and values
- _FS22Log.SEARCH_.__KEYS_AND_VALUES__ - Search both keys and values

## Examples

Some examples of the enhanced logger in action

### Logger Class

These are from the logger class

#### Class initiated

```lua
local myLoggerVanilla = FS22Log:new(
    "demoSample",
    FS22Log.DEBUG_MODE.VERBOSE
)
```

#### Simple text

```lua
myLoggerVanilla:print("Test String", nil, "test_string")
```

```plaintext
~~ demoSample:DEVEL:test_string | Test String
```

#### Simple Variable

```lua
local testVarString = "Hello There."

myLoggerVanilla:printVariable(undefinedVar, nil, "undefined_variable")
myLoggerVanilla:printVariable(testVarString, nil, "test_string_variable")
```

```plaintext
~~ demoSample:DEVEL:undefined_variable | undefined_variable :: nil
~~ demoSample:DEVEL:test_string_variable | test_string_variable :: Hello There.
```

#### Simple Variable - IsTable

```lua
local testVarString = "Hello There."

myLoggerVanilla:printVariableIsTable(undefinedVar, nil, "undefined_variable")
myLoggerVanilla:printVariableIsTable(testVarString, nil, "test_string_variable")
```

Note that the `logLevel` has been automatically upgraded

```plaintext
~~ demoSample:ERROR:undefined_variable_is_table | undefined_variable_is_table :: nil
~~ demoSample:WARNING:test_string_variable_is_table | test_string_variable_is_table :: Hello There.
```

#### Table Output

```lua
myLoggerVanilla:printVariable(DemoSampleData, nil, "sample_data", 3)
```

```plaintext
~~ demoSample:DEVEL:sample_data | sample_data.1 :: table: 00B31338
~~ demoSample:DEVEL:sample_data | _sample_data.1.type    :: donut
~~ demoSample:DEVEL:sample_data | _sample_data.1.name    :: Cake
~~ demoSample:DEVEL:sample_data | _sample_data.1.id      :: 1
~~ demoSample:DEVEL:sample_data | _sample_data.1.batters :: table: 00B31130
~~ demoSample:DEVEL:sample_data | __sample_data.1.batters.batter :: table: 00B31518
~~ demoSample:DEVEL:sample_data | _sample_data.1.topping :: table: 00B31248
~~ demoSample:DEVEL:sample_data | __sample_data.1.topping.1 :: table: 00B31158

...

~~ demoSample:DEVEL:sample_data | __sample_data.3.topping.3 :: table: 00B31A00
~~ demoSample:DEVEL:sample_data | __sample_data.3.topping.4 :: table: 00B31BE0
```

#### Searching Tables Output

```lua
myLoggerVanilla:printVariable(DemoSampleData, nil, "sample_data_search_fail", 4, nil, {"badArgument!"})
myLoggerVanilla:printVariable(DemoSampleData, nil, "sample_data_search", 4, nil, {{"batter", "Chocolate"}, FS22Log.SEARCH.VALUES})
```

```plaintext
~~ demoSample:DEVEL:sample_data_search_fail | ERROR: Incorrect search terms, see logger documentation
~~ demoSample:DEVEL:sample_data_search | Searching for: {batter,Chocolate} [VALUES]
~~ demoSample:DEVEL:sample_data_search | ___sample_data_search.1.topping.5.type :: Chocolate with Sprinkles
~~ demoSample:DEVEL:sample_data_search | ___sample_data_search.1.topping.6.type :: Chocolate
~~ demoSample:DEVEL:sample_data_search | ___sample_data_search.2.topping.4.type :: Chocolate
~~ demoSample:DEVEL:sample_data_search | ___sample_data_search.3.topping.3.type :: Chocolate
```

### Function Argument Printer

```lua

function AddTest(a, b)
    print("Original AddTest called: " .. tostring(a) .. " + " .. tostring(b) .. " = " .. tostring(a+b))
end

function SubTest(a, b)
    print("Original SubTest called: " .. tostring(a) .. " - " .. tostring(b) .. " = " .. tostring(a-b))
end

InvalidFunction = FS22LogFunction(FS22Log.DEBUG_MODE.DEVEL, "demoSample", "InvalidFunction", InvalidFunction)
AddTest         = FS22LogFunction(FS22Log.DEBUG_MODE.DEVEL, "demoSample", "AddTest", AddTest)

-- Note, WARNINGS is below the printable threshold, so this call produces no additional output.
SubTest         = FS22LogFunction(FS22Log.DEBUG_MODE.WARNINGS, "demoSample", "SubTest", SubTest)

InvalidFunction()
AddTest(1, 2)
SubTest(5, 1)
```

```plaintext
~~ demoSample:InvalidFunction | Original Function Not Found
~~ demoSample:InvalidFunction | Invalid function call (no original)

~~ demoSample:AddTest | Called With: [1], [2]
Original AddTest called: 1 + 2 = 3

Original SubTest called: 5 - 1 = 4
```

### Dynamic run level

This is a very simplified example of using a dynamic run level to show log text while developing but not displaying them in released code, all while not having to remove the log functions from your code.

```lua

local myDebug = FS22Log.DEBUG_MODE.VERBOSE -- Development
--local myDebug = FS22Log.DEBUG_MODE.WARNINGS -- Release

local myLoggerVanilla = FS22Log:new(
    "demoSample",
    myDebug
)

-- These will show for development, but not in release mode
myLoggerVanilla:printVariable(testVarString, FS22Log.LOG_LEVEL.INFO, "test_string_variable")

AddTest = FS22LogFunction(myDebug, "demoSample", "AddTest", AddTest)

```

## VSCode Snippets

This is a set of VSCode snippets to ease the use of the logger even more.

```json
  "Logger: variable": {
    "prefix": [":printVariable"],
    "body": [
      ":printVariable(${1:inputTable}, FS22Log.LOG_LEVEL.${2|VERBOSE,DEVEL,INFO,WARNING,ERROR|}, \"${3:filterString}\", ${4|nil,1,2,3,4|}, nil, ${5|nil,{\"searchTable\"},\"searchText\"|})"
    ],
    "description": "Print a variable"
  },
  "Logger: variableIsTable": {
    "prefix": [":printVariableIsTable"],
    "body": [
      ":printVariableIsTable(${1:inputTable}, FS22Log.LOG_LEVEL.${2|VERBOSE,DEVEL,INFO,WARNING,ERROR|}, \"${3:filterString}\", ${4|nil,1,2,3,4|}, nil, ${5|nil,{\"searchTable\"},\"searchText\"|})"
    ],
    "description": "Print a variable"
  },
  "Logger: variableOnce": {
    "prefix": [":printVariableOnce"],
    "body": [
      ":printVariableOnce(${1:inputTable}, FS22Log.LOG_LEVEL.${2|VERBOSE,DEVEL,INFO,WARNING,ERROR|}, \"${3:filterString}\", ${4|nil,1,2,3,4|}, nil, ${5|nil,{\"searchTable\"},\"searchText\"|})"
    ],
    "description": "Print a variable (only once)"
  },
  "Logger: variableIfChanged": {
    "prefix": [":printVariableIfChanged"],
    "body": [
      ":printVariableIfChanged(${1:inputTable}, FS22Log.LOG_LEVEL.${2|VERBOSE,DEVEL,INFO,WARNING,ERROR|}, \"${3:filterString}\", ${4|nil,1,2,3,4|}, nil, ${5|nil,{\"searchTable\"},\"searchText\"|})"
    ],
    "description": "Print a variable (if changed)"
  },
  "Logger: string": {
    "prefix": [":print"],
    "body": [
      ":print(\"${1:text}\", FS22Log.LOG_LEVEL.${2|VERBOSE,DEVEL,INFO,WARNING,ERROR|}, \"${3:filterString}\")"
    ],
    "description": "Print a variable"
  }
```

## Distribution & Licensing Terms

(c)JTSage Modding & FSG Modding.  You may reuse or alter this code to your needs as necessary with no prior permission.  No warranty implied or otherwise.
