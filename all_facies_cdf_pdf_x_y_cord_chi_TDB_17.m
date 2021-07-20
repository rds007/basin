%%%%%%%TDB_17%%%%%%%%%%

%%THIS CODE USES X Y COORDINATES TO CALCULATE THE DITANCE FROM ENTRANCE
%%RATHER THAN JUST THE X CORD 

%This code plots all facies CDF and PDF with chi locations. This prooduces
%plots in linear linear space. The code lines for log-log or log-linear are
%commented out

cd('D:\Third Chapter Analytics')
[num txt raw] = xlsread('TDB_17_facies_samples_all');
TDB_17_samples_info = raw; %This is where the entire excel sheet TDB_17_facies_samples_all is extracted as is
no_samples = length(TDB_17_samples_info);
clearvars num text raw
[num txt raw] = xlsread('TDB_17_x_chi');
x_chi_17 = raw;

count_OB = 0; %counts all overbank facies samples
count_SC = 0; %counts all sediment channel facies samples
count_SL = 0; %counts all sediment lobe facies samples
  
    
for s=2:no_samples %first row consists of column headers, s is the sample number
   bin_midpoints =[0.9 1.05 1.2 1.4 1.6 1.8 2.1 2.35 2.7 3.1 3.55 4.1 4.65 5.35 6.1 7 8.1 9.2 10.6 12.1 13.85 15.9 18.5 20.5 23.5 27 31.5 36.5 41.5 47.5 54.5 62.5 72 83 95.5 109.5 125.5 144 165.5 190.5 219 251.5 288.5 331 380.5 437.5 502.5 577 663 761.5 874.5 1004.5 1154 1326 1523 1749.5 2010 2308.5 2651.5 3046 3499 4019 4616.5 5303 6092]; %these are the grain-size bin mid-points that are plotted in the final plot
   facies_name = TDB_17_samples_info(s,1); %This extracts the name of the facies 
   %%%TDB_17_samples_info contains the x location, y location in the second
   %%%and third column respectively
   temp = TDB_17_samples_info(s,2);
   x_loc = temp{1,1};
   temp = TDB_17_samples_info(s,3);
   y_loc = temp{1,1}/2;  %pixels in the y direction have one millimiter spacing compared to pixes in x direction which is 0.5
   y_loc_use =  abs(1350-y_loc); %%the total mm length is 5400 in cross-sections, true is 2700 mm, then half of it is 1350 mm.
   
LPSA_File = char(strcat('TDB_17_FF_',facies_name,'.txt'));      %remember strcat stores file as cell then use char encapsulation outside to make it work
CAM_File = char(strcat('TDB_17_CF_',facies_name,'001','.txt'));

%extracted x_loc and y_loc directly from the excel file above.

  temp = (sqrt(x_loc^2 + y_loc_use^2))/1000; %this is the actual radial distance from the entrance channel and will be used to estimate the value of chi

  r_loc = floor(temp) + ceil( (temp-floor(temp))/0.005) * 0.005; %rounds up the nearest 0.005 decimal increment
  
  for i=2:size(raw,1)
      temp = x_chi_17(i,1);
      
      if(r_loc == temp{1,1}) %%this is used to estimate the closest value of chi as per the x_loc
       
      temp =x_chi_17(i,2);   
      chi=temp{1,1};
          
      end
  end
    
   
LPSA_mass = TDB_17_samples_info(s,7); %mass of the fine fraction
CAM_mass = TDB_17_samples_info(s,6); %mass of the coarse fraction
LPSA_mass_prcnt = LPSA_mass{1,1}/(LPSA_mass{1,1} + CAM_mass{1,1}); %%{} are used to access cell
CAM_mass_prcnt = CAM_mass{1,1}/(LPSA_mass{1,1} + CAM_mass{1,1});

% cd('D:\LPSA_CAM_Files\LPSA\TDB_17') %directory where LPSA files are stored 

LPSA_raw_data = LPSA_extract_data(LPSA_File); %raw LPSA frequency data from the excel file

