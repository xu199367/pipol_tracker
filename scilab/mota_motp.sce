// clear all 
xdel(winsid());
clear;

//opens file
fd_gt=mopen('/home/andreu/dataSets/people_tracking/reem/ground_truth/20140925_twoPeople.txt','r');
fd_res=mopen('/home/andreu/dataSets/people_tracking/reem/tracker_results/20140925_twoPeople_1_tree_all.txt','r');


//GROUND TRUTH PARSING
gt = list();
while (1) do
    gt_row = [];
    str_line = mgetl(fd_gt,1);
    if length(str_line) < 2 then
        break;
    else
        tkns = tokens(str_line,' ');
        for i=1:size(tkns,1)
            gt_row = [gt_row strtod(tkns(i))];
        end
        gt($+1) = gt_row;
    end
end

//TRACKER OPUTPUT PARSING
res = list();
while (1) do    
    res_row=[];
    str_line = mgetl(fd_res,1);
    if length(str_line) < 2 then
        break;
    else
        tkns = tokens(str_line,' ');
        for i=1:size(tkns,1)
            res_row = [res_row strtod(tkns(i))];
        end
        res($+1) = res_row;
    end
end

//delete res rows out of ground truth time interval
while ( res(1)(1) < gt(1)(1) )
    res(1) = null();
end
while ( res($)(1) > gt($)(1) )
    res($) = null();
end

//interpolate ground truth at result time stamp point
ii = 1;
gt_intp = list();
for jj=1:size(res)
    ts = res(jj)(1);//get time stamp
    gt_intp_row = ts;
    while ( ts > gt(ii)(1) ) do
        ii = ii + 1;
    end
    ts_gt_1 = gt(ii-1)(1);//ts just before
    ts_gt_2 = gt(ii)(1);//ts just after
    alpha = (ts - ts_gt_1) / (ts_gt_2 - ts_gt_1);
    Nt_gt = ( min( size(gt(ii)),size(gt(ii-1)) ) -1 ) / 3; //number of targets 
    for kk=1:Nt_gt
        //check "out of horizon"
        if ( gt(ii-1)(ii*3) < 0 ) | ( gt(ii-1)(ii*3) < 0 ) then
            gt_x = -1; //label as "out of horizon"
        end
        else //compute linear interpolation
            gt_x = alpha*gt(ii-1)(kk*3) + (1-alpha)*gt(ii)(kk*3);
            gt_y = alpha*gt(ii-1)(kk*3+1) + (1-alpha)*gt(ii)(kk*3+1);
            gt_intp_row = [gt_intp_row gt(ii-1)(kk*3-1) gt_x gt_y];
        end
        gt_intp($+1)
    end
end

//Compute performance indexes

//ESTABLISH BEST MAPPING    

//COMPUTE DISTANCES -> MOTP
    
//CHECK MAPPING SWITCHES -> sw
    
//COUNT FALSE POSITIVES -> fp
    
//COUNT MISSINGS -> m
    
//COMPUTE MOTA = (sw,fp,m)
    
end

//close file
mclose(fd_gt);
mclose(fd_res);
