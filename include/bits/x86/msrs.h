/*    Small Operating System
    Copyright (C) 2023 jmbert

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/

#ifndef _X86MSRS_H
#define _X86MSRS_H

#define EFER_MSR 0xC0000080

#define EFER_SCE  1 << 0
#define EFER_LME  1 << 8
#define EFER_LMA  1 << 10
#define EFER_NXE  1 << 11
#define EFER_SVME  1 << 12
#define EFER_LMSLE  1 << 13
#define EFER_FFXSR  1 << 14
#define EFER_TCE   1 << 15

#endif