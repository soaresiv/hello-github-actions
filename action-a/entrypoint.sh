#!/bin/bash

CLANG_FORMAT_VERSION="13"

function log_() {
    echo "[$(basename "$0")] $*"
}


function install_clang(){
    log_ "Installing clang-format-$CLANG_FORMAT_VERSION"    
    apt-get update && apt-get install -y --no-install-recommends clang-format-"$CLANG_FORMAT_VERSION"
}


function clang_file() {
	
    log_ "Run running clang on ${1}"
    
    local files=$(find ${1} -regex '.*\.\(cpp\|hpp\|h\|cc\|cxx\)'  | tr '\n' ' ')
    
    log_ "files found: ${files}"
    
    
    /usr/bin/clang-format-${CLANG_FORMAT_VERSION} -n --Werror --style=file --fallback-style=Google ${files} || local format_status=$?
		
	if [[ "${format_status}" -ne 0 ]]; then
		log_ "Run clang-format before commit"
	fi
	
	return ${format_status} 
	
}

cd ${GITHUB_WORKSPACE}

install_clang

clang_file ${GITHUB_WORKSPACE} || exit_code=$?

log_ "Job Completed"

exit $exit_code 
