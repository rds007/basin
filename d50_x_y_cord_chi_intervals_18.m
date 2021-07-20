
%%Channels
    temp1=0;temp2=0;temp3=0;temp4=0;count1=0;count2=0;count3=0;count4=0;
    
for i = 1:length(d50_Channels_18)
 
    if(d50_Channels_18(i,1)<=0.2)
        count1=count1+1;
        temp1=temp1+ d50_Channels_18(i,2);
    elseif(d50_Channels_18(i,1)>0.2 && d50_Channels_18(i,1)<=0.4)
         count2=count2+1;
        temp2=temp2+ d50_Channels_18(i,2);
    elseif(d50_Channels_18(i,1)>0.4 && d50_Channels_18(i,1)<=0.6)
         count3=count3+1;
        temp3=temp3+ d50_Channels_18(i,2);
    else
        count4=count4+1;
        temp4=temp4+ d50_Channels_18(i,2);
    end
end
    
    d50_int_sc_18(1,1)=0.1;
    d50_int_sc_18(1,2)=temp1/count1; 
    d50_int_sc_18(2,1)=0.3;
    d50_int_sc_18(2,2)=temp2/count2;
    d50_int_sc_18(3,1)=0.6;
    d50_int_sc_18(3,2)=temp3/count3;
    d50_int_sc_18(4,1)=max(d50_Channels_18(:,1));
    d50_int_sc_18(4,2)=temp4/count4;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%Overbanks
    temp1=0;temp2=0;temp3=0;temp4=0;count1=0;count2=0;count3=0;count4=0;
    
for i = 1:length(d50_Overbanks_18)
 
    if(d50_Overbanks_18(i,1)<=0.2)
        count1=count1+1;
        temp1=temp1+ d50_Overbanks_18(i,2);
    elseif(d50_Overbanks_18(i,1)>0.2 && d50_Overbanks_18(i,1)<=0.35)
         count2=count2+1;
        temp2=temp2+ d50_Overbanks_18(i,2);
    elseif(d50_Overbanks_18(i,1)>0.35 && d50_Overbanks_18(i,1)<=0.6)
         count3=count3+1;
        temp3=temp3+ d50_Overbanks_18(i,2);
    else
        count4=count4+1;
        temp4=temp4+ d50_Overbanks_18(i,2);
    end
end
    
    d50_int_ob_18(1,1)=0.1;
    d50_int_ob_18(1,2)=temp1/count1; 
    d50_int_ob_18(2,1)=0.3;
    d50_int_ob_18(2,2)=temp2/count2;
    d50_int_ob_18(3,1)=0.5;
    d50_int_ob_18(3,2)=temp3/count3;
    d50_int_ob_18(4,1)=max(d50_Overbanks_18(:,1));
    d50_int_ob_18(4,2)=temp4/count4;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%Lobes
    temp1=0;temp2=0;temp3=0;temp4=0;count1=0;count2=0;count3=0;count4=0;
    
for i = 1:length(d50_Lobes_18)
 
    if(d50_Lobes_18(i,1)<=0.2)
        count1=count1+1;
        temp1=temp1+ d50_Lobes_18(i,2);
    elseif(d50_Lobes_18(i,1)>0.2 && d50_Lobes_18(i,1)<=0.4)
         count2=count2+1;
        temp2=temp2+ d50_Lobes_18(i,2);
    elseif(d50_Lobes_18(i,1)>0.4 && d50_Lobes_18(i,1)<=0.6)
         count3=count3+1;
        temp3=temp3+ d50_Lobes_18(i,2);
    else
        count4=count4+1;
        temp4=temp4+ d50_Lobes_18(i,2);
    end
end
    
    d50_int_sl_18(1,1)=0.1;
    d50_int_sl_18(1,2)=temp1/count1; 
    d50_int_sl_18(2,1)=0.3;
    d50_int_sl_18(2,2)=temp2/count2;
    d50_int_sl_18(3,1)=0.5;
    d50_int_sl_18(3,2)=temp3/count3;
    d50_int_sl_18(4,1)=max(d50_Channels_18(:,1));
    d50_int_sl_18(4,2)=temp4/count4;
    
    
    figure(1)
plot(d50_int_sc_18(:,1),d50_int_sc_18(:,2),'.', 'MarkerSize',28);
title("d50 Channels 18 x-y cord");
xlabel("Chi");
ylabel("d50 in microns");

figure(2)
plot(d50_int_sl_18(:,1),d50_int_sl_18(:,2),'.', 'MarkerSize',34);
title("d50 Lobes 18 x-y cord");
xlabel("Chi");
ylabel("d50 in microns");

figure(3)
plot(d50_int_ob_18(:,1),d50_int_ob_18(:,2),'.', 'MarkerSize',34);
title("d50 Overbanks 18 x-y cord");
xlabel("Chi");
ylabel("d50 in microns");
    
    