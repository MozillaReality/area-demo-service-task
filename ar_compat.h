/*
 *  ar_compat.h
 *  artoolkitX
 *
 *  This file is part of artoolkitX.
 *
 *  artoolkitX is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  artoolkitX is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with artoolkitX.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  As a special exception, the copyright holders of this library give you
 *  permission to link this library with independent modules to produce an
 *  executable, regardless of the license terms of these independent modules, and to
 *  copy and distribute the resulting executable under terms of your choice,
 *  provided that you also meet, for each linked independent module, the terms and
 *  conditions of the license of that module. An independent module is a module
 *  which is neither derived from nor based on this library. If you modify this
 *  library, you may extend this exception to your version of the library, but you
 *  are not obligated to do so. If you do not wish to do so, delete this exception
 *  statement from your version.
 *
 *  Copyright 2020 Mozilla.
 *
 *  Author(s): Philip Lamb
 *
 */

// This file provides some basic compatibility with constructs usually
// implemented in <ARX/AR/ar.h> and friends.

#ifndef __ar_compat_h__
#define __ar_compat_h__

#define AR_HEADER_VERSION_MAJOR 1
#define AR_HEADER_VERSION_MINOR 0
#define AR_HEADER_VERSION_TINY 0
#define AR_HEADER_VERSION_DEV 0

#define ARLOGe(...) fprintf(stderr, "[error] " __VA_ARGS__)
#define ARLOGw(...) fprintf(stderr, "[warning] " __VA_ARGS__)
#define ARLOGi(...) fprintf(stderr, "[info] " __VA_ARGS__)
#ifdef DEBUG
#  define ARLOGd(...) fprintf(stderr, "[debug] " __VA_ARGS__)
#else
#  define ARLOGd(...)
#endif

#ifdef __EMSCRIPTEN__
#  define HAVE_GLES2 1
#endif

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/*!
    @brief Underlying rendering API being used in implementation.
 */
typedef enum {
    ARG_API_None,       ///< No API currently selected.
    ARG_API_GL,         ///< OpenGL 1.5 or later.
    ARG_API_GL3,        ///< OpenGL 3.1 or later.
    ARG_API_GLES2       ///< OpenGL ES 2.0 or later.
} ARG_API;

char *arUtilGetDirectoryNameFromPath(char *dir, const char *path, const size_t n, const int addSeparator);

#ifdef __cplusplus
}
#endif
#endif // !__ar_compat_h__