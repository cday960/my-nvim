; extends

;; Inject Python into {{ ... }}
((variable) @injection.content
	(#set! injection.language "python")
	(#set! injection.include-children))
