function  [curpointnum,mindist,nn]=getcurpoint(k1,k2,x0,y0,lineymin_node3)


 % find the angle bisector
        %k1,k2: the slope of the tangent on both sides
        %x0,y0: tangent intersection
        
        syms k
        eq1 = ((k-k1)/(1+k1*k))+((k-k2)/(1+k2*k))==0;
        [k] = solve(eq1,k);
        k=double(k);
        kc=max(k);
%%%%%Since the sampling of angle is not greater than 180, the angle bisector should be positive
        bc=y0-kc*x0;
       
        yc=0;
        zc=kc*yc+bc;
        

        %%%%%%%%%%%%%%%% Iteration to find the intersection of angle bisectors
         %%% coordinates of two points on the line
        
        Q1=[x0 y0];%% first point, intersection
        Q2=[yc zc];%%The second point, just use the zero point
     %%%initialization
        curp=[lineymin_node3(1,2) lineymin_node3(1,3)];
        curdist = abs(det([Q2-Q1;curp-Q1]))/norm(Q2-Q1);
        mindist=curdist;
        curpointnum=1;
        nn=0;
        
        framemax=size(lineymin_node3(:,1),1);
        for framenum=1:framemax     
            curp=[lineymin_node3(framenum,2) lineymin_node3(framenum,3)];
            curdist=abs(det([Q2-Q1;curp-Q1]))/norm(Q2-Q1);          
            if curdist<mindist
                mindist=curdist;
                curpointnum=framenum;
                nn=nn+1;
            end
        end

end