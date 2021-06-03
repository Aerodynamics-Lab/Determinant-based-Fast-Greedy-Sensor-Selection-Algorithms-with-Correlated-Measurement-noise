function[Error_ave]=F_calc_reconst_error(Xorg, U, Zestimate)
    
    [~,~,num_cases] = size(Zestimate);
    Error_ave = [];
    for i = 1:num_cases
        Xestimate = U*Zestimate(:,:,i);
        dif1 = Xorg-Xestimate;
        Error_ave = [Error_ave norm(dif1,'fro')/norm(Xorg,'fro')];        
    end    
end