 function [sensors,iR,det_test]= F_sensor_DGCN_p(U,Un,Sn,p,sensors,iR)
    [n,r1]=size(U);
    [ps,~]=size(sensors);
    Sn_sq=Sn*Sn;
    USsq=Un*Sn_sq;
    t_vec=sum(USsq.*Un,2);
    Cpp=zeros(ps,r1);
    initial=true;
    det_test=zeros(p,1);
    if p>r1
    for pp=(ps+1):p
        if initial==true   % initialize W&Cpp
%             if pp>1
            for l=1:ps
                Cpp(l,:)=U(sensors(l,1),:); 
            end
            RC=iR*Cpp;
            W=Cpp'*RC;
            Winv=inv(W);
            initial=false;
        end
        %% searching        
        if pp==1
            s_vec=zeros(n,1);
            iR=0;
        else
            s_vec=USsq*(Un(sensors,1:end))';
        end
        
        diff=s_vec*RC-U;
        nume=sum((diff*Winv).*diff,2);
        dnm=t_vec-sum((s_vec*iR).*s_vec,2);
        det_vec2=nume./dnm;
        
        for l=1:(pp-1)
            det_vec2(sensors(l,1),1)=0;
        end
        [det_test(pp,1),sensors(pp,1)]=max(det_vec2);   % argmaxdet
        
%%   Update iR&C after we get pp-th sensor  
        s=zeros(1,pp-1);
        t=0;
        u_i=U(sensors(pp,1),:);
        
        for l=1:(pp-1)
            s(1,l)=Un(sensors(pp,1),:)*Sn_sq*Un(sensors(l,1),:)';
        end
        t=Un(sensors(pp,1),:)*Sn_sq*Un(sensors(pp,1),:)';
        
        diff=s*RC-u_i;
        dnm=t-s*iR*s';
        W=W+diff'*(dnm\diff);
        Winv=inv(W);
        
        Cpp=[Cpp;u_i];
        
        sR=s*iR;
        iR_new=zeros(pp,pp);
        iR_new(1:pp-1,1:pp-1)=iR;
        iR=iR_new+[sR';-1]*(dnm\[sR -1]);
        RC=iR*Cpp;
    end
    else
        disp('something wrong with p')
    end
end