#!/bin/bash

#
# master build script.
#
# Copyright 202020, Mozilla.
# Author(s): Philip Lamb
#

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage {
    echo "Usage: $(basename $0) [-v|--verbose] [--debug] [--memory-growth]"
    exit 1
}

# -e = exit on errors
set -e
# -x = debug
#set -x

# Parse parameters
while test $# -gt 0
do
    case "$1" in
        --debug) DEBUG=
            ;;
        --memory-growth) MEMORY_GROWTH=1
            ;;
        --verbose) VERBOSE=1
            ;;
        -v) VERBOSE=1
            ;;
        --*) echo "bad option $1"
            usage
            ;;
        *) echo "bad argument $1"
            usage
            ;;
    esac
    shift
done

#
# Various compile-time options.
#

# The wasm ports we use:
OPTIONS="-s USE_ZLIB=1 -s USE_LIBJPEG=1 -s USE_LIBPNG=1 -s USE_FREETYPE=1 -s USE_PTHREADS=1"

# In this app, fixed memory size is more performant, but you can opt for memory growth if preferred:
if [ $MEMORY_GROWTH ] ; then
    OPTIONS="${OPTIONS} -s ALLOW_MEMORY_GROWTH=1 -s WASM_MEM_MAX=512MB --no-heap-copy" 
else
    OPTIONS="${OPTIONS} -s TOTAL_MEMORY=512MB"
fi

# GL emulation options:
OPTIONS="${OPTIONS} -s FULL_ES2=1 -s FULL_ES3=1"
OPTIONS="${OPTIONS} -s MIN_WEBGL_VERSION=2 -s MAX_WEBGL_VERSION=2"
OPTIONS="${OPTIONS} -s GL_PREINITIALIZED_CONTEXT=1"

# Build as a wasm es6 module with multithreading, and ensure ccall and cwrap are kept during linking.
OPTIONS="${OPTIONS} -s ENVIRONMENT=web,worker -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"

if [ -z ${DEBUG+Debug} ]; then
    OPTIONS="${OPTIONS} -DDEBUG"
fi
if [ $VERBOSE ] ; then
    OPTIONS="${OPTIONS} -v"
fi

# This shouldn't be necessary, but the code doesn't build without it:
OPTIONS="${OPTIONS} -Wl,--no-check-features"

# Setting -g3 includes native code function names in backtraces.
# To also get source line numbers, we'd set -g4 and a value for --source-map-base like:
# -g4 --source-map-base "https://myserver.com/app_directory/"
# At present, OSG doesn't build with -g, so we can't use -g4.
OPTIONS="${OPTIONS} -g3"

SOURCES="\
mtx.c \
ar_compat.c \
arosg.cpp \
"

FILES="\
models \
fonts \
shaders \
"

OUT="arosg.js"

# Here list all the OSG libs we need. Note that if an OSG plugin is included,
# because wasm has only static linking, the OSG macro to statically load the
# plugin will need to be added to "osgPlugins.h".
OSG_VERSION="3.7.0"
OSG_ROOT="../osg-wasm/build-wasm/openscenegraph-3.7.0-wasm"
OSG_LIBS="\
osgViewer \
osgText \
osgDB \
osgdb_osg \
osgdb_gltf \
osgdb_jpeg \
osgdb_png \
osgdb_rgb \
osgdb_ktx \
osgdb_glsl \
osgdb_freetype \
osgdb_deprecated_osg \
osgdb_deprecated_osganimation \
osgdb_serializers_osg \
osgdb_serializers_osganimation \
osgAnimation \
osgGA \
osgFX \
osgSim \
osgTerrain \
osgVolume \
osgUtil \
osg \
OpenThreads \
"

# Compile sources and link.
emcc \
-o ${OUT} \
${OPTIONS} \
$(printf -- " --preload-file %s" ${FILES}) \
-I${OSG_ROOT}/include \
-L${OSG_ROOT}/lib \
-L${OSG_ROOT}/lib/osgPlugins-${OSG_VERSION} \
$(printf -- " -l%s" ${OSG_LIBS}) \
${SOURCES}


