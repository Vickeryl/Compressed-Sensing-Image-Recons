function [T]=transform_per_block(block,K)

[P Q]=size(block);

x=1;
y=1;

for i=1:P*Q

    for u = 1:P
    
        if u == 1
            a=sqrt(1/P);
        else
            a=sqrt(2/P);
        end
        c=cos(pi*(2*x-1)*(u-1)/(2*P));
        R(u)=a*c;
  
    end

    for v = 1:Q
        if v == 1
            b=sqrt(1/Q);
        else
            b=sqrt(2/Q);
        end
        c=cos(pi*(2*y-1)*(v-1)/(2*Q));
        S(v)=b*c;
    end

f=R' * S;
ftrans=f';
row=reshape(ftrans,1,size(ftrans,1)*size(ftrans,2));
%a1b1 a1b2 a1b3.....
T(i,:)=row;
x=x+1;

    if mod(i,K)==0
     x=1;
     y=y+1;
    end
end

end