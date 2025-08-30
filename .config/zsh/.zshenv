# Ensure XDG directories are set
: ${XDG_CONFIG_HOME:="$HOME/.config"}
: ${XDG_CACHE_HOME:="$HOME/.cache"}
: ${XDG_DATA_HOME:="$HOME/.local/share"}
: ${XDG_STATE_HOME:="$HOME/.local/state"}

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

# Global defaults
export EDITOR="editor"
export MANPAGER="nvim +Man!"
export VISUAL="editor"
export GST_VAAPI_ALL_DRIVERS=1
export SCLANG_LSP_ENABLE=1

# Not in a Wayland session, apply your flags here
if [[ -z "$WAYLAND_DISPLAY" ]]; then
    export AWT_TOOLKIT="MToolkit"
fi

# CONFIG & PATHS - group related variables

# Zinit configuration
export ZINIT_HOME="${HOME}/.local/share/zinit"
export ZINIT_BIN="${ZINIT_HOME}/zinit.git"

export VK_LAYER_PATH="/usr/share/vulkan/explicit_layer.d/"

# CONFIG & PATHS
# Development tools
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export PERL5LIB="$XDG_DATA_HOME/perl/lib/perl5${PERL5LIB:+:$PERL5LIB}"
export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl${PERL_LOCAL_LIB_ROOT:+:$PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT='--install_base ~/.local/share/perl'
export PERL_MM_OPT='INSTALL_BASE=~/.local/share/perl'
export PERL_CPANM_HOME="$XDG_DATA_HOME/cpan"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export PYTHONHISTFILE="$XDG_DATA_HOME/python_history"

# Build tools
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export CONAN_USER_HOME="$XDG_DATA_HOME/conan"
export PLATFORMIO_CACHE_DIR="$XDG_CACHE_HOME/platformio"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export PLATFORMIO_GLOBALLIB_DIR="$XDG_DATA_HOME/platformio"
export PLATFORMIO_PACKAGES_DIR="$XDG_DATA_HOME/platformio/packages"
export PLATFORMIO_PLATFORMS_DIR="$XDG_DATA_HOME/platformio/platforms"

# Android/Java
export ANDROID_DATA="$XDG_DATA_HOME/android"
export ANDROID_NDK="/opt/android-ndk"
export ANDROID_NDK_HOME="/opt/android-ndk"
export ANDROID_SDK_ROOT="/opt/android-sdk"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"
export JDK_JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_OPTS="-Djdk.xml.totalEntitySizeLimit=5000000 -Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"

# Emscripten
export EMSDK="$HOME/Repositories/libraries/emsdk"
export EM_CONFIG="$EMSDK/.emscripten"
export EM_NODE="$EMSDK/node/14.8.2_64bit/bin/node"

# History files
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export GDBHISTFILE="$XDG_DATA_HOME/gdb/history"
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"

# Cache directories
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PUB_CACHE="$XDG_CACHE_HOME/pub"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"

# Unreal Engine
export UE_DDC_DIR=$XDG_CACHE_HOME/Unreal/DerivedDataCache
export uebp_FinalLogFolder="$XDG_DATA_HOME/Unreal"
export uebp_LogFolder="$XDG_DATA_HOME/Unreal"

# CUSTOM PATH ENVS
export CWORK="$HOME/Workspaces/cpp"
export PG_OF_PATH="$HOME/Repositories/libraries/openFrameworks"
export WORKSPACE="$HOME/Workspaces/"

# Miscellaneous
export CHROME_EXECUTABLE="/usr/bin/brave"
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export NMBGIT="$XDG_DATA_HOME/notmuch/nmbug"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export PASSWORD_STORE_DIR="$HOME/.local/share/pass"
export SSB_HOME="$XDG_DATA_HOME/zoom"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export WINEPREFIX="/storage/Wine/default/"

# More efficient PATH manipulation
typeset -U PATH path # Ensures PATH has unique entries
path=(
    "$HOME/.local/bin"
    "$HOME/.local/bin/scripts"
    "$XDG_DATA_HOME/cargo/bin"
    "$XDG_DATA_HOME/npm/bin"
    "$XDG_DATA_HOME/go/bin"
    "$XDG_DATA_HOME/gem/bin"
    "$XDG_DATA_HOME/gem/ruby/3.0.0/bin"
    "$XDG_DATA_HOME/perl/bin"
    "$EMSDK"
    "$EMSDK/upstream/emscripten"
    "/opt/unreal-engine/Engine/Binaries/Linux"
    "/opt/unreal-engine/Engine/Build/BatchFiles/"
    "/opt/unreal-engine/Engine/Build/BatchFiles/Linux"
    $path
)
export PATH
