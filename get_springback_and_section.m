%% This programe can extract the springback and section information for the txt(conversed by inp)
%% Note: the inp should follow the modeling method in this git
%% This program is an example for batch extraction
%% The angle section error does not exceed 0.1¡ã
%% The angle calculation is based on vector algorithm
%% The two side-by-side iterations is adapted to limit the target to a range and then perform more accurate iteration
%% Multi-axial reference plane calibration is adapted, which can effectively prevent program bugs caused by data offset or noise when exporting from abaqus, improved program stability effectively
%% The function of axial sorting by the point before bending 

%% By Sun Chang
%% Zhejiang University
%% For any further program, contact sun_chang@zju.edu.cn

clc
clear

for num=1:2%%%for batch application, the range can be given
    %%
    clearvars -except num meanthetachange2 meanthetachange3 radiuschange meanradiushinter meanradiusbevor resultrecord6 radiuschange3 recordfnum recordbnum curpointtarget
    anglestart=41;%%%%%%angle extract from (positive integer)
    angleend=42;%%%%%%
    
    %% get node list from txt
    [nodelist1,nodelist2,nodelist3]=getnodelist(num);
    
    %% get line list
    [linerowmark,crossnode]=getlinelist(nodelist1);%%%
    numlinenodes=size(linerowmark(:,1),1);
    
    %% extract angle from every line
    % extract location from every line
    
    for lineth=1:crossnode
        %for lineth=1:1   1:crossnode-someline
        for ii=1:numlinenodes%%%%%%lineymin_node record the location of lines
            mark=linerowmark(ii,lineth);
            nodelist3d1(ii,:)=nodelist1(mark,:);
            nodelist3d2(ii,:)=nodelist2(mark,:);
            nodelist3d3(ii,:)=nodelist3(mark,:);
        end
        [anglechange,k11,k12,x10,y10]=getspringbackangle(nodelist3d1,nodelist3d2,nodelist3d3,numlinenodes);
        
        %% record springback extracted
        resultrecord(lineth)=anglechange;
        resultangle123=abs(resultrecord);
        meanthetachange3(num)=mean(resultangle123);
    end
    
    %%  extract bend point
    for lineth=1 %%
        if lineth==1
            for ii=1:numlinenodes
                mark=linerowmark(ii,lineth);
                nodelist3d1(ii,:)=nodelist1(mark,:);
                nodelist3d2(ii,:)=nodelist2(mark,:);
                nodelist3d3(ii,:)=nodelist3(mark,:);
            end
        end
    end
    
    %% check
    % take the first line as an example
    for ii=1:numlinenodes
        mark=linerowmark(ii,1);
        lineymin_node1(ii,:)=nodelist1(mark,:);
        lineymin_node2(ii,:)=nodelist2(mark,:);
        lineymin_node3(ii,:)=nodelist3(mark,:);
    end
    
    %         figure
    %         scatter3(lineymin_node1(:,1),lineymin_node1(:,2),lineymin_node1(:,3),'o')
    %         axis equal
    %         xlabel('X');
    %         ylabel('Y');
    %         zlabel('Z');
    %         hold on
    %         title('A schematic diagram of a trace imported from a point cloud before bending')
    %
    %         figure
    %         scatter3(lineymin_node2(:,1),lineymin_node2(:,2),lineymin_node2(:,3),'o')
    %         axis equal
    %         xlabel('X');
    %         ylabel('Y');
    %         zlabel('Z');
    %         hold on
    %         title('A schematic diagram of a trace imported from a point cloud after bending')
    %
    
    %%
    [recordfnum,recordbnum]=FindEndOfCurvedSection(k11,k12,x10,y10,nodelist3d1,nodelist3d2,nodelist3d3,numlinenodes);
    
    %%
    %%For n traces under each section point, extract the points under each set of traces
    %%%%%%%%%%The number of each section point and the number of each group of points need to be solved (calculate the related parameters of the line_x_axis matrix)
    numline=crossnode;
    for mm=1:numline
        for ii=1:numlinenodes
            mark2=linerowmark(ii,mm);
            line_node_bending(ii,:,mm)=nodelist2(mark2,:);
        end
    end
    %line_nodel(ii,:,mm) is the xyz three-column data of the iith point on the mmth line
    
    %%
    x=nodelist1(:,1);
    y=nodelist1(:,2);
    z=nodelist1(:,3);
    
    %% ordinal-based interpolation method
    %%Interpolation Fitting to Find Section Intersections
    %%z=nodelist2(:,3);
    
    for angle=anglestart:1:angleend
        for mmm=1:numline
            %numline
            recordx(mmm)=x(linerowmark(1,mmm),1);%%The x-coordinate of the point on the first line, the x-coordinate of this line is the same, so the first one can be used
            yy=line_node_bending(:,2,mmm);%%%%%%%%%The y coordinate of the point on the first line
            xx=line_node_bending(:,3,mmm);
            
            %xxx11=recordfnum;
            %xxx21=recordbnum;
            numofnoderange=abs(recordfnum-recordbnum);
            
            xxx1=recordfnum+1;
            xxx2=recordbnum-1;
            
            for iii=1:numofnoderange
                if iii>=2
                    if anglenow3>angle
                        xxx2=xxx3(iii-1);
                        %mmm=1+1
                    elseif anglenow3<angle
                        xxx1=xxx3(iii-1);
                    end
                end
                
                x0=0;
                y0=0;
                xinit=xx(recordfnum);
                yinit=yy(recordfnum);%%%%%
                
                %x1=xx(recordfnum);
                %y1=yy(recordfnum);%%%%%
                
                xchange1=xx(xxx1);%%%% Deviation a serial number to prevent problems with acosd
                ychange1=yy(xxx1);
                anglenow1(iii)=acosd(dot([xinit-x0,yinit-y0],[xchange1-x0,ychange1-y0])/(norm([xinit-x0,yinit-y0])*norm([xchange1-x0,ychange1-y0])));
                
                xchange2=xx(xxx2);
                ychange2=yy(xxx2);
                anglenow2(iii)=acosd(dot([xinit-x0,yinit-y0],[xchange2-x0,ychange2-y0])/(norm([xinit-x0,yinit-y0])*norm([xchange2-x0,ychange2-y0])));
                
                deta1(iii)=abs(anglenow1(iii)-angle);
                deta2(iii)=abs(anglenow2(iii)-angle);
                limiter=1;
                
                if deta1(iii)<=limiter||deta2(iii)<=limiter
                    recordlistnum(mmm)=xxx3(iii-1);
                    break
                else
                    xxx3(iii)=round((xxx1+xxx2)/2);
                    xchange3=xx(xxx3(iii));
                    ychange3=yy(xxx3(iii));
                    anglenow3=acosd(dot([xinit-x0,yinit-y0],[xchange3-x0,ychange3-y0])/(norm([xinit-x0,yinit-y0])*norm([xchange3-x0,ychange3-y0])));
                    %                     deta3(iii)=abs(anglenow3-angle);
                    %                     deta3(iii)=anglenow3-angle;
                end
            end
        end
    end
    
    %% previous version method
    %     z=nodelist2(:,3);
    %     zmin=min(z);
    %     zmax=max(z);
    for angle=anglestart:1:angleend
        for mmm=1:numline
            %numline
            recordx(mmm)=x(linerowmark(1,mmm),1);%%
            yy=line_node_bending(:,2,mmm);%%%%%%%%%
            xx=line_node_bending(:,3,mmm);
            
            %             recordlistnum(mmm)%%%
            xxrange=xx(recordlistnum(mmm)-10:recordlistnum(mmm)+10);
            yyrange=yy(recordlistnum(mmm)-10:recordlistnum(mmm)+10);
            %             xxstart2=xx(recordlistnum(mmm)+5);
            %             yystart2=yy(recordlistnum(mmm)+5);
            xxx1=xx(recordlistnum(mmm)-10);
            xxx2=xx(recordlistnum(mmm)+10);
            
            for iii=1:300
                if iii>=2
                    if anglenow32>angle
                        xxx2=xxx3(iii-1);
                        %                         mmm=1+1
                    elseif anglenow32<angle
                        xxx1=xxx3(iii-1);
                    end
                end
                fff1=interp1(xxrange,yyrange,xxx1,'linear');%spline
                fff2=interp1(xxrange,yyrange,xxx2,'linear');
                arcnow1=fff1/xxx1;
                arcnow2=fff2/xxx2;
                %                 anglenow12(iii)=rad2deg(arcnow1);
                %                 anglenow22(iii)=rad2deg(arcnow2);
                
                xchange1=xxx1;
                ychange1=fff1;
                anglenow12(iii)=acosd(dot([xinit-x0,yinit-y0],[xchange1-x0,ychange1-y0])/(norm([xinit-x0,yinit-y0])*norm([xchange1-x0,ychange1-y0])));
                
                xchange2=xxx2;
                ychange2=fff2;
                anglenow22(iii)=acosd(dot([xinit-x0,yinit-y0],[xchange2-x0,ychange2-y0])/(norm([xinit-x0,yinit-y0])*norm([xchange2-x0,ychange2-y0])));
                
                deta12(iii)=abs(anglenow12(iii)-angle);
                deta22(iii)=abs(anglenow22(iii)-angle);
                limiter=0.01;
                if deta12(iii)<=limiter||deta22(iii)<=limiter
                    recordz(mmm)=xxx3(iii-1);
                    recordy(mmm)=fff3;
                    break
                else
                    xxx3(iii)=(xxx1+xxx2)/2;
                    fff3=interp1(xxrange,yyrange,xxx3(iii),'linear');
                    arcnow3=fff3/xxx3(iii);
                    %anglenow32=rad2deg(arcnow3);
                    %deta32(iii)=abs(anglenow32-angle);
                    %
                    
                    xchange3=xxx3(iii);
                    ychange3=fff3;
                    anglenow32=acosd(dot([xinit-x0,yinit-y0],[xchange3-x0,ychange3-y0])/(norm([xinit-x0,yinit-y0])*norm([xchange3-x0,ychange3-y0])));
                    
                end
            end
            
            %%%%%%%%%
            %%%%%%%%%%%%%%%Extract the intersection point of each trace
            % ff1=interp1(xx,yy,xx,'linear');
            % figure
            % plot(xx,ff1,'bo')
            % hold on
            % plot(xx,yy,'ro');
            % hold on
            % plot(recordz,recordy,'go')
            % axis equal
            % xlabel('X');
            % ylabel('Y');
            
        end
        
        %%
        %%½á¹û
        record(:,1,angle)=recordx;
        record(:,2,angle)=recordy;
        record(:,3,angle)=recordz;
        %testx=[recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1);recordx(1)]
        figure
        scatter3(record(:,1,angle),record(:,2,angle),record(:,3,angle),'ro')
        axis equal
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title(['bent-tube Section at  ',num2str(angle), ' degrees of bent-tube',num2str(num)])
        
    end
end

