#!/bin/bash
check() {
    export SCRIPT_NAME=/pingie
    export SCRIPT_FILENAME=/pingie
    export REQUEST_METHOD=GET
    timeout -k 30s -s 9 25s cgi-fcgi -bind -connect 127.0.0.1:9000 | grep -q pong
}

terminate() {
    echo "Stuck, restarting..."
    kill -s 15 1 || kill -s 9 -1
}

check || terminate
