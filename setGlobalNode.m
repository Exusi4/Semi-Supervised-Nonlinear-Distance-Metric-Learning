function setGlobalNode(t,l,lp,size_x,isleaf,label,N)
    global Node
    global noden
    Node(noden,1:size(N,1)+6)=[t,l,lp,size_x,isleaf,label,N'];
    noden=noden+1;
end