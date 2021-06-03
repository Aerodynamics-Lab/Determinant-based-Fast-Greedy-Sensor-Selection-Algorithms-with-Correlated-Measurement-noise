 function [iR]= F_calc_Rinv_scalar(Un,Sn,sensors)
%     [~,rn]=size(Un);
    ps = 0;
    [p,~]=size(sensors);
    Sn_sq=Sn*Sn;
    iR =[];
    for pp=(ps+1):p 
        s=zeros(1,pp-1);
        
        for l=1:(pp-1)
            s(1,l)=Un(sensors(pp,1),:)*Sn_sq*Un(sensors(l,1),:)';
        end
        t=Un(sensors(pp,1),:)*Sn_sq*Un(sensors(pp,1),:)';
        
        dnm=t-s*iR*s';
        
        sR=s*iR;
        Rinv_new=zeros(pp,pp);
        Rinv_new(1:pp-1,1:pp-1)=iR;
        iR=Rinv_new+[sR';-1]*(dnm\[sR -1]);
    end
end