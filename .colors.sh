building_col="\033[1;34m"
starting_col="\033[1;35m"
running_col="\033[0;32m"
error_col="\033[0;31m"
nc='\033[0m' # No Color

function building_print {
    echo "${building_col}$1${nc}"
}

function running_print {
    echo "${running_col}$1${nc}"
}

function starting_print {
    echo "${starting_col}$1${nc}"
}

function running_print {
    echo "${starting_col}$1${nc}"
}

function err_print {
    echo "${error_col}$1${nc}"
}
