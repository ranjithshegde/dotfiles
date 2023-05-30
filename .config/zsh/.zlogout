if [[ ${DISPLAY} ]]; then
    if [[ ${DESKTOP_SESSION} == "dwm" ]]; then
        systemctl --user stop redshift.service
    fi
fi
