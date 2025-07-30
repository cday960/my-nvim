; extends

; (expression_statement
;   (assignment
;     left: (identifier) @_name (#eq? @_name "sql" "query")
;     right: (string
;       (string_content) @injection.content
;         (#set! injection.language "sql")
;         (#set! injection.include-children)))
; )

; (comment) @_c (#match? @_c "(?i)sql")
; (string
; 	(string_content) @injection.content
; 		(#set! injection.language "sql")
; 		(#set! injection.include-children)
; )

;; Match triple-quoted strings that start with --sql
((string
  (string_content) @sql
  (#lua-match? @sql "^--sql"))
 (#set! injection.language "sql")
 (#set! injection.include-children))


; (call
;   function: (attribute
;     attribute: (identifier) @_method (#any-of? @_method "execute" "executemany" "query" "mogrify"))
;   arguments: (argument_list
;     (string
;       (string_content) @injection.content
;         (#set! injection.language "sql")
;         (#set! injection.include-children)))
; )
;
