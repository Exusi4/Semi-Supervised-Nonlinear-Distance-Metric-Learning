function BuildTree(t,X,ML,CL,minsize,dk)
    % select features
    global l;
    perm_feature=randperm(size(X,2)-1)+1;
    feature=sort(perm_feature(1:dk));
    setGlobalFeature(t,l,feature);
    xk=X(:,feature);
    
    % learnsplit
    if isempty(CL)
        w=MRMMC(xk)';
    else
        MLN=zeros(size(ML));
        CLN=zeros(size(CL));
        for i=1:size(X,1)
            MLN(ML==X(i,1))=ML(ML==X(i,1))*i/X(i,1);
            CLN(CL==X(i,1))=CL(CL==X(i,1))*i/X(i,1);
        end
        w=SSMMC(xk,MLN,CLN)';
    end
    setGlobalW(t,l,w);
    yh=[xk,ones(size(xk,1),1)]*w';
    
    %creat child-node, cl
    l_parent=l;   %record parent node
    cl=X(yh<=0,:);
    %disp(size(cl));
    l=l+1;
    %disp(l);
    if size(cl,1)>minsize
        isleaf=0;
        label=-1;
        setGlobalNode(t,l,l_parent,size(cl,1),isleaf,label,cl(:,1));
    %determine must-link and cannot-link constrain of Cl
        idx=1;
        ML_cl=zeros(size(ML));
        for i=1:size(ML)
            if ~isempty(find(cl(:,1)==ML(i,1))) && ~isempty(find(cl(:,1)==ML(i,2)))
                ML_cl(idx,:)=ML(i,:);
                idx=idx+1;
            end
        end
        ML_cl=ML_cl(1:idx-1,:); 
        idx=1;
        CL_cl=zeros(size(CL));
        for i=1:size(CL)
            if ~isempty(find(cl(:,1)==CL(i,1))) && ~isempty(find(cl(:,1)==CL(i,2)))
                CL_cl(idx,:)=CL(i,:);
                idx=idx+1;
            end
        end
        CL_cl=CL_cl(1:idx-1,:);
        BuildTree(t,cl,ML_cl,CL_cl,minsize,dk);
     else
         isleaf=1;
         label=-1;
         setGlobalNode(t,l,l_parent,size(cl,1),isleaf,label,cl(:,1));
         %setGlobalLeaf(t,l,cl(:,1));
    end
    
    cr=X(yh>0,:);
    l=l+1;
    %disp(l);
    if size(cr,1)>minsize
        isleaf=0;
        label=1;
        setGlobalNode(t,l,l_parent,size(cr,1),isleaf,label,cr(:,1));
        %disp(size(cr,1));
%determine must-link and cannot-link constrain of Cl and Cr
        idx=1;
        ML_cr=zeros(size(ML));
        for i=1:size(ML)
            if ~isempty(find(cr(:,1)==ML(i,1))) && ~isempty(find(cr(:,1)==ML(i,2)))
                ML_cr(idx,:)=ML(i,:);
                idx=idx+1;
            end
        end
        ML_cr=ML_cr(1:idx-1,:); 
        idx=1;
        CL_cr=zeros(size(CL));
        for i=1:size(CL)
            if ~isempty(find(cr(:,1)==CL(i,1))) && ~isempty(find(cr(:,1)==CL(i,2)))
                CL_cr(idx,:)=CL(i,:);
                idx=idx+1;
            end
        end
        CL_cr=CL_cr(1:idx-1,:);
        BuildTree(t,cr,ML_cr,CL_cr,minsize,dk);
     else
         isleaf=1;
         label=1;
         setGlobalNode(t,l,l_parent,size(cr,1),isleaf,label,cr(:,1));
         %setGlobalLeaf(t,l,cr(:,1));
    end
end

