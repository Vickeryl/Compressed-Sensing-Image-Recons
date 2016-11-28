function [DCT] = OMP(A,B,lambda)

alpa=zeros(size(A,2),1);

    F=B; omega=[];p=1;AA=[];alphha=[];DCT=[];
    
while(p<=lambda)    

    theta = F' * A;
 
    [~,pos] = max((abs(theta)));%%%did not take abs value of theta . Lost clarity
    
    omega = [omega pos];
    

    AA = A(:,omega);
    alphha = AA\B;
    
    F=B-AA*alphha;%summation;
    
    p=p+1;
end
 
alpa(omega)=alphha;
DCT=alpa;
        
end

