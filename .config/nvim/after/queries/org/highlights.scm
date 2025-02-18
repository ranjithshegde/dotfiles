;; extends
(
 ((stars) @stars (#eq? @stars "*")) @OrgTSHeadlineLevel1
 (#set! conceal "◉")
 )
;; extends
(
 ((stars) @stars (#eq? @stars "**")) @OrgTSHeadlineLevel2
 (#set! conceal "○")
 )
;; extends
(
 ((stars) @stars (#eq? @stars "***")) @OrgTSHeadlineLevel3
 (#set! conceal "✸")
 )
;; extends
(
 ((stars) @stars (#eq? @stars "****")) @OrgTSHeadlineLevel4
 (#set! conceal "✿")
 )
;; extends
(list
  (listitem
    (bullet)
    @text.strong (#set! conceal "•")
    ))
