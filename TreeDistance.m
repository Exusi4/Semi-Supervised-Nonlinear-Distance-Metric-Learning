function [ dis ] = TreeDistance( t,l,a,b )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% 
%   parameter alpha=0.05 distance calculation
% 
%   Input:  t index of tree
%           l index of node
%           a 1*d 
%           b 1*d
%   Output: dis distance between a and b




global Node
global Feature
global W
alfa=0.05;
tree=Node(Node(:,1)==t,:);
%check is l is a leaf node
node=tree(tree(:,2)==l,:);


if node(5)==1    %l is a leaf node
    dis=0;
else
    %retrive split features
    tree_feature=Feature(Feature(:,1)==t,:);
    node_feature=tree_feature(tree_feature(:,2)==l,:);
    feature=node_feature(3:end);
    a_k=a(feature);
    b_k=b(feature);
    %retrive corresponding w
    w=W(W(:,1,t)==l,2:end,t);
    %sibling=tree(tree(:,3)==l,:);
    p_tla=[a_k 1]*w';
    p_tlb=[b_k 1]*w';

    if p_tla*p_tlb>0
        child_node=tree(tree(:,3)==l,:);
        next_node=child_node(child_node(:,6)==sign(p_tla),2);
        dis=TreeDistance(t,next_node,a,b);
    else
        node_size=node(4);
        pt=abs(1/(1+exp(alfa*p_tla))-(1/(1+exp(alfa*p_tlb))));
        dis=pt*node_size;
    end
end
end

