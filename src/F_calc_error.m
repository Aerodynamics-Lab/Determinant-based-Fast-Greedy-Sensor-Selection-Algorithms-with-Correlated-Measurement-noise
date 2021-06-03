function [Zestimate, Error] = F_calc_error(m, Xorg, U, H, iR, Q)    
    
    [Zestimate_ls] = F_calc_reconst(Xorg, H, U);
    [Zestimate_gls] = F_reconst_gls(Xorg,H,U,iR);
    [Zestimate_bayes] = F_reconst_bayesian(Xorg,H,U,iR,Q);
    Zestimate = cat(3,Zestimate_ls, Zestimate_gls, Zestimate_bayes);
    
    [Error] = F_calc_reconst_error(Xorg, U, Zestimate);

end