finetail_correction_data = [0.154 0.22 0.287 0.354 0.417 0.445 0.467 0.4635 0.4549 0.431 0.384 0.318 0.245 0.178 0.123 0];
Finetail_correction = sum(finetail_correction_data);

%Here I first deal with preparing the LPSA matrix as per the format of
%excel sheet to be used later for making a combined distribution

LPSA_feq = LPSA_raw_data(19:length(LPSA_raw_data),2); %%this is the matrix what we use after the fine tail correction below, as the per the excel sheet
%the LPSA grain-size starts from 1.31, so skipping the first row of the raw
%dat by starting with the second row

%%Here we do the fine tail correction to the LPSA frequency data
temp= finetail_correction_data';
for i=1:length(temp)
    if(LPSA_feq(i,1)>temp(i,1))
        LPSA_feq(i,1)= LPSA_feq(i,1)-temp(i,1);
    else
         LPSA_feq(i,1)=0;
    end
end

for i=length(temp)+1:length(LPSA_feq)
    LPSA_feq(i,1)= LPSA_feq(i,1)/((1-Finetail_correction/100));
end

% for adding extra rows to the LPSA matrix for consistency
temp =length(LPSA_feq);
diff_LPSA = length(bin_midpoints')-temp; % foradding extra rows to the LPSA matrix for consistency


for i=temp+1:temp+diff_LPSA
    LPSA_feq(i,1)=0;
end

cumm_LPSA_feq = []; %creating a matrix to store cummulative LPSA frequency values
cumm_LPSA_feq(1,1) = LPSA_feq(1,1);

for i=2:length(LPSA_feq) 
    cumm_LPSA_feq(i,1)= cumm_LPSA_feq(i-1,1) + LPSA_feq(i,1);
end

%Now I deal with preparing the CAMSIZER matrix

% cd('D:\LPSA_CAM_Files\CAMSIZER\TDB_17') %directory where CAMSIZER files are stored 
CAM_raw_data = CAMSIZER_extract_data1(CAM_File); %raw CAMSIZER frequency data from the excel file
CAM_feq = CAM_raw_data(:,2);

for i=1:length(bin_midpoints')
    if (i<22)
        CAM_feq(i,1)=0;
    elseif(i>73)
            CAM_feq(i,1)=0;
        else
            CAM_feq(i,1) = CAM_raw_data(i-21,2);
    end
end

%now I combine the LPSA and CAMSIZER data by using the mass-fractions of
%coarse and fine material


for i=1:length(bin_midpoints')

    combined_LPSA_CAM(i,1) = LPSA_feq(i,1)*LPSA_mass_prcnt + CAM_feq(i,1)*CAM_mass_prcnt;

end

cumm_combined_LPSA_CAM = []; %creating a matrix to store cummulative LPSA frequency values
cumm_combined_LPSA_CAM(1,1) = combined_LPSA_CAM(1,1);

for i=2:length(bin_midpoints')
    cumm_combined_LPSA_CAM(i,1)= cumm_combined_LPSA_CAM(i-1,1) + combined_LPSA_CAM(i,1);
end

%here i store the pdf and cdf of grain-size distributions

facies_dist =zeros(length(bin_midpoints),2);
facies_dist(:,1)= bin_midpoints';        %the pdf of facies distribution

cumm_facies_dist =zeros(length(bin_midpoints),2);
cumm_facies_dist(:,1)= bin_midpoints';        %the cdf of facies distribution

%%change here from cummulative to pdf and vice versa as per the need
%%currently using cdf to calculate d10 d25 d50 d75 d90


facies_dist(:,2)= combined_LPSA_CAM; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cumm_facies_dist(:,2)= cumm_combined_LPSA_CAM; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Now I store all channel facies into one matrix, all overbank into another
%and all lobes into another
   
t=length(LPSA_File);

if (LPSA_File(t-5:t-4) == 'SC')      %LPSA_File is used just to extract facies name
    
    count_SC = count_SC + 1;
    SC_dist_all_17(:,:,count_SC) = facies_dist;
    cumm_SC_dist_all_17(:,:,count_SC) = cumm_facies_dist;
    
    J=jet;
    Jsize=max(size(J));
    figure(1)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(SC_dist_all_17(:,1,count_SC),SC_dist_all_17(:,2,count_SC),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
%     set(gca, 'YScale', 'log')
%      set(gca, 'XScale', 'log')
    title('PDF of Channel grain-size distribution');
    xlim([0 1000]);
    colorbar
    hold on
    
    J=jet;
    Jsize=max(size(J));
    figure(2)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(cumm_SC_dist_all_17(:,1,count_SC),cumm_SC_dist_all_17(:,2,count_SC),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
%     set(gca, 'YScale', 'log')
%      set(gca, 'XScale', 'log')
    title('CDF of Channel grain-size distribution');
    xlim([0 1000]);
    ylim([0 100]);
    colorbar
    hold on
    
    
     
elseif (LPSA_File(t-5:t-4) == 'OB')
    
    count_OB = count_OB + 1;
    OB_dist_all_17(:,:,count_OB) = facies_dist;
    cumm_OB_dist_all_17(:,:,count_OB) = cumm_facies_dist;
    
   
    J=jet;
    Jsize=max(size(J));
    figure(3)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(OB_dist_all_17(:,1,count_OB),OB_dist_all_17(:,2,count_OB),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
%     set(gca, 'YScale', 'log')
%      set(gca, 'XScale', 'log')
    title('PDF of Overbank grain-size distribution');
    xlim([0 1000]);
    colorbar
    hold on

    
    J=jet;
    Jsize=max(size(J));
    figure(4)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(cumm_OB_dist_all_17(:,1,count_OB),cumm_OB_dist_all_17(:,2,count_OB),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
%     set(gca, 'YScale', 'log')
%      set(gca, 'XScale', 'log')
    title('CDF of Overbank grain-size distribution');
    xlim([0 1000]);
    ylim([0 100]);
    colorbar
    hold on 
       
elseif (LPSA_File(t-5:t-4) == 'SL')
     
    count_SL = count_SL + 1;
    SL_dist_all_17(:,:,count_SL) = facies_dist;
    cumm_SL_dist_all_17(:,:,count_SL) = cumm_facies_dist;
    
    J=jet;
    Jsize=max(size(J));
    figure(5)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(SL_dist_all_17(:,1,count_SL),SL_dist_all_17(:,2,count_SL),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
%      set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
    title('PDF of Lobe grain-size distribution');
    xlim([0 1000]);
    colorbar
    hold on

    J=jet;
    Jsize=max(size(J));
    figure(6)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
   plot(cumm_SL_dist_all_17(:,1,count_SL),cumm_SL_dist_all_17(:,2,count_SL),'color',C);
   xlabel('Grain-Size in µm');
   ylabel('Percent')
%    set(gca, 'YScale', 'log')
%     set(gca, 'XScale', 'log')
   title('CDF of Lobe grain-size distribution');
   xlim([0 1000]);
   ylim([0 100]);
   colorbar
   hold on
   
       
elseif (LPSA_File(t-5:t-4) == 'ee') %This is for Levee which is a part of sediment channel here
    
    count_SC = count_SC + 1;
    
    
    J=jet;
    Jsize=max(size(J));
    figure(1)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(SC_dist_all_17(:,1,count_SC),SC_dist_all_17(:,2,count_SC),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
    set(gca, 'YScale', 'log')
     set(gca, 'XScale', 'log')
    title('PDF of Channel grain-size distribution');
    xlim([10 1000]);
    colorbar
    hold on
    
    J=jet;
    Jsize=max(size(J));
    figure(2)
    colormap(jet)
    Crow=ceil(chi*Jsize);
    C=J(Crow,:);
    plot(cumm_SC_dist_all_17(:,1,count_SC),cumm_SC_dist_all_17(:,2,count_SC),'color',C);
    xlabel('Grain-Size in µm');
    ylabel('Percent')
%     set(gca, 'YScale', 'log')
%      set(gca, 'XScale', 'log')
    title('CDF of Channel grain-size distribution');
    xlim([10 1000]);
    ylim([0 100]);
    colorbar
    hold on
   
end

end 







