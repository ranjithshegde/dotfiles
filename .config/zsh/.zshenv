# .zshenv - Improved version

# Ensure XDG directories are set
: ${XDG_CONFIG_HOME:="$HOME/.config"}
: ${XDG_CACHE_HOME:="$HOME/.cache"}
: ${XDG_DATA_HOME:="$HOME/.local/share"}
: ${XDG_STATE_HOME:="$HOME/.local/state"}

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

# Default editor settings
export VISUAL="editor"
export EDITOR="editor"

# CONFIG & PATHS
export ANDROID_DATA="$XDG_DATA_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CONAN_USER_HOME="$XDG_DATA_HOME/conan"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export EMSDK="$HOME/Repositories/libraries/emsdk"
export EM_CONFIG="$EMSDK/.emscripten"
export EM_NODE="$EMSDK/node/14.8.2_64bit/bin/node"
export GDBHISTFILE="$XDG_DATA_HOME/gdb/history"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JDK_JAVA_OPTIONS='-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export NMBGIT="$XDG_DATA_HOME/notmuch/nmbug"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export OPENCV_OPENCL_DEVICE="NVIDIA:GPU:0"
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export PASSWORD_STORE_DIR="$HOME/.local/share/pass"
export PERL_CPANM_HOME="$XDG_DATA_HOME/cpan"
export PERL5LIB="$XDG_DATA_HOME/perl/lib/perl5${PERL5LIB:+:$PERL5LIB}"
export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl${PERL_LOCAL_LIB_ROOT:+:$PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT='--install_base ~/.local/share/perl'
export PERL_MM_OPT='INSTALL_BASE=~/.local/share/perl'
export PLATFORMIO_CACHE_DIR="$XDG_CACHE_HOME/platformio"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export PLATFORMIO_GLOBALLIB_DIR="$XDG_DATA_HOME/platformio"
export PLATFORMIO_PACKAGES_DIR="$XDG_DATA_HOME/platformio/packages"
export PLATFORMIO_PLATFORMS_DIR="$XDG_DATA_HOME/platformio/platforms"
export PUB_CACHE="$XDG_CACHE_HOME/pub"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYTHONHISTFILE="$XDG_DATA_HOME/python_history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"
export SCLANG_LSP_ENABLE=1
export SSB_HOME="$XDG_DATA_HOME/zoom"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export uebp_FinalLogFolder="$XDG_DATA_HOME/Unreal"
export uebp_LogFolder="$XDG_DATA_HOME/Unreal"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export WINEPREFIX="/storage/Wine/default/"
export ZPLUG_BIN="$XDG_DATA_HOME/bin"
export ZPLUG_HOME="$XDG_DATA_HOME/zsh/zplug"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"

# GLOBALS
export ANDROID_NDK="/opt/android-ndk"
export ANDROID_SDK_ROOT="/opt/android-sdk"
export ANDROID_NDK_HOME="/opt/android-ndk"
export AWT_TOOLKIT="MToolkit"
export CHROME_EXECUTABLE="/usr/bin/brave"
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
export GST_VAAPI_ALL_DRIVERS=1
export MANPAGER="nvim +Man!"
export QT_STYLE_OVERRIDE="kvantum"
export __EGL_VENDOR_LIBRARY_FILENAMES="/usr/share/glvnd/egl_vendor.d/50_mesa.json"

# CUSTOM PATH ENVS
export CWORK="$HOME/Workspaces/cpp"
export WORKSPACE="$HOME/Workspaces/"
export PG_OF_PATH="$HOME/Repositories/libraries/openFrameworks"

# Function to append to PATH if not already included
appendpath() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*) PATH="${PATH:+$PATH:}$1" ;;
	esac
}

appendpath "$HOME/.local/bin"
appendpath "$HOME/.local/bin/scripts"
appendpath "$XDG_DATA_HOME/cargo/bin"
appendpath "$XDG_DATA_HOME/npm/bin"
appendpath "$XDG_DATA_HOME/go/bin"
appendpath "$XDG_DATA_HOME/gem/bin"
appendpath "$XDG_DATA_HOME/gem/ruby/3.0.0/bin"
appendpath "$XDG_DATA_HOME/perl/bin"
appendpath "$EMSDK"
appendpath "$EMSDK/upstream/emscripten"

unset -f appendpath
export PATH

# Function to run commands with sudo
sdo() {
	local func="$1"
	shift
	sudo zsh -c "$(declare -f $func); $func $*"
}

# Source custom scripts
source "$ZDOTDIR/functions/fuzzy.sh"
source "$ZDOTDIR/functions/power_profiles.sh"
source "$ZDOTDIR/functions/dmenus.sh"
source "$ZDOTDIR/functions/scripts.sh"
source "$ZDOTDIR/functions/dotnet.sh"
