function mesh = mshBoundary(mesh)
%+========================================================================+
%|                                                                        |
%|                 OPENMSH - LIBRARY FOR MESH MANAGEMENT                  |
%|           openMsh is part of the GYPSILAB toolbox for Matlab           |
%|                                                                        |
%| COPYRIGHT : Matthieu Aussal (c) 2015-2017.                             |
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
%|    #    |   FILE       : mshBoundary.m                                 |
%|    #    |   VERSION    : 0.32                                          |
%|   _#_   |   AUTHOR(S)  : Matthieu Aussal                               |
%|  ( # )  |   CREATION   : 14.03.2017                                    |
%|  / 0 \  |   LAST MODIF : 05.09.2017                                    |
%| ( === ) |   SYNOPSIS   : Submesh to free boundary mesh                 |
%|  `---'  |                                                              |
%+========================================================================+

% Particles mesh
if (size(mesh.elt,2) == 1)
    error('mshBoundary.m : unavailable case')
    
% Edge mesh
elseif (size(mesh.elt,2) == 2)
    part        = mesh.prt;
    mlt         = accumarray(mesh.elt(:),1,[size(mesh.vtx,1),1]);
    elt         = find(mlt==1);
    [mesh,~,IB] = intersect(msh(mesh.vtx,elt),part);
    mesh.col    = part.col(IB);
    
% Triangular mesh
elseif (size(mesh.elt,2) == 3)
    dt          = triangulation(mesh.elt,mesh.vtx);
    [elt,vtx]   = freeBoundary(dt);
    edges       = mesh.edg;   
    [mesh,~,IB] = intersect(msh(vtx,elt),edges);
    mesh.col    = edges.col(IB);
    
% Tetrahedral mesh
elseif (size(mesh.elt,2) == 4)
    dt          = triangulation(mesh.elt,mesh.vtx);
    [elt,vtx]   = freeBoundary(dt);
    face        = mesh.fce;   
    [mesh,~,IB] = intersect(msh(vtx,elt),face);
    mesh.col    = face.col(IB);
    
else
    error('mshBoundary.m : unavailable case')
end
end
