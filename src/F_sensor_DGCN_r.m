 function [sensors,Rinv,det_test]= F_sensor_DGCN_r(U,Unoi,Snoi,p)
    [n,r]=size(U);
    Snoi_sq=Snoi*Snoi;
    USsq=Unoi*Snoi_sq;
    t_vec=sum(USsq.*Unoi,2);
    Cpp=zeros(0,r);
    initial=true;
    det_test=zeros(p,1);
    if p<=r
    for pp=1:p
        if initial==true   % initialize W&Cpp
            CCinv=inv(Cpp*Cpp');
            initial=false;
        end
        %% searching
        Y=eye(r)-Cpp(1:pp-1,:)'*CCinv(1:pp-1,1:pp-1)*Cpp(1:pp-1,:);
        nume=sum((U*Y).*U,2);
        if pp==1
            s_vec=zeros(n,1);
            Rinv=0;
        else
            s_vec=USsq*(Unoi(sensors,1:end))';
        end
        dnm=t_vec-sum((s_vec*Rinv).*s_vec,2);
        det_vec=nume./dnm;
        for l=1:(pp-1)
            det_vec(sensors(l,1),1)=0;
        end
        [det_test(pp,1),sensors(pp,1)]=max(det_vec);   % argmaxdet
%%   Update Rinv&C after we get pp-th sensor  
        s=zeros(1,pp-1);
        u_i=U(sensors(pp,1),:);
        
        for l=1:(pp-1)
            s(1,l)=Unoi(sensors(pp,1),:)*Snoi_sq*Unoi(sensors(l,1),:)';
        end
        t=Unoi(sensors(pp,1),:)*Snoi_sq*Unoi(sensors(pp,1),:)';
        dnm=t-s*Rinv*s';
        Cpp=[Cpp;u_i];
        CCinv=inv(Cpp*Cpp');
        
        sR=s*Rinv;
        Rinv_new=zeros(pp,pp);
        Rinv_new(1:pp-1,1:pp-1)=Rinv;
        Rinv=Rinv_new+[sR';-1]*(dnm\[sR -1]);
    end
    else
        sensors='F_sensor_DGwR_r: cannot calc if p>r';
        Rinv=[];
        det_test=[];
    end
end