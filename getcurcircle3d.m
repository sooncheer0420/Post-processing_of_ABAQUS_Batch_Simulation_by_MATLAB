function  [radius,centrepoint]=getcurcircle3d(nodelist3dx,curpointnum,dischange)



%%%%%%%curpointlist1: Points involved in extracting curvature
%%%%%%%nodelist3d2: Extracted data matrix 
%%%%%%%Different from the input and output parameters of 'getcurcircle1'
%%%%%%%Three-dimensional
            curpointlist1=[curpointnum-dischange,curpointnum,curpointnum+dischange];
            curpc1=[nodelist3dx(curpointlist1(1),1) nodelist3dx(curpointlist1(1),2) nodelist3dx(curpointlist1(1),3)];
            curpc2=[nodelist3dx(curpointlist1(2),1) nodelist3dx(curpointlist1(2),2) nodelist3dx(curpointlist1(2),3)];
            curpc3=[nodelist3dx(curpointlist1(3),1) nodelist3dx(curpointlist1(3),2) nodelist3dx(curpointlist1(3),3)];
%  curvcentral=getcurcircle(nodelist3dx,curpointnum1);
%Taking the curvature of the center point as the standard, multiplied by the coefficient 
%to determine whether it is in a straight section or a curved  section of the tube
            

p1=curpc1;
p2=curpc2;
p3=curpc3;
p = CircleCenter(p1, p2, p3);
radius=norm(p-p1);
centrepoint=p;
function p = CircleCenter(p1, p2, p3)
% CircleCenter(p1, p2, p3) According to the three space points, calculate the center of the circle
%   p1,p2,p3:three space points
 % normal vector of a circle
 pf= cross(p1-p2, p1-p3);

 if any(pf == 0)
     error('Three points cannot be collinear');
 end

 
 % The midpoint of two line segments, and then the mid-perpendicular line needs to be found
 p12 = (p1 + p2)/2;
 p23 = (p2 + p3)/2;

 % Find the mid-perpendicular of two lines
 p12f = cross(pf, p1-p2);
 p23f = cross(pf, p2-p3);

 % Find the size of the projection on the mid-perpendicular
 ds = ( (p12(2)-p23(2))*p12f(1) - (p12(1)-p23(1))*p12f(2) ) / ( p23f(2)*p12f(1) - p12f(2)*p23f(1) );

 % get the distance
 p = p23 + p23f .* ds;

end

end