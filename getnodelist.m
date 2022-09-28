function  [nodelist1,nodelist2,nodelist3]=getnodelist(num)
%%%%%
    
    fid1 = fopen(['tubeblank_',num2str(num),'.txt']);
%     fid1 = fopen('tube_blank.txt');
    str= fread(fid1,'*char')';
    fclose(fid1);
    idstart=findstr(str,'*Node');
    idend=findstr(str,'*Element');
    
    fid2=fopen('node_get_process1.txt','wt');
    fprintf(fid2,'%s',str(idstart+7:idend-3));
    fclose(fid2);
    
    data1=importdata('node_get_process1.txt');
    nodelist_done_1=data1;
    nodenumber1=size(data1,1);
    
    nodelist11(1:nodenumber1,1)=nodelist_done_1(1:nodenumber1,2);
    nodelist11(1:nodenumber1,2)=nodelist_done_1(1:nodenumber1,3);
    nodelist11(1:nodenumber1,3)=nodelist_done_1(1:nodenumber1,4);
%         figure
%         scatter3(nodelist11(:,1),nodelist11(:,2),nodelist11(:,3),'o')
%         axis equal
%         xlabel('X');
%         ylabel('Y');
%         zlabel('Z');
%         hold on
%         title(['point cloud of tube blank of bent-tube',num2str(num)])
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid1 = fopen(['bent-tube_',num2str(num),'.txt']);
%     fid1 = fopen('bent-tube.txt');
    str= fread(fid1,'*char')';
    fclose(fid1);
    idstart=findstr(str,'*Node');
    idend=findstr(str,'*Element');
    
    fid2=fopen('node_get_process2.txt','wt');
    fprintf(fid2,'%s',str(idstart+7:idend-3));
    fclose(fid2);
    
    data2=importdata('node_get_process2.txt');
    nodelist_done_2=data2;
    
    nodelist22(1:nodenumber1,1)=nodelist_done_2(1:nodenumber1,2);
    nodelist22(1:nodenumber1,2)=nodelist_done_2(1:nodenumber1,3);
    nodelist22(1:nodenumber1,3)=nodelist_done_2(1:nodenumber1,4);%%
    %%%%%%%%%%%%
        figure
        scatter3(nodelist22(:,1),nodelist22(:,2),nodelist22(:,3),'ro')
        axis equal
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title(['point cloud of bent tube of bent-tube',num2str(num)])
%     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid1 = fopen(['springbacked_',num2str(num),'.txt']);
%     fid1 = fopen('B48-job91.txt');
    str= fread(fid1,'*char')';
    fclose(fid1);
    idstart=findstr(str,'*Node');
    idend=findstr(str,'*Element');
    
    fid2=fopen('node_get_process3.txt','wt');
    fprintf(fid2,'%s',str(idstart+7:idend-3));
    fclose(fid2);
    
    data3=importdata('node_get_process3.txt');
    nodelist_done_3=data3;
    
    nodelist33(1:nodenumber1,1)=nodelist_done_3(1:nodenumber1,2);
    nodelist33(1:nodenumber1,2)=nodelist_done_3(1:nodenumber1,3);
    nodelist33(1:nodenumber1,3)=nodelist_done_3(1:nodenumber1,4);%%
%         figure
%         scatter3(nodelist33(:,1),nodelist33(:,2),nodelist33(:,3),'ro')
%         axis equal
%         xlabel('X');
%         ylabel('Y');
%         zlabel('Z');
%         title(['point cloud of springbacked of bent-tube',num2str(num)])
    
    delete('node_get_process1.txt');
    delete('node_get_process2.txt');
    delete('node_get_process3.txt');
    
    %% sort
    datalineproce=sortrows(data1,4);
    sizedata=size(data1,1);
    for th=1:sizedata
        m=datalineproce(th,1);
        nodelist1(th,:)=nodelist11(m,:);
        nodelist2(th,:)=nodelist22(m,:);
        nodelist3(th,:)=nodelist33(m,:);
    end

end