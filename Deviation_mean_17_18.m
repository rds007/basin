                                                                                                               
temp1 = mean(cumm_SC_dist_all_18,3);
temp2 = mean(cumm_OB_dist_all_18,3);
temp3 = mean(cumm_SL_dist_all_18,3);

for i =1:size(cumm_SC_dist_all_18,3)
    cumm_SC_diff_18(:,1,i) = cumm_SC_dist_all_18(:,1,1); %this will take the bin mid point values 
    cumm_SC_diff_18(:,2,i) = abs(cumm_SC_dist_all_18(:,2,i)-temp1(:,2));
end

for i =1:size(OB_dist_all_18,3)
    cumm_OB_diff_18(:,1,i) = cumm_OB_dist_all_18(:,1,1); %this will take the bin mid point values 
    cumm_OB_diff_18(:,2,i) = abs(cumm_OB_dist_all_18(:,2,i)-temp2(:,2));
end

for i =1:size(SL_dist_all_18,3)
    cumm_SL_diff_18(:,1,i) = cumm_SL_dist_all_18(:,1,1); %this will take the bin mid point values 
    cumm_SL_diff_18(:,2,i) = abs(cumm_SL_dist_all_18(:,2,i)-temp3(:,2));
end

figure(1)
for i=1:size(cumm_SC_diff_18,3)
plot(cumm_SC_diff_18(:,1,i),cumm_SC_diff_18(:,2,i));
xlabel('Grain-Size in µm');
ylabel('Percent')
title('Channel Facies TDB_18 deviation from Mean');
xlim([0 1000]);
ylim([0 100]);
hold on
end 

figure(2)
for i=1:size(cumm_OB_diff_18,3)
plot(cumm_OB_diff_18(:,1,i),cumm_OB_diff_18(:,2,i));
xlabel('Grain-Size in µm');
ylabel('Percent')
title('Overbank Facies TDB_18 deviation from Mean');
xlim([0 1000]);
ylim([0 100]);
hold on
end 

figure(3)
for i=1:size(cumm_SL_diff_18,3)
plot(cumm_SL_diff_18(:,1,i),cumm_SL_diff_18(:,2,i));
xlabel('Grain-Size in µm');
ylabel('Percent')
title('Lobes Facies TDB_18 deviation from Mean');
xlim([0 1000]);
ylim([0 100]);
hold on
end 
