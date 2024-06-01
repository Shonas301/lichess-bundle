file_name=`basename $0`
bundle_dir=`dirname $(readlink -f ${file_name})`
source "${bundle_dir}/.colors.sh"
li_dir=`pwd`
local_url="http://localhost:9663/"

function check_mongo {
    if ! pgrep aux -x "mongod" > /dev/null ; then
        err_print "MongoDB is required"
        exit 0
    fi
}

function check_redis {
    if ! pgrep aux -x "redis" > /dev/null; then
        err_print "redis is required"
        exit 0
    fi
}

function checks {
    check_mongo
    check_redis
}

function wait_for_lichess {
    until curl --output /dev/null --silent --head --fail $local_url; do
        printf '.'
        sleep 5
    done
    printf '\n'
}

function start_lichess {
    cd $li_dir
    cd $li_dir/lila
    building_print "building UI"
    ./ui/build &> /dev/null
    building_print "compiling lila"
    sbt compile &> /dev/null
    starting_print "starting lila"
    sbt run &>/dev/null &
    wait_for_lichess
}

function start_lila_ws {
   cd $li_dir/lila-ws
   starting_print "starting websockets"
   sbt run -Dcsrf.origin=http://localhost:9663 &>/dev/null &
   sleep 15
   running_print "websockets ready"
}

function start_fishnet {
    backlog="1"
    endpoint="http://localhost:9663/fishnet/"
}

function catch_trap {
    err_print "exit with SIGTERM"
    trap 'trap - INT TERM; kill -s TERM -- -$$' INT TERM
}

function wait_for_trap {
    echo "${running_col}Lichess ready at: ${local_url}"
    tail -f /dev/null & wait
    exit 0
}

function run {
    checks
    catch_trap
    start_lichess
    start_lila_ws
    wait_for_trap
}

run
