function  [anglechange,k11,k12,x10,y10]=getspringbackangle(nodelist3d1,nodelist3d2,nodelist3d3,numlinenodes)


 %%%%k11, k12, x10, y10: respectively the slope and intersection of the tangent lines of the two straight pipe segments of the elbow before springback
   %%%%nodelist3dx: 3D point coordinate collection after linelist classification
        
% Extract the endpoint coordinates of each line
         %%%%%%% before springback
        az1=nodelist3d2(1,3);
        ay1=nodelist3d2(1,2);
        bz1=nodelist3d2(2,3);
        by1=nodelist3d2(2,2);
        cz1=nodelist3d2(numlinenodes-1,3);
        cy1=nodelist3d2(numlinenodes-1,2);
        dz1=nodelist3d2(numlinenodes,3);
        dy1=nodelist3d2(numlinenodes,2);
        %%%%%%%after springback
        az2=nodelist3d3(1,3);
        ay2=nodelist3d3(1,2);
        bz2=nodelist3d3(2,3);
        by2=nodelist3d3(2,2);
        cz2=nodelist3d3(numlinenodes-1,3);
        cy2=nodelist3d3(numlinenodes-1,2);
        dz2=nodelist3d3(numlinenodes,3);
        dy2=nodelist3d3(numlinenodes,2);
        
% find the angle
         %%%%%%%% before springback
        x1=ay1;
        y1=az1;
        x2=by1;
        y2=bz1;
        x3=cy1;
        y3=cz1;
        x4=dy1;
        y4=dz1;
       % prevent 'inf' if x is too close
        if abs(x1-x2)<1e-6
            x1=x1+1e-6;
        end
        
        if abs(x3-x4)<1e-6
            x2=x2+1e-6;
        end
        
        k1=(y1-y2)/(x1-x2);%Slope and Intercept of Tangent 1
        b1=(x1*y2-x2*y1)/(x1-x2);
        k2=(y3-y4)/(x3-x4);%Slope and Intercept of Tangent 2
        b2=(x3*y4-x4*y3)/(x3-x4);
        
        x0=(b2-b1)/(k1-k2);%find intersection
        y0=k1*x0+b1;
%find tangent angle by inner product of vectors
        thetaline1=acosd(dot([x1-x0,y1-y0],[x3-x0,y3-y0])/(norm([x1-x0,y1-y0])*norm([x3-x0,y3-y0])));
        thetacentral1=180-thetaline1;% Angle before springback
        
        x10=x0;
        y10=y0;
        k11=k1;
        k12=k2;
        
        %%%%%%%Angle after springback
        x1=ay2;
        y1=az2;
        x2=by2;
        y2=bz2;
        x3=cy2;
        y3=cz2;
        x4=dy2;
        y4=dz2;
        
        % prevent 'inf' if x is too close
        if abs(x1-x2)<1e-6
            x1=x1+1e-6;
        end
        
        if abs(x3-x4)<1e-6
            x2=x2+1e-6;
        end
        
        k1=(y1-y2)/(x1-x2);%
        b1=(x1*y2-x2*y1)/(x1-x2);
        k2=(y3-y4)/(x3-x4);%
        b2=(x3*y4-x4*y3)/(x3-x4);
        x0=(b2-b1)/(k1-k2);%
        y0=k1*x0+b1;
        
        x20=x0;
        y20=y0;
        k21=k1;
        k22=k2;
         
        %
        thetaline2=acosd(dot([x1-x0,y1-y0],[x3-x0,y3-y0])/(norm([x1-x0,y1-y0])*norm([x3-x0,y3-y0])));
        thetacentral2=180-thetaline2;
        
        %Stores the springback value for each line
        anglechange=thetacentral1-thetacentral2;

end