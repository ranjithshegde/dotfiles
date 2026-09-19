(generic_environment
  (enum_item ["\\item"] @emphasis)
  (#set! conceal "•")
  )

(displayed_equation ["\\["] @emphasis
                    (#set! conceal "⟦")
                    )

(displayed_equation ["\\]"] @emphasis
                    (#set! conceal "⟧")
                    )

(generic_command 
  ((command_name) @tex_conceal (#eq? @tex_conceal "\\alpha") )@conceal
  (#set! conceal "α")
  )

(generic_command 
  ((command_name) @tex_conceal (#eq? @tex_conceal "\\beta") )@conceal
  (#set! conceal "β")
  )
