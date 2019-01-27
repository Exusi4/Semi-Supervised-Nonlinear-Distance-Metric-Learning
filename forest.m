classdef forest
    properties
        ntrees    %number of trees
        minsize   %minimum number of samples in one node to continue spliting
        ML        %3-D matrix; must-link constrain; 
        CL        %3-D matrix; cannot-link constrain;
        node      %[t,l,isleaf,parent]
        w         %3-D matrix; weight on each node; [l,wtl]
    end
end