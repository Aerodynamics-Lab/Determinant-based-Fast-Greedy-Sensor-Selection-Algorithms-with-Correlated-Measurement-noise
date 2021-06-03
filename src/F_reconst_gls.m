function [Zestimate,det_test]= F_reconst_gls(Xorg,H,U,iR)
[p,~]=size(H);
[~,r]=size(U);

y=H*Xorg;
C=H*U;
if p<r
    Zestimate=pinv(C)*y;
    det_test=det(iR)*det(C*C');
elseif p>=r
    Zestimate=(inv(C'*(iR)*C))*C'*(iR)*y;
    det_test=det(C'*iR*C);
else disp('something wrong')
end
end