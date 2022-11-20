#!/bin/bash

VERSIONS=(0.9.4 0.10.2)

for v in ${VERSIONS[@]}
do
    rm -rf build-${v}
    emcmake cmake -S . -B build-${v} -DIGRAPH_VERSION=${v} -DCMAKE_INSTALL_PREFIX=release-${v}

    rm -rf release-${v}
    (cd build-${v} && emmake make install)

    cp CMakeLists_dist.txt release-${v}/CMakeLists.txt
    (cd release-${v} && tar -czvf ../igraph-${v}-wasm.tar.gz *)
done
