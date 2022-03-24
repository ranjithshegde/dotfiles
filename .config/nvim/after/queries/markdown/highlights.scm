(document
  (list
    (list_item
      [(list_marker_dot)
       (list_marker_minus)
       (list_marker_plus)
       (list_marker_star)] @text.strong (#set! conceal "◉"))))
(document
  (list
    (list_item
      (list
        (list_item
          [(list_marker_dot)
           (list_marker_minus)
           (list_marker_plus)
           (list_marker_star)] @text.strong (#set! conceal "•"))))))

([
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
] @_conceal
(#set! conceal ""))

([
  (info_string)
  (fenced_code_block_delimiter)
  (code_span_delimiter)
  (emphasis_delimiter)
] @_conceal
(#set! conceal ""))

(inline_link 
  ["]"] @conceal
  (#set! conceal " "))

(inline_link 
  "["  @conceal
  (#set! conceal ""))
