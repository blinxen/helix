; Comments
(tripledot) @comment.discard

[(comment) (line_comment) (shebang)] @comment

; Basic types
(variable) @variable
(atom) @string.special.symbol
((atom) @constant.builtin.boolean
 (#match? @constant.builtin.boolean "^(true|false)$"))
[(string) (sigil)] @string
(character) @constant.character
(escape_sequence) @constant.character.escape

(integer) @constant.numeric.integer
(float) @constant.numeric.float

; Punctuation
["," "." "-" ";"] @punctuation.delimiter
["(" ")" "#" "{" "}" "[" "]" "<<" ">>"] @punctuation.bracket

; Operators
(binary_operator operator: _ @operator)
(unary_operator operator: _ @operator)
["/" ":" "->"] @operator

(binary_operator
  left: (atom) @function
  operator: "/"
  right: (integer) @constant.numeric.integer)

((binary_operator operator: _ @keyword.operator)
 (#match? @keyword.operator "^\\w+$"))
((unary_operator operator: _ @keyword.operator)
 (#match? @keyword.operator "^\\w+$"))

; Functions
(function_clause name: (atom) @function)
(call module: (atom) @namespace)
(call function: (atom) @function)
(stab_clause name: (atom) @function)
(function_capture module: (atom) @namespace)
(function_capture function: (atom) @function)

; Keywords
(attribute name: (atom) @keyword)

["case" "fun" "if" "of" "when" "end" "receive" "try" "catch" "after" "begin" "maybe"] @keyword

; Attributes
; module declaration
(attribute
  name: (atom) @keyword
  (arguments (atom) @namespace)
 (#any-of? @keyword "module" "behaviour" "behavior"))

(attribute
  name: (atom) @keyword
  (arguments
    .
    (atom) @namespace)
 (#eq? @keyword "import"))

(attribute
  name: (atom) @keyword
  (arguments
    .
    [(atom) @type (macro)]
    [
      (tuple (atom)? @variable.other.member)
      (tuple
        (binary_operator
          left: (atom) @variable.other.member
          operator: ["=" "::"]))
      (tuple
        (binary_operator
          left:
            (binary_operator
              left: (atom) @variable.other.member
              operator: "=")
          operator: "::"))
      ])
 (#eq? @keyword "record"))

(attribute
  name: (atom) @keyword
  (arguments
    .
    [
      (atom) @constant
      (variable) @constant
      (call
        function:
          [(variable) (atom)] @keyword.directive)
    ])
 (#eq? @keyword "define"))

(attribute
  name: (atom) @keyword
  (arguments
    (_) @keyword.directive)
 (#any-of? @keyword "ifndef" "ifdef"))

(attribute
  name: (atom) @keyword
  module: (atom) @namespace
 (#any-of? @keyword "spec" "callback"))

(attribute
  name: (atom) @keyword
  (arguments [
    (string)
    (sigil)
  ] @comment.block.documentation)
 (#any-of? @keyword "doc" "moduledoc"))

; Ignored variables
((variable) @comment.discard
 (#match? @comment.discard "^_"))

; Macros
(macro
  "?"+ @keyword.directive
  name: (_) @keyword.directive)

(macro
  "?"+ @constant
  name: (_) @constant
  !arguments)

; Parameters
; specs
((attribute
   name: (atom) @keyword
   (stab_clause
     pattern: (arguments (variable)? @variable.parameter)
     body: (variable)? @variable.parameter))
 (#match? @keyword "(spec|callback)"))
; functions
(function_clause pattern: (arguments (variable) @variable.parameter))
; anonymous functions
(stab_clause pattern: (arguments (variable) @variable.parameter))
; parametric types
((attribute
    name: (atom) @keyword
    (arguments
      (binary_operator
        left: (call (arguments (variable) @variable.parameter))
        operator: "::")))
 (#match? @keyword "(type|opaque)"))
; macros
((attribute
   name: (atom) @keyword
   (arguments
     (call (arguments (variable) @variable.parameter))))
 (#eq? @keyword "define"))

; Records
(record_content
  (binary_operator
    left: (atom) @variable.other.member
    operator: "="))

(record field: (atom) @variable.other.member)
(record name: (atom) @type)
