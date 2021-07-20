clear all
close all
%% Definitions
SL_Start = 25.25;%starting sea level 
blrise = 0.1;%base level rise rate (mm/hr)
dx = 5;%cell spacing in x direction (mm)
dy = 5;%cell spacing in y direction (mm)
cd C:\Work\Projects\Mass_Balance\TDB_17_1
load('ZdataD_final.mat')
ZD = ZD(:,:,1:560);%3D array of topography (x,y,t array with values in z)
cd C:\Work\Projects\Mass_Balance\TDB_17_1\Scripts
z = ZD;%renaming ZD array
clear ZD
nx = size(z,1);%number of x nodes
ny = size(z,2);%number of y nodes
nt = size(z,3);%number of t nodes
xcenter = 109;%x node of end of entrance channel
ycenter = 284;%y node of end of entrance channel
%% Load Channel Maps
filelistC = dir('C:\Work\Projects\Mass_Balance\TDB_17_1\Chan_Maps\*.tif');
chan_maps = zeros(nx,ny,nt);%3D array of channel maps(x,y,t array with values of 1 being channel, 0 being non-channel
cd C:\Work\Projects\Mass_Balance\TDB_17_1\Chan_Maps
for i = 1:nt%loop to load channel maps and store in chan_maps
    if filelistC(i).isdir ~= true
        fname = filelistC(i).name;
        tmpC = imread(fname);
        tmpC = tmpC(:,:,1);
        tmpC = double(tmpC);
        tmpC(tmpC>=150) = 255;
        tmpC(tmpC<150) = 0;
        tmpC(tmpC>0) = 1;%last few lines is just to make channel maps truly binary.
        if i == 231%channel map 231 is odd as it was saved in a weird fashion.
            fname = filelistC(i).name;
            tmpC = imread(fname);
            tmpC = double(tmpC);
        end
        tmpC = (tmpC-1).*-1;
        chan_maps(:,:,i) = tmpC((1:nx),(1:ny));
    end
end
cd C:\Work\Projects\Mass_Balance\TDB_17_1\Scripts

%% Main loop
C_R = [];%empty array to be filled with Hc value along radial transects ever 5 mm from source 
C_Rv = [];%%empty array to be filled with std of Hc values along radial transects ever 5 mm from source 
Agg = [];%empty array to be filled with aggradation rates (mm/hr) along radial transects ever 5 mm from source 
Aggv = [];%empty array to be filled with variability of aggradation rates (mm/hr) along radial transects ever 5 mm from source 
TC = [];%empty array to be filled with Tc value (hr) along radial transects ever 5 mm from source 
TCv = [];%empty array to be filled with variability of Tc (hr) along radial transects ever 5 mm from source 
for i = 1:528%loop to run through different radial distances from the end of the entrance channel.
    i
    %%section to find x,y nodes for radial transect and generate matrix of
    %%cross section topo and channel (yes/no) data
    th = 0:1/i:2*pi;
    xunit = i * cos(th) + xcenter;
    yunit = i * sin(th) + ycenter;
    xunit = round(xunit);
    yunit = round(yunit);
    xunit2 = [];
    yunit2 = [];
    for j = 1:max(size(xunit))
        xc = xunit(j);
        yc = yunit(j);
        if xc >= 1;
            if yc >= 1;
                if xc <= nx
                    if yc <= ny
                        xunit2 = [xunit2;xc];
                        yunit2 = [yunit2;yc];
                    end
                end
            end
        end
    end
    xunit = xunit2;
    yunit = yunit2;
    XY = [yunit xunit];
    XY = sortrows(XY);
    xunit = XY(:,2);
    yunit = XY(:,1);
    zs = [];
    is = [];
    for j = 1:max(size(xunit));
        xs_shot = z(xunit(j),yunit(j),:);
        is_shot = chan_maps(xunit(j),yunit(j),:);
        zs = [zs;xs_shot];
        is = [is;is_shot];
    end
    zs = squeeze(zs);%matrix of topo along radial transect
    is = squeeze(is);%matrix of channel (yes/no) along radial transect
    zs2 = [];
    is2 = [];
    for j = 1:size(zs,1);
        ztest = zs(j,1);
        if ztest > 0
            zline = zs(j,:);
            iline = is(j,:);
            zs2 = [zs2;zline];
            is2 = [is2;iline];
        end
    end
    zs = zs2;
    is = is2;
    %% Loop to find channel depths
    nw = 225;%window size
    Hc_list = [];
    Agg_list = [];
    Tc_list = [];
    for l = 1:1:size(zs,2)-nw;
        zs_crop = zs(:,l:l+nw-1);
        is_crop = is(:,l:l+nw-1);
        Cdepth = [];
        for j = 1:size(zs_crop,2);
            iold = 0;
            for k = 2:size(zs_crop,1)-1;
                testi = is_crop(k,j);
                if testi > iold;%if, as going along transect, switch from non-channel to channel, start tracking topo
                    zc = zs_crop(k,j);
                end
                if testi == iold
                    if testi == 1;%if as going along transect, you stay channel node, keep tracking topo
                        zc = [zc;zs_crop(k,j)];
                    end
                end
                if testi < iold;%if, as going along transect, switch from channel to non-channel node, stop tracking topo and calculate Hc
                    cdepth = max(zc) - min(zc);
                    Cdepth = [Cdepth;cdepth];
                end
                iold = testi;
            end
        end
        Hc = prctile(Cdepth,95);
        Hc_list = [Hc_list;Hc];
        dz = (mean(zs_crop(:,nw))-mean(zs_crop(:,1)))/nw;
        Agg_list = [Agg_list;dz];
        Tc = Hc/dz;
        Tc_list = [Tc_list;Tc];
    end
    Hc = mean(Hc_list);
    Hc_v = std(Hc_list);
    C_R = [C_R;Hc];
    C_Rv = [C_Rv;Hc_v];    
    dz = mean(Agg_list);
    dz_v = std(Agg_list);
    Agg = [Agg;dz];
    Aggv = [Aggv;dz_v];
    tc = mean(Tc_list);
    tc_v = std(Tc_list);
    TC = [TC;tc];
    TCv = [TCv;tc_v];
end