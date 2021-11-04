#!/bin/bash -e

CLANG_FORMAT_VERSION="13"

function log_() {
    echo "[$(basename "$0")] $*"
}


function install_clang(){
    log_ "Installing clang-format-$CLANG_FORMAT_VERSION"
    deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-13 main
    deb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-13 main
    apt-get update && apt-get install -y --no-install-recommends clang-format-"$CLANG_FORMAT_VERSION"
}


function clang_file() {
		
    local files=$(find ./src -regex '.*\.\(cpp\|hpp\|h\|cc\|cxx\)'  | tr '\n' ' ')

    log_ "Run running clang"
    
    /usr/bin/clang-format-${CLANG_FORMAT_VERSION} -n --Werror --style=file --fallback-style=Google ${files} || local format_status=$?
		
	if [[ "${format_status}" -ne 0 ]]; then
		log_ "Run clang-format before commit"
		return ${format_status}
	fi
	
}

cd ${GITHUB_WORKSPACE}

install_clang

clang_file || exit_code=$?

exit $exit_code 
