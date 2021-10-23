import os
import sys

config.load_autoconfig(True)

# QtWebEngine, some Chromium arguments (see
# https://peter.sh/experiments/chromium-command-line-switches/)
# Type: List of String
c.qt.args = [
    "enable-gpu-rasterization",
    "enable-accelerated-video-decode",
    "ignore-gpu-blocklist",
    "use-gl=egl",
    "enable-native-gpu-memory-buffers",
]


c.auto_save.session = True

# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set("content.cookies.accept", "all", "chrome-devtools://*")

config.set("content.cookies.accept", "all", "devtools://*")

c.content.prefers_reduced_motion = True

# default_editor = ["st -e nvim", "{file}"]

# c.editor.command = default_editor

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}",
    "https://web.whatsapp.com/",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version} Edg/{upstream_browser_version}",
    "https://accounts.google.com/*",
)

config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36",
    "https://*.slack.com/*",
)

c.content.blocking.method = "both"

# Load images automatically in web pages.
# Type: Bool
config.set("content.images", True, "chrome-devtools://*")

# Load images automatically in web pages.
# Type: Bool
config.set("content.images", True, "devtools://*")

# Enable JavaScript.
# Type: Bool
c.content.javascript.enabled = True

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "chrome-devtools://*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "devtools://*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "chrome://*/*")

# Enable JavaScript.
# Type: Bool
config.set("content.javascript.enabled", True, "qute://*/*")

# Allow websites to show notifications.
# Type: BoolAsk
# Valid values:
#   - true
#   - false
#   - ask
config.set("content.notifications.enabled", False, "https://6.mediainformer.click")

# Which unbound keys to forward to the webview in normal mode.
# Type: String
# Valid values:
#   - all: Forward all unbound keys.
#   - auto: Forward unbound non-alphanumeric keys.
#   - none: Don't forward any keys.
c.input.forward_unbound_keys = "auto"

# Leave insert mode if a non-editable element is clicked.
# Type: Bool
c.input.insert_mode.auto_leave = False

c.spellcheck.languages = ["en-US"]

# Page to open if :open -t/-b/-w is used without URL. Use `about:blank`
# for a blank page.
# Type: FuzzyUrl
c.url.default_page = "https://search.brave.com/"

c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "aur": "https://aur.archlinux.org/packages/?O=0&K={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gl": "https://www.google.com/search?hl=en&q={}",
    "hub": "https://github.com/search?q={}",
    "lab": "https://gitlab.com/search?search={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "re": "https://www.reddit.com/r/{}",
    "wiki": "https://en.wikipedia.org/wiki/{}",
}


# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
# Type: List of QtColor, or QtColor
c.colors.completion.fg = ["#9cc4ff", "white", "white"]

# Background color of the completion widget for odd rows.
# Type: QssColor
c.colors.completion.odd.bg = "#1c1f24"

# Background color of the completion widget for even rows.
# Type: QssColor
c.colors.completion.even.bg = "#232429"

# Foreground color of completion widget category headers.
# Type: QtColor
c.colors.completion.category.fg = "#e1acff"

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = (
    "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #000000, stop:1 #232429)"
)

# Top border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.top = "#3f4147"

# Bottom border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.bottom = "#3f4147"

# Foreground color of the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.fg = "#282c34"

# Background color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.bg = "#ecbe7b"

# Foreground color of the matched text in the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.match.fg = "#c678dd"

# Foreground color of the matched text in the completion.
# Type: QtColor
c.colors.completion.match.fg = "#c678dd"

# Color of the scrollbar handle in the completion view.
# Type: QssColor
c.colors.completion.scrollbar.fg = "white"

# Background color for the download bar.
# Type: QssColor
c.colors.downloads.bar.bg = "#282c34"

# Background color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.bg = "#ff6c6b"

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = "#282c34"

# Font color for the matched part of hints.
# Type: QtColor
c.colors.hints.match.fg = "#98be65"

# Background color of an info message.
# Type: QssColor
c.colors.messages.info.bg = "#282c34"

# Background color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.bg = "#282c34"

# Foreground color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.fg = "white"

# Background color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.bg = "#497920"

# Background color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.bg = "#34426f"

# Background color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.bg = "#282c34"

# Foreground color of the URL in the statusbar when there's a warning.
# Type: QssColor
c.colors.statusbar.url.warn.fg = "yellow"

# Background color of the tab bar.
# Type: QssColor
c.colors.tabs.bar.bg = "#1c1f34"

# Background color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.bg = "darkgrey"

# Background color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.bg = "grey"

# Background color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.bg = "#282c34"

# Background color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.bg = "#282c34"

# Background color of pinned unselected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.odd.bg = "seagreen"

# Background color of pinned unselected even tabs.
# Type: QtColor
c.colors.tabs.pinned.even.bg = "darkseagreen"

# Background color of pinned selected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.odd.bg = "#282c34"

# Background color of pinned selected even tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.even.bg = "#282c34"

# Default font families to use. Whenever "default_family" is used in a
# font setting, it's replaced with the fonts listed here. If set to an
# empty value, a system-specific monospace default is used.
# Type: List of Font, or Font
# c.fonts.default_family = '"SauceCodePro Nerd Font"'

# Default font size to use. Whenever "default_size" is used in a font
# setting, it's replaced with the size listed here. Valid values are
# either a float value with a "pt" suffix, or an integer value with a
# "px" suffix.
# Type: String
# c.fonts.default_size = "11pt"

# Font used in the completion widget.
# Type: Font
# c.fonts.completion.entry = '11pt "SauceCodePro Nerd Font"'

# Font used for the debugging console.
# Type: Font
# c.fonts.debug_console = '11pt "SauceCodePro Nerd Font"'

# Font used for prompts.
# Type: Font
# c.fonts.prompts = "default_size sans-serif"

# Font used in the statusbar.
# Type: Font
# c.fonts.statusbar = '11pt "SauceCodePro Nerd Font"'


# Page(s) to open at the start.
# Type: List of FuzzyUrl, or FuzzyUrl
c.url.start_pages = "https://search.brave.com"

c.bindings.key_mappings = {
    "<Ctrl+6>": "<Ctrl+^>",
    "<Ctrl+Enter>": "<Ctrl+Return>",
    "<Ctrl+[>": "<Escape>",
    "<Ctrl+j>": "<Return>",
    "<Ctrl+m>": "<Return>",
    "<Enter>": "<Return>",
    "<Shift+Enter>": "<Return>",
    "<Shift+Return>": "<Return>",
}

# Bindings for normal mode
config.bind(",M", "hint links spawn vlc {hint-url}")
config.bind(",m", "spawn vlc {url}")
config.bind(
    ",z",
    "hint links spawn st -e youtube-dl  --external-downloader aria2c --external-downloader-args '-c -j 3 -x 3 -s 3 -k 1M' {hint-url}",
)
config.bind("xb", "config-cycle statusbar.show always never")
config.bind("xt", "config-cycle tabs.show always never")
config.bind(",p", "spawn --userscript /usr/share/qutebrowser/userscripts/password_fill")
config.bind(
    ",P", "spawn --userscript qute-pass --dmenu-invocation dmenu --password-only"
)
config.bind(
    ",D",
    'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/solarized-dark-all-sites.css ""',
)
config.bind(
    ",a",
    'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/apprentice-all-sites.css ""',
)
config.bind(
    ",A",
    'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/darculized-all-sites.css ""',
)
# config.set("colors.webpage.darkmode.enabled", True)
config.bind(
    ",d",
    'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/gruvbox-all-sites.css ""',
)
