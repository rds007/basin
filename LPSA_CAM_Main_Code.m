cd('D:\Third Chapter Analytics')

LPSA_File = 'LPSA_Input_Sed_1.txt';    %% 'LPSA_Input_Sed.txt'

CAM_File = 'CAMSIZER_Input_02001.txt';     %% 'CAMSIZER_Input_Sed_2001.txt'

LPSA_mass = 0; %mass of the fine fraction
CAM_mass = 100; %mass of the coarse fraction
LPSA_mass_prcnt = LPSA_mass/(LPSA_mass + CAM_mass);
CAM_mass_prcnt = CAM_mass/(LPSA_mass + CAM_mass);

% cd('E:\LPSA_CAM_Files\LPSA\TDB_18') %directory where LPSA files are stored 

LPSA_raw_data = LPSA_extract_data(LPSA_File); %raw LPSA frequency data from the excel file

finetail_correction_data = [0.154 0.22 0.287 0.354 0.417 0.445 0.467 0.4635 0.4549 0.431 0.384 0.318 0.245 0.178 0.123 0];
Finetail_correction = sum(finetail_correction_data);

bin_midpoints =[0.9 1.05 1.2 1.4 1.6 1.8 2.1 2.35 2.7 3.1 3.55 4.1 4.65 5.35 6.1 7 8.1 9.2 10.6 12.1 13.85 15.9 18.5 20.5 23.5 27 31.5 36.5 41.5 47.5 54.5 62.5 72 83 95.5 109.5 125.5 144 165.5 190.5 219 251.5 288.5 331 380.5 437.5 502.5 577 663 761.5 874.5 1004.5 1154 1326 1523 1749.5 2010 2308.5 2651.5 3046 3499 4019 4616.5 5303 6092]; %these are the grain-size bin mid-points that are plotted in the final plot

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

%Now I deal with preparing the CAMSIZER matrix.

% cd('D:\LPSA_CAM_Files\CAMSIZER\TDB_18') %directory where CAMSIZER files are stored 
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

    combined_LPSA_CAM_Red(i,1) = LPSA_feq(i,1)*LPSA_mass_prcnt + CAM_feq(i,1)*CAM_mass_prcnt;

end

cumm_combined_LPSA_CAM_Red = []; %creating a matrix to store cummulative LPSA frequency values
cumm_combined_LPSA_CAM_Red(1,1) = combined_LPSA_CAM_Red(1,1);

for i=2:length(bin_midpoints')
    cumm_combined_LPSA_CAM_Red(i,1)= cumm_combined_LPSA_CAM_Red(i-1,1) + combined_LPSA_CAM_Red(i,1);
end

%Now I plot the data
% 
% %this will generate a plot of combined LPSA and CAMSIZER data with the
% %grain size 
% temp=bin_midpoints';
% figure(1)
% plot(temp,combined_LPSA_CAM_Fine);
% xlabel('Grain-Size in µm');
% ylabel('Percent')
% title('PDF of grain-size distribution');
% xlim([0 1000]);
% 
% figure(2)
% plot(temp,cumm_combined_LPSA_CAM_Fine);
% xlabel('Grain-Size in µm');
% ylabel('Percent')
% title('CDF of grain-size distribution');
% xlim([0 1000]);
% 
% figure(3)
% plot(temp,CAM_feq);
% xlabel('Grain-Size in µm');
% ylabel('Percent')
% title('CAMSIZER grain-size distribution');
% xlim([0 1000]);
% 
% figure(4)
% plot(temp,LPSA_feq);
% xlabel('Grain-Size in µm');
% ylabel('Percent')
% title('LPSA grain-size distribution');
% xlim([0 1000]);
%This part if for combining the GSD of all six sediments proportinately 

% for i=1:65
%     
%     PDF_Input_GSD(:,1) = bin_midpoints';
%     PDF_Input_GSD(i,2) = (24.9*combined_LPSA_CAM_Fine(i,1) + 49.7*combined_LPSA_CAM_VF(i,1) + 6.46*combined_LPSA_CAM_Coarse(i,1) + 4.55*combined_LPSA_CAM_BC(i,1) + 9.95*combined_LPSA_CAM_G(i,1))/100; 
%     
%     CDF_Input_GSD(:,1) = bin_midpoints';
%     CDF_Input_GSD(i,2) =  (24.9*cumm_combined_LPSA_CAM_Fine(i,1) + 49.7*cumm_combined_LPSA_CAM_VF(i,1) + 6.46*cumm_combined_LPSA_CAM_Coarse(i,1) + 4.55*cumm_combined_LPSA_CAM_BC(i,1) + 9.95*cumm_combined_LPSA_CAM_G(i,1))/100; 
% end
% 
% temp=bin_midpoints';
% figure(1)
% plot(PDF_Input_GSD(:,1),PDF_Input_GSD(:,2));
% xlabel('Grain-Size in µm');
% ylabel('Percent')
% title('PDF of grain-size distribution');
% xlim([0 1000]);
% 
% figure(2)
% plot(CDF_Input_GSD(:,1),CDF_Input_GSD(:,2));
% xlabel('Grain-Size in µm');
% ylabel('Percent')
% title('CDF of grain-size distribution');
% xlim([0 1000]);
% 
