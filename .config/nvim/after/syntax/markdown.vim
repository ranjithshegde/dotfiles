syntax match MarkdownDash /^---\+$/ conceal
syntax match MarkdownDot /\\\./ conceal cchar=.
syntax match MarkdownSlash /\\\-/ conceal cchar=-
syntax match MarkdownSemicolon /\\\;/ conceal cchar=;
syntax match MarkdownColon /\\\:/ conceal cchar=:
syntax match MarkdownSQuote /\\\'/ conceal cchar='
syntax match MarkdownDQuote /\\\"/ conceal cchar="
syntax match MarkdownBackslash /\\\// conceal cchar=/
