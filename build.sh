#!/bin/bash

OPTIONS="-s USE_ZLIB=1 -s USE_LIBJPEG=1 -s USE_LIBPNG=1 -s USE_FREETYPE=1 -s USE_PTHREADS=1"
#OPTIONS="${OPTIONS} -s ALLOW_MEMORY_GROWTH=1 -s WASM_MEM_MAX=512MB --no-heap-copy" 
OPTIONS="${OPTIONS} -s TOTAL_MEMORY=256MB"
OPTIONS="${OPTIONS} -s FULL_ES2=1 -s FULL_ES3=1"
OPTIONS="${OPTIONS} -s MIN_WEBGL_VERSION=2 -s MAX_WEBGL_VERSION=2"
OPTIONS="${OPTIONS} -s GL_PREINITIALIZED_CONTEXT=1"
OPTIONS="${OPTIONS} -s ENVIRONMENT=web,worker -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
emcc \
-v \
-o arosg.js \
${OPTIONS} \
-Wl,--no-check-features \
--preload-file model0.dat \
--preload-file model1.dat \
--preload-file OSG \
-I../osg-wasm/build/osg-root/include/ \
-L../osg-wasm/build/osg-root/lib/ \
-L../osg-wasm/build/osg-root/lib/osgPlugins-3.7.0/ \
-losgViewer \
-losgDB \
-losgdb_osg \
-losgdb_osg \
-losgdb_ive \
-losgdb_obj \
-losgdb_jpeg \
-losgdb_png \
-losgdb_rgb \
-losgdb_ktx \
-losgdb_deprecated_osg \
-losgdb_deprecated_osganimation \
-losgdb_serializers_osg \
-losgdb_serializers_osganimation \
-losgAnimation \
-losgGA \
-losgFX \
-losgSim \
-losgTerrain \
-losgText \
-losgVolume \
-losgUtil \
-losg \
-lOpenThreads \
mtx.c \
ar_compat.c \
arosg.cpp
