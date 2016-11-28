function lambda = crossValidation(A,B,m)
error1=[];

for l = 1:15
    error_lambda1=[];
    for count = 1:20
        
    rand=randperm(size(A,1),m);
    
    %creating the test set
    A_test=A(rand,:);
    B_test=B(rand);
    
    %deleting the test set values from the training set
    A2=A;
    B2=B;    
    A2(rand,:)=[];
    B2(rand,:)=[];

    [DCT] = OMP(A2,B2,l);%replace A and B with A2 B2
    rec_pixels = A_test * DCT;%replace A with A_test
    error_lambda1(count) =norm(B_test - rec_pixels,2);%replace B with B_test

    end
    error1(l)=mean(error_lambda1);

end  

[~,poss] = min(error1(1:end));
lambda = poss;% + 1;
    
end