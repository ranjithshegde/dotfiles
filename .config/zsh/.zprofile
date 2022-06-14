xrandr --dpi 96 &
nitrogen --force-setter=xinerama --restore &
picom &

#USE VCPKG HEADERS
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/vcpkg/installed/x64-linux/include/
export C_INCLUDE_PATH=$C_INCLUDE_PATH:/opt/vcpkg/installed/x64-linux/include/

append_lib() {
	case ":$LIBRARY_PATH:" in
		*:"$1":*) ;;

		*)
			LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$1"
			;;
	esac
}

for line in $(cat /etc/ld.so.conf.d/*.conf); do
	append_lib "$line"
done

unset -f append_lib
export LIBRARY_PATH
