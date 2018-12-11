function [vtx,elt] = mshReadMsh(filename)
%+========================================================================+
%|                                                                        |
%|                 OPENMSH - LIBRARY FOR MESH MANAGEMENT                  |
%|           openMsh is part of the GYPSILAB toolbox for Matlab           |
%|                                                                        |
%| COPYRIGHT : Matthieu Aussal (c) 2017-2018.                             |
%| PROPERTY  : Centre de Mathematiques Appliquees, Ecole polytechnique,   |
%| route de Saclay, 91128 Palaiseau, France. All rights reserved.         |
%| LICENCE   : This program is free software, distributed in the hope that|
%| it will be useful, but WITHOUT ANY WARRANTY. Natively, you can use,    |
%| redistribute and/or modify it under the terms of the GNU General Public|
%| License, as published by the Free Software Foundation (version 3 or    |
%| later,  http://www.gnu.org/licenses). For private use, dual licencing  |
%| is available, please contact us to activate a "pay for remove" option. |
%| CONTACT   : matthieu.aussal@polytechnique.edu                          |
%| WEBSITE   : www.cmap.polytechnique.fr/~aussal/gypsilab                 |
%|                                                                        |
%| Please acknowledge the gypsilab toolbox in programs or publications in |
%| which you use it.                                                      |
%|________________________________________________________________________|
%|   '&`   |                                                              |
%|    #    |   FILE       : mshReadMsh.m                                  |
%|    #    |   VERSION    : 0.42                                          |
%|   _#_   |   AUTHOR(S)  : Matthieu Aussal                               |
%|  ( # )  |   CREATION   : 14.03.2017                                    |
%|  / 0 \  |   LAST MODIF : 14.03.2018                                    |
%| ( === ) |   SYNOPSIS   : Read .msh files (particle, edge, triangular   |
%|  `---'  |                and tetrahedral                               |
%+========================================================================+

% Open
fid = fopen(filename,'r');
if( fid==-1 )
    error('mshReadMsh.m : cant open the file');
end

% Read header -> nodes
str = fgets(fid);
while ~contains(str,'$Nodes')
    str = fgets(fid);
end

% Nodes
Nvtx = str2double(fgets(fid));
vtx  = zeros(Nvtx,3);
for i = 1:Nvtx
    tmp      = str2num(fgets(fid));
    vtx(i,:) = tmp(2:4);
end

% Verify nodes ending
str = fgets(fid);
if ~contains(str,'$EndNodes')
    error('mshReadMsh.m : unavailable case');
end

% Nodes -> Elements
str = fgets(fid);
while ~contains(str,'$Elements')
    str = fgets(fid);
end

% Elements (up to tetra)
Nelt = str2double(fgets(fid));
elt  = zeros(Nelt,4);
for i = 1:Nelt
    tmp = str2num(fgets(fid));
    if (tmp(2) == 15) % particles
        elt(i,1) = tmp(6);
    elseif (tmp(2) == 1) % segment
        elt(i,1:2) = tmp(6:7);
    elseif (tmp(2) == 2) % triangles
        elt(i,1:3) = tmp(6:8);
    elseif (tmp(2) == 4) % tetrahedra
        elt(i,1:4) = tmp(6:9);
    end
end

% Verify elements ending
str = fgets(fid);
if ~contains(str,'$EndElements')
    error('mshReadMsh.m : unavailable case');
end

% Only keep higher element 
ord = sum(elt>0,2);
dim = max(ord);
elt = elt(ord==dim,1:dim);

% Close file
fclose(fid);
end
