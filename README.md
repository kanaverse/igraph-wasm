# Compiling the igraph C library to WebAssembly

## Overview

This repository compiles the [**igraph** C library](https://igraph.org/c/) to Wasm binaries that can be quickly linked to other object files.
The aim is to avoid a tedious re-compilation process for each individual Wasm project,
especially when only a small part of **igraph**'s functionality is required.
For example, compiling **igraph** takes up over half of the build time of [**scran.js**](https://github.com/kanaverse/scran.js),
so providing prebuilt binaries can greatly streamline the CI/CD iterations.

Usage of these binaries implies acceptance of the **igraph** license,
see [here](https://github.com/igraph/igraph) for more details.

## Quick start

Developers can fetch the `libigraph.a` static library from the [Releases](https://github.com/kanaverse/igraph-wasm/releases) page along with the required headers.
This contains the contents of the directory created by running `make install` in the **igraph** build directory.
We also add our own `CMakeLists.txt` for convenient linking with CMake's `FetchContent`:

```
FetchContent_Declare(
  igraph
  URL https://github.com/kanaverse/igraph-wasm/releases/download/v0.1.1_3.1.25/igraph-0.9.4-wasm.tar.gz
  URL_HASH SHA256=efe59e45472c04b51eee73bc950e5cbcb2d67e859fe93bab927188b3f31cb18f
)
FetchContent_MakeAvailable(igraph)

# Simply link igraph-wasm to your target:
target_link_libraries(my_exe igraph)
```

## Versioning

We use several types of version numbers.

- Most obviously, the version of the **igraph** C library itself is recorded in the name of the release tarball. 
- The version of Emscripten used to compile the library is recorded in the second half of the tag name corresponding to the release.
  Different Emscripten versions are not necessarily ABI-compatible, so best results are obtained by picking the same Emscripten version that is used for the to-be-linked project.
- The version of this repository is recorded in the first half of the tag name.
  Different versions of this repository may use different configurations for Wasm compilation.

So, for example, a tag name with `v0.1.0_3.1.25` means that version `v0.1.0` of this repository was compiled with Emscription 3.1.25.
This may then be associated with multiple tarballs for different versions of the **igraph** C library.

## See also

This setup was inspired by the [libhdf5-wasm](https://github.com/usnistgov/libhdf5-wasm) repository, which does the same thing for the HDF5 library.
