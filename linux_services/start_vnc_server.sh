#!/bin/bash
chkconfig: 2345 20 80
# description: VNC Server service

start() {
    # code to start app comes here
	vncserver -geometry 1920x1080 -depth 24
}

stop() {
    # code to stop app comes here
	ps -ef | grep vnc | grep -v grep | awk '{ print $9 }' | xargs -t -L 1 -r vncserver -kill
}

case "$1" in
    start)
       start
       ;;
    stop)
       stop
       ;;
    restart)
       stop
       start
       ;;
    status)
	# code to check status of app comes here
       # example: status program_name
	echo "Service is running... heh ;)"
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0

