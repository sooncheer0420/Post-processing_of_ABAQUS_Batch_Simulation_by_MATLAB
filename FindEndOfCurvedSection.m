function  [resultrecordfnum,resultrecordbnum]=FindEndOfCurvedSection(k11,k12,x10,y10,nodelist3d1,nodelist3d2,nodelist3d3,numlinenodes)
%%%%resultrecordfnum: Indicates the junction point between the extracted front-end curved section and the straight pipe section (the front refers to the relationship between the serial numbers)
%%%%resultrecordbnum


        dischange1=5;%%%%The amount of 'dischange' used to extract the reference 'curv' value (that is, the number of points across the sequence number)
        dischange2=5;
        
          [curpointnum1,mindist1,nn1]=getcurpoint(k11,k12,x10,y10,nodelist3d2);    %%%%The center point is obtained by using the point set before springback (ie after bending) as a reference 
            %Radius of curvature of the center point (intersection of angle bisectors)
           
           [curvcentral,~]=getcurcircle3d(nodelist3d2,curpointnum1,dischange1);%Taking the curvature of the center point as the standard, multiplied by the coefficient to determine whether it is in a straight tube section or a curved tube section
             % Seek the front-end (pre-order) first
             % Radius of curvature of the extreme point
            curpointnum0=10;%%%%%Iterate from 10 (to prevent the edge from existing)
            
            
            %%%%initialize the two endpoints of the iterative dichotomy
            curvp1=curpointnum0;
            curvp2=curpointnum1;%%%%%%% The intersection point of the angle bisector corresponding to the serial number 2
            %%%%初始化迭代停止条件
            limit1=2*curvcentral;%%%%% less than limit1 belongs to the ideal bent-tube range
            limit2=3*curvcentral;%%%%%%
  %% Finding the first turning point
            aaaaa=0;
            bbbbb=0;
            
            for iii=1:1000
                if iii>=2
                    if curv3>limit2
                        curvp1=curvp3(iii-1);%% indicates that there is still a straight tube section, so update the straight pipe section
                    elseif curv3<limit1
                        curvp2=curvp3(iii-1);%%T still in the bent
                    else
                        ccccc=1;
                        recordfnum=curvp3(iii-1);
                        break
                    end
                end
                
                if iii>7  
                    if curvp3(iii-1)==curvp3(iii-2)&&curvp3(iii-2)==curvp3(iii-3)      %%% In order to deal with the situation that the iteration cannot be terminated at the target point due to insufficient point cloud density
                        ddddd=1;
                        recordfnum=curvp3(iii-1);
                        break
                    end
                end
                

                
                [curv1,~]=getcurcircle3d(nodelist3d2,curvp1,dischange2);                
                [curv2,~]=getcurcircle3d(nodelist3d2,curvp2,dischange2);
                
                
                if  curv1<=limit2&&curv1>=limit1 % the case where curv1 satisfies the condition
                    aaaaa=1;
                else
                    aaaaa=0;
                end
                
                if  curv2<=limit2&&curv2>=limit1  
                    bbbbb=1;
                else
                    bbbbb=0;
                end
                
                if aaaaa==1 % As long as the conditions are met, it can be recorded, and the records of a are recorded first.
                    recordfnum=curvp1;
                    break
                elseif bbbbb==1
                    recordfnum=curvp2;
                    break
                else
                    curvp3(iii)=round((curvp1+curvp2)/2);                    
                    [curv3,~]=getcurcircle3d(nodelist3d2,curvp3(iii),dischange2);
                end
                

            end
            
   %% The search for another turning point
            %Radius of curvature of the center point (intersection of angle bisectors)
            curvp3=[];
            
  
            curpointnum5=numlinenodes-10;
            
            curvp5=curpointnum5;
            curvp2=curpointnum1;
            
            aaaaa=0;
            bbbbb=0;
            
            for iiii=1:1000
                
                if iiii>=2
                    if curv3>limit2
                        curvp5=curvp3(iiii-1);
                    elseif curv3<limit1
                        curvp2=curvp3(iiii-1);
                    else
                        ccccc2=1;
                        recordbnum=curvp3(iiii-1);
                        break
                    end
                end
                
                if iiii>=7
                    if curvp3(iiii-1)==curvp3(iiii-2)&&curvp3(iiii-2)==curvp3(iiii-3)
                        ddddd2=1;
                        recordbnum=curvp3(iiii-1);
                        break
                    end
                end
               
                [curv5,~]=getcurcircle3d(nodelist3d2,curvp5,dischange2);                
                [curv6,~]=getcurcircle3d(nodelist3d2,curvp2,dischange2);              
                
                if  curv5<=limit2&&curv5>=limit1  
                    aaaaa2=1;
                else
                    aaaaa2=0;
                end
                
                if  curv2<=limit2&&curv2>=limit1  
                    bbbbb2=1;
                else
                    bbbbb2=0;
                end
                
                if aaaaa2==1  %
                    recordbnum=curvp5;
                    break
                elseif bbbbb2==1
                    recordbnum=curvp2;
                    break
                else
                    curvp3(iiii)=round((curvp5+curvp2)/2);
                    [curv3,~]=getcurcircle3d(nodelist3d2,curvp3(iiii),dischange2);
                end
                
                
                
            end % Dichotomy Iteration
            
resultrecordbnum=recordbnum;
resultrecordfnum=recordfnum;

end