function Otl=TreeNeighbors(t,l,x,k0)
    global Node
    tree=Node(Node(:,1)==t,:);
    %check is l is a leaf node
    node=tree(tree(:,2)==l,:);
    node_size=node(4);
    if node(5)==1    %l is a leaf node
        xinleaf=node(7:7+node_size-1);
        if node_size>=k0  %choose k0 points in the leaf randomly
            temp=randperm(node_size);
            Otl=xinleaf(temp(1:k0));
        else
            % find the parent of l
            parent_l=node(3);
            parent=tree(tree(:,2)==parent_l,:);
            parent_size=parent(4);
            xinparent=parent(7:7+parent_size-1);
            temp=randperm(parent_size);
            Otl=xinparent(temp(1:k0));
        end
    else    %l is not a leaf node
        %retrive split features
        global Feature
        tree_feature=Feature(Feature(:,1)==t,:);
        node_feature=tree_feature(tree_feature(:,2)==l,:);
        feature=node_feature(3:end);
        xd=x(feature);
        %retrive corresponding w
        global W
        w=W(W(:,1,t)==l,2:end,t);
        label=[xd 1]*w';
        sibling=tree(tree(:,3)==l,:);
        if label>0
            Stl=sibling(sibling(:,6)==1,:);
            s_l=Stl(2);
        else
            Stl=sibling(sibling(:,6)==-1,:);
            s_l=Stl(2);
        end
        Otl=TreeNeighbors(t,s_l,x,k0);
    end
end
        
            
            
            
            
            