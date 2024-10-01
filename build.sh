#!/bin/bash

VERSIONS=(0.10.13)

for v in ${VERSIONS[@]}
do
    args="-DIGRAPH_VERSION=${v} -DCMAKE_INSTALL_PREFIX=release-${v} -DCMAKE_BUILD_TYPE=Release"
    if [[ ${v} == "0.9.4" ]]
    then
        args="${args} -DMANUAL_ARITH_H=1"
    fi

    rm -rf build-${v}
    emcmake cmake -S . -B build-${v} ${args}

    rm -rf release-${v}
    (cd build-${v} && emmake make install)

    cp CMakeLists_dist.txt release-${v}/CMakeLists.txt
    (cd release-${v} && tar -czvf ../igraph-${v}-wasm.tar.gz *)
done
