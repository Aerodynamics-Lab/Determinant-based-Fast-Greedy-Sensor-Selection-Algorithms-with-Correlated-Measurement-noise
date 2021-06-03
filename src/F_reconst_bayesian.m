function [Zestimate]= F_reconst_bayesian(Xorg,H,U,iR,Q)

iQ=inv(Q);
y=H*Xorg;
C=H*U;
Zestimate=(inv(C'*(iR)*C+iQ))*C'*(iR)*y;

end