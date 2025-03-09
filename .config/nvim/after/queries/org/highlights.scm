;; extends
;; Level 1 (Top-level)
(list
  (listitem
    (bullet)
    @text.strong (#set! conceal "◆")
  )
)
;; Level 2 (Nested once)
(list
  (listitem
    (list
      (listitem
        (bullet)
        @text.strong (#set! conceal "▪")
      )
    )
  )
)
;; Level 3 (Nested twice)
(list
  (listitem
    (list
      (listitem
        (list
          (listitem
            (bullet)
            @text.strong (#set! conceal "•")
          )
        )
      )
    )
  )
)
