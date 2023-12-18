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

#ifndef _PGFLAGS_H
#define _PGFLAGS_H

#define PML4_PWT 1<<3
#define PML4_PCD 1<<4

#define PML4E_P 1<<0 
#define PML4E_RW 1<<1 
#define PML4E_US 1<<2 
#define PML4E_PWT 1<<3 
#define PML4E_PCD 1<<4 
#define PML4E_A 1<<5 
#define PML4E_R 1<<11 
#define PML4E_XD 1<<63 

#define PDPTE_P 1<<0
#define PDPTE_RW 1<<1
#define PDPTE_US 1<<2
#define PDPTE_PWT 1<<3
#define PDPTE_PCD 1<<4
#define PDPTE_A 1<<5
#define PDPTE_D 1<<6
#define PDPTE_PS 1<<7
#define PDPTE_G 1<<8
#define PDPTE_R 1<<11
#define PDPTE_PROT 1<<59
#define PDPTE_XD 1<<63

#define PDE_P 1<<0 
#define PDE_RW 1<<1 
#define PDE_US 1<<2 
#define PDE_PWT 1<<3 
#define PDE_PCD 1<<4 
#define PDE_A 1<<5 
#define PDE_D 1<<6
#define PDE_PS 1<<7 
#define PDE_R 1<<11
#define PDE_XD 1<<63

#define PTE_P 1<<0 
#define PTE_RW 1<<1 
#define PTE_US 1<<2 
#define PTE_PWT 1<<3 
#define PTE_PCD 1<<4 
#define PTE_A 1<<5 
#define PTR_D 1<<6
#define PTE_PAT 1<<7 
#define PTE_G 1<<8
#define PTE_R 1<<11
#define PTE_PK 1<<59
#define PTE_XD 1<<63


#endif