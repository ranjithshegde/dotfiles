(generic_environment
  (enum_item ["\\item"] @emphasis)
  (#set! conceal "•")
)
; (generic_environment
;   (enum_item ["\\dots"] @emphasis)
;   (#set! conceal "…")
; )

(displayed_equation ["\\["] @emphasis
(#set! conceal "⟦")
)

(displayed_equation ["\\]"] @emphasis
(#set! conceal "⟧")
)


; (
;  ((stars) @stars (#eq? @stars "*")) @OrgTSHeadlineLevel1
;  (#set! conceal "◉")
;  )
