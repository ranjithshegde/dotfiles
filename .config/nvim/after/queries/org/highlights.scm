(
 ((stars) @stars (#eq? @stars "*")) @conceal
 (#set! conceal "◉")
 )
(
 ((stars) @stars (#eq? @stars "**")) @conceal
 (#set! conceal "○")
 )
(
 ((stars) @stars (#eq? @stars "***")) @conceal
 (#set! conceal "✸")
 )
(
 ((stars) @stars (#eq? @stars "****")) @conceal
 (#set! conceal "✿")
 )
(expr 
  ["*"] @conceal
  (#set! conceal ""))

(list
  (listitem
    (bullet)
    @text.strong (#set! conceal "•")
    ))

(itemtext
  (list
    (listitem
      (bullet)
      @text.emphasis (#set! conceal ".")
      )))
