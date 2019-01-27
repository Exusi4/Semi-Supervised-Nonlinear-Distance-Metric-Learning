function [ D ] = InferDistance( a,b,T )
%INFERDISTANCE Summary of this function goes here
%   Detailed explanation goes here

D=0;
for t=1:T
    D=D+TreeDistance(t,1,a,b);
end
D=D/T;
end

