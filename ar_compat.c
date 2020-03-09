/*
 *  ar_compat.c
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

#include "ar_compat.h"
#include <string.h>

char *arUtilGetDirectoryNameFromPath(char *dir, const char *path, const size_t n, const int addSeparator)
{
	char *sep;
#ifdef _WIN32
    char *sep1;
#endif
    size_t toCopy;

    if (!dir || !path || !n) return (NULL);

	sep = (char *)strrchr(path, '/');
#ifdef _WIN32
    sep1 = strrchr(path, '\\');
    if (sep1 > sep) sep = sep1;
#endif

	if (!sep) dir[0] = '\0';
    else {
        toCopy = sep + (addSeparator ? 1 : 0) - path;
        if (toCopy + 1 > n) return (NULL); // +1 because we need space for null-terminator.
        strncpy(dir, path, toCopy); // strlen(path) >= toCopy, so won't ever be null-terminated.
        dir[toCopy] = '\0';
    }
	return dir;
}

