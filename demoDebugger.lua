require '_cliSugar'
require '_testData'
require 'fs22Logger'

printWarning("Demo Script - Enhanced FS22 Logger")
print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")

local myLoggerVanilla = FS22Log:new(
	"demoSample",
	FS22Log.DEBUG_MODE.VERBOSE
)

-- yourLogger:print(text, logLevel, filter)
-- yourLogger.printVariable(output, logLevel, filter, depthLimit, prefix, searchTerms)

local testVarString = "Hello There."

myLoggerVanilla:print("Test String", nil, "test_string")
myLoggerVanilla:printVariable(undefinedVar, nil, "undefined_variable")
myLoggerVanilla:printVariableIsTable(undefinedVar, nil, "undefined_variable_is_table")
myLoggerVanilla:printVariable(testVarString, nil, "test_string_variable")
myLoggerVanilla:printVariableIsTable(testVarString, nil, "test_string_variable_is_table")
myLoggerVanilla:printVariable(DemoSampleData, nil, "sample_data", 3)
myLoggerVanilla:printVariable(DemoSampleData, nil, "sample_data_search_fail", 4, nil, {"badArgument!"})
myLoggerVanilla:printVariable(DemoSampleData, nil, "sample_data_search", 4, nil, {{"batter", "Chocolate"}, FS22Log.SEARCH.VALUES})

function AddTest(a, b)
	print("Original AddTest called: " .. tostring(a) .. " + " .. tostring(b) .. " = " .. tostring(a+b))
end

function SubTest(a, b)
	print("Original SubTest called: " .. tostring(a) .. " - " .. tostring(b) .. " = " .. tostring(a-b))
end

InvalidFunction = FS22LogFunction(FS22Log.DEBUG_MODE.DEVEL, "demoSample", "InvalidFunction", InvalidFunction)
AddTest         = FS22LogFunction(FS22Log.DEBUG_MODE.DEVEL, "demoSample", "AddTest", AddTest)
SubTest         = FS22LogFunction(FS22Log.DEBUG_MODE.WARNINGS, "demoSample", "SubTest", SubTest)

InvalidFunction()
AddTest(1, 2)
SubTest(5, 1)
