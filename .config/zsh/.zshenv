#!/bin/sh

# [ [ -f ~/.config/env] ]&& source ~/.config/env

# Cleaning from HOME

# CONFIG & PATHS
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export EM_CACHE="$XDG_CACHE_HOME"/emscripten/cache
export EM_CONFIG="$XDG_CONFIG_HOME"/emscripten/config
export EM_PORTS="$XDG_DATA_HOME"/emscripten/cache
export GDBHISTFILE="$XDG_DATA_HOME"/gdb/history
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export MYPY_CACHE_DIR="$XDG_CACHE_HOME"/mypy
export NMBGIT="$XDG_DATA_HOME"/notmuch/nmbug
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME"/notmuch/notmuchrc
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export PASSWORD_STORE_DIR="$HOME"/.local/share/pass
export PLATFORMIO_CACHE_DIR="$XDG_CACHE_HOME"/platformio
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME"/platformio
export PLATFORMIO_GLOBALLIB_DIR="$XDG_DATA_HOME"/platformio
export PLATFORMIO_PACKAGES_DIR="$XDG_DATA_HOME"/platformio/packages
export PLATFORMIO_PLATFORMS_DIR="$XDG_DATA_HOME"/platformio/platforms
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export PYTHONHISTFILE="$XDG_DATA_HOME"/python_history
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SSB_HOME="$XDG_DATA_HOME"/zoom
export TERMINFO="$XDG_DATA_HOME"/terminfo
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export ZPLUG_BIN="$XDG_DATA_HOME"/bin
export ZPLUG_HOME="$XDG_DATA_HOME"/zsh/zplug
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export OPENCV_OPENCL_DEVICE=NVIDIA:GPU:0
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"

# CUSTOM PATH ENVS
export CWORK="$HOME"/Software/Workspaces/cpp
export WORKSPACE="$HOME"/Software/Workspaces/
export PG_OF_PATH="$WORKSPACE"openFrameworks

# Addition to path...
appendpath() {
	case ":$PATH:" in
		*:"$1":*) ;;

		*)
			PATH="${PATH:+$PATH:}$1"
			;;
	esac
}

appendpath '/home/ranjith/.local/bin'
appendpath '/home/ranjith/.local/bin/scripts'
appendpath '/home/ranjith/.local/share/cargo/bin'
appendpath '/home/ranjith/.local/share/npm/bin'
appendpath '/home/ranjith/.local/share/go/bin'
appendpath '/home/ranjith/.local/share/gem/bin'
appendpath '/home/ranjith/.local/share/gem/ruby/3.0.0/bin'
# appendpath '/usr/lib/emsdk/upstream/bin/'
# appendpath '/usr/lib/emsdk/node/12.18.1_64bit/bin'
unset -f appendpath
export PATH
