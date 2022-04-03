(
((stars) @stars (#eq? @stars "*")) @OrgTSHeadlineLevel1
(#set! conceal "◉")
)
(
((stars) @stars (#eq? @stars "**")) @OrgTSHeadlineLevel2
(#set! conceal "○")
)
(
((stars) @stars (#eq? @stars "***")) @OrgTSHeadlineLevel3
(#set! conceal "✸")
)
(
((stars) @stars (#eq? @stars "****")) @OrgTSHeadlineLevel4 
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
