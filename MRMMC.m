function [ w ] = MRMMC( X )
%MRMMC Summary of this function goes here
%   Detailed explanation goes here

% Input: X N*d (without ones columns)
%
%       first move to zero mean
%       then calculate w0 d*1 by block coordinate descent
%       finally move w s.t. w'*[x;1]=0 is the boundary line
%
% Output: w (d+1)*1

%parameters
lamda=0.01;
delta0=1;
C=1;
[N,d]=size(X);
h=max(1,N/20);


%move to zero mean and initialize w0
Xmean=mean(X);
X=X-ones(N,1)*Xmean;
w0=randn(d,1);
S=X'*X;
k=1;
while 1
    w1=S*w0/norm(S*w0);
    if norm(w0-w1)<0.01
        w0=w1;
        break
    elseif k>1000
        w0=w1;
    end
    w0=w1;
    k=k+1;
end



% %block coordinate descent
% t=1;
% while 1
%     if t<4
%         delta=0;
%     else
%         delta=delta0;
%     end
%     wlast=w0;
%     [B,I]=sort(X*w0);
%     k=sum(B<0);
%     if k<h
%         k=h;
%     elseif k>N-h
%         k=N-h;
%     end
%     X=X(I,:);
%     Y=[-ones(k,1);ones(N-k,1)];
%     r=1;
%     while 1
%         UZv=2*Y*ones(1,d).*X*w0;
%         jUZv= UZv<1;
%         uzv=-sum(2*Y(jUZv)*ones(1,d).*X(jUZv,:))';
%         [~,Indexm]=sort(X(1:k,:)*w0);
%         [~,Indexp]=sort(X(k:N,:)*w0);
%         if -2*X(Indexm(h,1),:)*w0<1
%             bmv=X(Indexm(h,1),:)';
%         else
%             bmv=0;
%         end
%         if 2*X(Indexp(N-k-h+1,1),:)*w0<1
%             bpv=-X(Indexp(N-k-h+2,1),:)';
%         else
%             bpv=0;
%         end
%         dw=lamda*w0+C/N*uzv+(bmv+bpv)/h;
%         w12=w0-dw/lamda/r;
%         w1=min(1,sqrt((1+delta)/lamda)/norm(w12))*w12;
%         if norm(w0-w1)<0.01
%             w0=w1;
%             break
%         elseif r>1000
%             %t,r
%             break
%         end
%         w0=w1;
%         r=r+1;
%     end
%     if norm(w0-wlast)^2<0.01
%         break
%     elseif t>1000
%         %t
%         break
%     end
%     t=t+1;
% end



%move w back
w=[w0;-Xmean*w0];
end

