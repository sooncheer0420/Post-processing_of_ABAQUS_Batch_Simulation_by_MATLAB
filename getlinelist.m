function  [linerowmark,crossnode]=getlinelist(nodelist1)
%%%%%nodelist1表示直管段的数据点集合，以做标定用
%%%%%linerowmark,crossnode分别表示分类后的序号以及截面上的点数量

%%%%%nodelist1: The set of data points of the straight tube section for calibration
%%%%%linerowmark, crossnode: Represent the sorted serial number and the number of points on the section, respectively 

    x=roundn(nodelist1(:,1),-2);
    y=roundn(nodelist1(:,2),-2);
    z=roundn(nodelist1(:,3),-2);
    
    zmin=min(z);
    zmax=max(z);
    [row,~]=find(z==zmin);
    crossnode=size(row,1);% find the number of points on the section where z is equal to 0
    
    %%%% y sort
    yy=y(row);
    yinorder=sort(yy,'ascend');
    yunique=unique(yinorder);
    ynumber=size(yunique,1);
    
    
    for i=1:ynumber
        % At this time, the i-th y-coordinate value is ynique(i)
        [linerowy,~]=find(y==yunique(i));%%%%%%linerowy is the pointer corresponding to y, but there are two lines
        
        linerowynum=size(linerowy,1);
        if linerowynum<10
            ynumber=ynumber;
            % There is an interference item (caused by noise) that affects the normal progress of sorting according to y, skip it directly
        else
            
            %%%%
            xx=x(linerowy);
            xinorder_y=sort(xx,'ascend');
            xunique=unique(xinorder_y);
            xuniquesize=size(xunique,1);%% There may be four in the fourth column
            
            if xuniquesize>1
                xmin_in_linerowy=xunique(1);
                xmax_in_linerowy=xunique(2);
                judgemark=abs(xunique(1)-xunique(2));
            else
                xmin_in_linerowy=xunique(1);
                xmax_in_linerowy=xmin_in_linerowy;
            end
            
            [linerowxmin1,~]=find(x==xmin_in_linerowy);%%%%%% linerow2 x minimum value pointer, but with two lines
            [linerowxmax1,~]=find(x==xmax_in_linerowy);
            
            linerowmarkprocess1=intersect(linerowxmin1,linerowy);
            linerowmarkprocess2=intersect(linerowxmax1,linerowy);
            
            if xuniquesize>1&&judgemark<1e-3
                linerowmarkprocess3=[linerowmarkprocess1;linerowmarkprocess2];
                linerowmark1(:,(2*i)-1)=linerowmarkprocess3;
                linerowmark1(:,2*i)=linerowmarkprocess3;
            else
                linerowmark1(:,(2*i)-1)=intersect(linerowxmin1,linerowy);
                linerowmark1(:,2*i)=intersect(linerowxmax1,linerowy);
            end
            
            
        end
    end
    
    linerowmarkprocess11=linerowmark1';
    linerowmarkprocess22=unique(linerowmarkprocess11,'rows','stable');
    linerowmark=linerowmarkprocess22';%%%% If there is y in the x direction, the same column phenomenon that does not repeat should be eliminated
    linerowmark=linerowmark(:,any(linerowmark));%% remove all zero lines due to skipping

end