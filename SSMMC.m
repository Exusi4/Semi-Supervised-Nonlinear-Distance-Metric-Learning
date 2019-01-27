function [ w ] = SSMMC( X,ML,CL )
%SMMMC Summary of this function goes here
%   Detailed explanation goes here
%
% Input:    X N*d (without ones columns)
%           ML LM*2 the indexes of the must-link pairs
%           CL LC*2 the indexes of the cannot-link pairs
%
%           first move to zero mean
%           then calculate w0 d*1 by CCCP
%           finally move w s.t. w'*[x;1]=0 is the boundary line
%
% Output:   w (d+1)*1


%parameters
lamda=0.01;
delta0=1;
C=1;
LM=size(ML,1);
LC=size(CL,1);
CL=CL(randperm(LC),:);
CL=CL(1:ceil(LC/4),:);
LC=size(CL,1);
[N,d]=size(X);


%move to zero and initialize w0
Xmean=mean(X);
X=X-ones(N,1)*Xmean;
SM=(X(ML(:,1),:)-X(ML(:,2),:))'*(X(ML(:,1),:)-X(ML(:,2),:))/LM;
SC=(X(CL(:,1),:)-X(CL(:,2),:))'*(X(CL(:,1),:)-X(CL(:,2),:))/LC;
w0=randn(d,1);
k=1;
if LM
    temp1=real(sqrtm(SM));
    temp2=pinv(temp1);
    temp3=temp2*SC*temp2;
    [~,~,V]=svd(temp3);
    w0=temp2*V(:,1);
%     while 1
%         
%         w1=w0-SC*w0/(w0'*SM*SC*w0);
%         if norm(w0-w1)<0.01
%             w0=w1;
%             break
%         elseif k>1000
%             %k
%             w0=w1;
%             break
%         end
%         w0=w1;
%         k=k+1;
%     end
else
    while 1
        w1=SC*w0/norm(SC*w0);
        if norm(w0-w1)<0.01
            w0=w1;
            break
        elseif k>50
            %k
            w0=w1;
            break
        end
        w0=w1;
        k=k+1;
    end
end

Utemp=zeros(N,1);
cnt=1;
for i=1:N
    if ~ismember(i,ML)
        if ~ismember(i,CL)
            Utemp(cnt)=i;
            cnt=cnt+1;
        end
    end
end
u=cnt-1;
U=Utemp(1:u);


%calculate w by CCCP
t=1;
while 1
    if t<4
        delta=0;
    else
        delta=delta0;
    end
    wlast=w0;
    if u
        Y=sign(X(U,:)*w0);
    end
    if LM
        ZM=sign(X(ML(:,1),:)*w0+X(ML(:,2),:)*w0);
    end
    ZC=sign(X(CL(:,1),:)*w0-X(CL(:,2),:)*w0);
    r=1;
    while 1
        if LM
            Mv=(ZM*ones(1,d).*X(ML(:,1),:)*w0+ZM*ones(1,d).*X(ML(:,2),:)*w0)-abs(X(ML(:,1),:)*w0-X(ML(:,2),:)*w0);
            jMv= Mv<1;
            if jMv
                mv=-sum((ZM(jMv)*ones(1,d).*X(ML(jMv,1),:)+ZM(jMv)*ones(1,d).*X(ML(jMv,2),:))-abs(X(ML(jMv,1),:)-X(ML(jMv,2),:)))';
            else
                mv=0;
            end
        else
            mv=0;
        end
        Cv=(ZC*ones(1,d).*X(CL(:,1),:)*w0-ZC*ones(1,d).*X(CL(:,2),:)*w0)-abs(X(CL(:,1),:)*w0+X(CL(:,2),:)*w0);
        jCv= Cv<1;
        if jCv
            cv=-sum((ZC(jCv)*ones(1,d).*X(CL(jCv,1),:)-ZC(jCv)*ones(1,d).*X(CL(jCv,2),:))-abs(X(CL(jCv,1),:)+X(CL(jCv,2),:)))';
        else
            cv=0;
        end
        if u
            UZv=2*Y*ones(1,d).*X(U,:)*w0;
            jUZv= UZv<1;
            if jUZv
                uzv=-sum(2*Y(jUZv)*ones(1,d).*X(U(jUZv),:))';
            else
                uzv=0;
            end
            dw=lamda*w0+(mv+cv)/(LM+LC)+C/u*uzv;
        else
            dw=lamda*w0+(mv+cv)/(LM+LC);
        end
        w12=w0-dw/lamda/r;
        w1=min(1,sqrt((1+delta)/lamda)/norm(w12))*w12;
        if norm(w0-w1)<0.01
            w0=w1;
            break
        elseif r>500
            %t,r
            break
        end
        w0=w1;
        r=r+1;
    end
    if norm(w0-wlast)^2<0.01
        break
    elseif t>50
        %t
        break
    end
    t=t+1;
end


% move w back
w=[w0;-Xmean*w0];
end

