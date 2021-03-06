mkdir build -p
cd build

if [[ ${c_compiler} != "toolchain_c" ]]; then
    declare -a CMAKE_PLATFORM_FLAGS
    if [[ ${HOST} =~ .*darwin.* ]]; then
        CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
    else
        CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
    fi
fi

cmake -G "Ninja" \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D NG_INSTALL_DIR_INCLUDE=$PREFIX/include/netgen \
      -D NG_INSTALL_DIR_PYTHON=${SP_DIR} \
      -D NG_INSTALL_DIR_BIN=bin \
      -D NG_INSTALL_DIR_LIB=lib \
      -D NG_INSTALL_DIR_CMAKE=lib/cmake/netgen \
      -D NG_INSTALL_DIR_RES=share \
      -D OCC_INCLUDE_DIR=$PREFIX/include/opencascade \
      -D OCC_LIBRARY_DIR=$PREFIX/lib \
      -D USE_NATIVE_ARCH=OFF \
      -D USE_OCC=ON \
      -D USE_PYTHON=ON \
      -D USE_GUI=OFF \
      -D USE_SUPERBUILD=OFF \
      -D BUILD_WITH_CONDA=ON \
      -D DYNAMIC_LINK_PYTHON=OFF \
      ${CMAKE_PLATFORM_FLAGS[@]} \
      ..

ninja install -v

