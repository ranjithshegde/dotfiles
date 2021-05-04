import os
import sys
config.load_autoconfig(False)

# Additional arguments to pass to Qt, without leading `--`. With
# QtWebEngine, some Chromium arguments (see
# https://peter.sh/experiments/chromium-command-line-switches/ for a
# list) will work.
# Type: List of String
c.qt.args = ['enable-gpu-rasterization', 'enable-accelerated-video-decode',
             'ignore-gpu-blocklist', 'use-gl=egl', 'enable-native-gpu-memory-buffers']


c.auto_save.session = True

# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')

config.set('content.cookies.accept', 'all', 'devtools://*')

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
config.set('content.headers.user_agent',
           'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent',
           'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version} Edg/{upstream_browser_version}', 'https://accounts.google.com/*')

config.set('content.headers.user_agent',
           'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

c.content.blocking.method = 'both'

# Load images automatically in web pages.
# Type: Bool
config.set('content.images', True, 'chrome-devtools://*')

# Load images automatically in web pages.
# Type: Bool
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
# Type: Bool
c.content.javascript.enabled = True

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome-devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Allow websites to show notifications.
# Type: BoolAsk
# Valid values:
#   - true
#   - false
#   - ask
config.set('content.notifications.enabled', False, 'https://6.mediainformer.click')

# Which unbound keys to forward to the webview in normal mode.
# Type: String
# Valid values:
#   - all: Forward all unbound keys.
#   - auto: Forward unbound non-alphanumeric keys.
#   - none: Don't forward any keys.
c.input.forward_unbound_keys = 'auto'

# Leave insert mode if a non-editable element is clicked.
# Type: Bool
c.input.insert_mode.auto_leave = False

c.spellcheck.languages = ['en-US']

# Page to open if :open -t/-b/-w is used without URL. Use `about:blank`
# for a blank page.
# Type: FuzzyUrl
c.url.default_page = 'https://start.duckduckgo.com/'

c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}', 'aur': 'https://aur.archlinux.org/packages/?O=0&K={}', 'aw': 'https://wiki.archlinux.org/?search={}',
                       'gl': 'https://www.google.com/search?hl=en&q={}', 'hub': 'https://github.com/search?q={}', 'lab': 'https://gitlab.com/search?search={}', 'yt': 'https://www.youtube.com/results?search_query={}'}

# Page(s) to open at the start.
# Type: List of FuzzyUrl, or FuzzyUrl
c.url.start_pages = 'https://start.duckduckgo.com'

c.bindings.key_mappings = {'<Ctrl+6>': '<Ctrl+^>', '<Ctrl+Enter>': '<Ctrl+Return>',
                           '<Ctrl+[>': '<Escape>', '<Ctrl+j>': '<Return>', '<Ctrl+m>': '<Return>', '<Enter>': '<Return>', '<Shift+Enter>': '<Return>', '<Shift+Return>': '<Return>'}

# Bindings for normal mode
config.bind(',M', 'hint links spawn vlc {hint-url}')
config.bind(',m', 'spawn vlc {url}')
config.bind(',z', 'hint links spawn st -e youtube-dl {hint-url}')
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xt', 'config-cycle tabs.show always never')
config.bind(',p', 'spawn --userscript qute-pass --dmenu-invocation dmenu')
config.bind(
    ',P', 'spawn --userscript qute-pass --dmenu-invocation dmenu --password-only')
# config.bind('xx', 'config-cycle tab.show always never')

# config.bind(
# ',d', 'config-cycle content.user_stylesheets "~/.config/qutebrowser/styles/gruvbox-all-sites.css ~/.config/qutebrowser/styles/solarized-dark-all-sites.css "')
config.bind(',D', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/solarized-dark-all-sites.css ""')
config.bind(
    ',a', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/apprentice-all-sites.css ""')
config.bind(
    ',A', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/darculized-all-sites.css ""')
# config.set("colors.webpage.darkmode.enabled", True)
config.bind(
    ',d', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/gruvbox-all-sites.css ""')
