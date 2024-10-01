cmake_minimum_required(VERSION 3.18)

project(igraph-wasm-build)

set(IGRAPH_VERSION "0.10.13" CACHE STRING "igraph version to build")

set(HASH_0.10.13 c6dc44324f61f52c098bedb81f6a602365d39d692d5068ca4fc3734b2a15e64c)
set(HASH_0.10.6 99bf91ee90febeeb9a201f3e0c1d323c09214f0b5f37a4290dc3b63f52839d6d)
set(HASH_0.10.2 2c2b9f18fc2f84b327f1146466942eb3e3d2ff09b6738504efb9e5edf2728c83)
set(HASH_0.9.4  a3285cccf4f043c9ced2bc8d8d2609ff8398cb92ed49fdf86264ed91929137dd)

# Building the arith.h file.
set(MANUAL_ARITH_H FALSE CACHE BOOL "manually create arith.h")
if (MANUAL_ARITH_H) 
    set(ARITH_DIR "${CMAKE_CURRENT_BINARY_DIR}/igraph")
    set(ARITH_H_PATH "${ARITH_DIR}/arith.h")
    if(NOT EXISTS ${ARITH_H_PATH})
        file(MAKE_DIRECTORY ${ARITH_DIR})
        if(NOT EXISTS "${ARITH_DIR}/arithchk.c")
            file(DOWNLOAD https://raw.githubusercontent.com/igraph/igraph/${IGRAPH_VERSION}/vendor/f2c/arithchk.c "${ARITH_DIR}/arithchk.c")
        endif()
        execute_process(COMMAND ${CMAKE_C_COMPILER} arithchk.c -lm -DNO_FPINIT -o arithchk.js WORKING_DIRECTORY ${ARITH_DIR})
        execute_process(COMMAND touch package.json WORKING_DIRECTORY ${ARITH_DIR}) # override the top-level package.json, which causes module-related problems.
        execute_process(COMMAND node arithchk.js OUTPUT_FILE arith.h WORKING_DIRECTORY ${ARITH_DIR})
        execute_process(COMMAND rm package.json WORKING_DIRECTORY ${ARITH_DIR}) # mopping up
    endif()
    set(F2C_EXTERNAL_ARITH_HEADER ${ARITH_H_PATH} CACHE FILEPATH "" FORCE)
endif()

include(FetchContent)
FetchContent_Declare(
  igraph 
  URL https://github.com/igraph/igraph/releases/download/${IGRAPH_VERSION}/igraph-${IGRAPH_VERSION}.tar.gz
  URL_HASH SHA256=${HASH_${IGRAPH_VERSION}}
)
FetchContent_Populate(igraph)

# Some of the older versions of igraph trip warning in newer version of clang,
# so we just forcibly disable them. We can't really do much about it anyway.
set(IGRAPH_WARNINGS_AS_ERRORS OFF CACHE BOOL "" FORCE)

add_subdirectory(${igraph_SOURCE_DIR})
