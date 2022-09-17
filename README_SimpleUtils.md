# FS22 Simple Utilities

- [FS22 Simple Utilities](#fs22-simple-utilities)
  - [Included](#included)
    - [JTSUtil.hslToRgb(h, s, l, a)](#jtsutilhsltorgbh-s-l-a)
    - [JTSUtil.colorPercent(percent, reverse, fractional)](#jtsutilcolorpercentpercent-reverse-fractional)
    - [JTSUtil.calcPercent(level, capacity, text)](#jtsutilcalcpercentlevel-capacity-text)
    - [JTSUtil.qConcatS(...)](#jtsutilqconcats)
    - [JTSUtil.qConcat(...)](#jtsutilqconcat)
    - [JTSUtil.sortTableByKey(inputTable, key)](#jtsutilsorttablebykeyinputtable-key)
    - [Simple Stack Implementation](#simple-stack-implementation)
    - [JTSUtil.stringSplit(str, sep)](#jtsutilstringsplitstr-sep)
  - [VSCode Snippets](#vscode-snippets)
  - [Distribution & Licensing Terms](#distribution--licensing-terms)

## Included

### JTSUtil.hslToRgb(h, s, l, a)

Convert a HSL color to sRGBa

- **h** : hue [0-1]
- **s*- : saturation [0-1]
- **l*- : luminosity [0-1]
- **a*- : alpha [0-1]

**Return:** `{ r, g, b, a }`

### JTSUtil.colorPercent(percent, reverse, fractional)

Return a color based on percentage (green->red) (or the colorblind equivalent)

- **percent** : percent to get color for [0-1] OR [0-100]
- **reverse** : false : `100% == green`, true : `100% == red`
- **fractional** : true = percent is `[0-1]`, false = percent is `[0-100]`

**Return:** `{ r, g, b, a }`

### JTSUtil.calcPercent(level, capacity, text)

Safely calculate a percentage

- **level** : amount
- **capacity** : total
- **text** : true = append a `%` sign to the output

**Return:** `[0-100]` (number) *OR* `[0%-100%]` (string)

### JTSUtil.qConcatS(...)

Safely concatenate all parameters with a space between each. Automatically converts all parameters to strings.

### JTSUtil.qConcat(...)

Safely concatenate all parameters. Automatically converts all parameters to strings.

### JTSUtil.sortTableByKey(inputTable, key)

Sort a table by a key name, where the table is of the style:

```lua
local testTable = {
  { key1 = "value1", key2 = "sortMeCCC"},
  { key1 = "value2", key2 = "sortMeBBB"},
  { key1 = "value3", key2 = "sortMeFFF"},
  { key1 = "value4", key2 = "sortMeAAA"}
}
```

`JTSUtils.sortTableByKey(testTable, "key2")`

```lua
local testTable = {
  { key1 = "value4", key2 = "sortMeAAA"},
  { key1 = "value2", key2 = "sortMeBBB"},
  { key1 = "value1", key2 = "sortMeCCC"},
  { key1 = "value3", key2 = "sortMeFFF"}
}
```

### Simple Stack Implementation

- JTSUtil.stackNewRow(inputTable)
  - Add a row to the stack (empty)
- JTSUtil.stackAddToNewRow(inputTable, entry)
  - Add an entry to a new row in the stack
- JTSUtil.stackAddToRow(inputTable, entry)
  - Add an entry to the current row in the stack
- JTSUtil.stackGetRow(inputTable, rowNumber, reverse)
  - Get a row of the stack in natural or reversed order (non-destructive)
- JTSUtil.dispStackAdd(inputTable, text, color, newRow)
  - Add an entry of {text="", color=""} or a row (maybe new) in the stack

Very simple implementation of a table stack, used in several of my mods. Look at the code for more info.  Keep in mind this is a stack, **not** a buffer or a fifo.

`stackNewRow`, `stackAddToNewRow`, `stackAddToRow`, `stackGetRow` are more generalized, while `dispStackAdd` is specific to my needs.

It's probably possible to have stacks of stacks, they are just semi-sanitized tables, but it has not been tested.

```lua
local displayLines = {}

JTSUtil.dispStackAdd(displayLines, "hi", "red", true)
JTSUtil.dispStackAdd(displayLines, "there", "red")
JTSUtil.dispStackAdd(displayLines, "goodbye", "blue", true)
JTSUtil.dispStackAdd(displayLines, "now", "blue")
```

displayLines now contains:

```lua
displayLines = {
  {
    { text = "hi", color = "red" },
    { text = "there", color = "red"},
  },
  {
    { text = "goodbye", color = "blue" },
    { text = "now", color = "blue"},
  }
}
```

```lua
-- Very incomplete pseudo-code bit:
JTSUtil.dispGetLine(displayLines, 1, false)
--> hi, there
JTSUtil.dispGetLine(displayLines, 1, true)
--> there, hi
```

### JTSUtil.stringSplit(str, sep)

Splits string "str" by separator "sep"

## VSCode Snippets

These are a few snippets that should make using this library easier

```json
  "JTSUtil: colorPercent" : {
    "prefix": ["JTSUtil.colorPercent"],
    "body": [
      "JTSUtil.colorPercent(${1:percent}, ${2|REVERSE,false,true|}, ${3|FRACTIONAL,false,true|})"
    ],
    "description": "Return a color based on a percentage"
  },
  "JTSUtil: calcPercent" : {
    "prefix": ["JTSUtil.calcPercent"],
    "body": [
      "JTSUtil.calcPercent(${1:level}, ${2:capacity}, ${3|AS_TEXT,false,true|})"
    ],
    "description": "Return a percentage (Giants math)"
  },
  "JTSUtil: qConcat" : {
    "prefix": ["JTSUtil.qConcat"],
    "body": [
      "JTSUtil.qConcat($0)"
    ],
    "description": "Concat strings (type safe)"
  },
  "JTSUtil: qConcatS" : {
    "prefix": ["JTSUtil.qConcatS"],
    "body": [
      "JTSUtil.qConcatS($0)"
    ],
    "description": "Concat strings (type safe) with space separation"
  },
  "JTSUtil: sortTableByKey" : {
    "prefix": ["JTSUtil.sortTableByKey"],
    "body": [
      "JTSUtil.sortTableByKey(${1:tableToSort}, \"${2:key}\")"
    ],
    "description": "Sort a table by a named key"
  },
  "JTSUtil: stringSplit" : {
    "prefix": ["JTSUtil.stringSplit"],
    "body": [
      "JTSUtil.stringSplit(\"${1:string}\", \"${2:separator}\")"
    ],
    "description": "Split a string by a separator"
  }
```

## Distribution & Licensing Terms

(c)JTSage Modding & FSG Modding.  You may reuse or alter this code to your needs as necessary with no prior permission.  No warranty implied or otherwise.
