cmake_minimum_required(VERSION 3.18)

project(igraph-wasm-build)

set(IGRAPH_VERSION "0.10.2" CACHE STRING "igraph version to build")

set(HASH_0.10.2 2c2b9f18fc2f84b327f1146466942eb3e3d2ff09b6738504efb9e5edf2728c83)
set(HASH_0.9.4  a3285cccf4f043c9ced2bc8d8d2609ff8398cb92ed49fdf86264ed91929137dd)

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
