function Pr=rot3d(P,origin,dirct,theta)
% Revolve the coordinate point P, pass the origin point, a straight line with the direction of dirct, and rotate the theta angle
% P：The set of markers that need to be rotated, an n×3 matrix
% origin：The point the reel passes through, a 1×3 vector
% direct：Rotation axis direction vector, 1×3 vector
% theta：Rotation angle, in radians
%
% reference:
% By LaterComer  
% http://www.matlabsky.com


dirct=dirct(:)/norm(dirct);

A_hat=dirct*dirct';

A_star=[0,       -dirct(3),    dirct(2)
       dirct(3),       0,    -dirct(1)
      -dirct(2),  dirct(1),        0];
I=eye(3);
M=A_hat+cos(theta)*(I-A_hat)+sin(theta)*A_star;
origin=repmat(origin(:)',size(P,1),1);
Pr=(P-origin)*M'+origin;