# Semi-Supervised-Nonlinear-Distance-Metric-Learning
https://arxiv.org/pdf/1402.5565.pdf

tree.m is the only main function.You will see import data part when you open it.
x should be given N*d matrix, where N is the number of data and d is the number of feature.
y should be given N*1 matrix, which is the labels of corresponding data, and the labels should be either 1 or -1.
These two are the all import data, with which the function will show a picture of classification accuracy of HFD-KNN and normal KNN (k from 1 to 10).

Before import data part in the script are the parameters.
minisize 	the maximum data number in each leaf node
T		the number of trees
k0		the number of nearest neighbour we will take in each tree
K_nearest	the upper bound of the k we test
train_rate	the ratio of train data number to all data number, others will be the test data

one should be carefull of changing first four parameters since they are closely dependent.
T*k0>=K_nearest	cause there may be same nearest neighbour from different tree. Actually it will overlap a lot.
The relation between k0 and minsize is more complicated, because we only take nearest neighbour from the same leaf node and the parent of it.

Introduction of the algorithm
When we run tree.m, first it will add index of x to its first column. We use these index to track each x goes which node in each tree. Same to y. After claiming several global variables, we start build tree process.
When we call BuildTree.m, it will split features first and randomly choose which feature to use at this node. Then either call SSMMC.m or MRMMC.m to split data and get the w at this node. Then just decide to whether iterate or go out. setGlobalW.m, setGlobalNode.m and setGlobalFeature.m are also apllied here to save the key parameter of trees.
At last it is the HFD-KNN part. We call TreeNeighbous.m to get the nearest k0 data of the test one from each tree. The 'nearest data' means data from same leaf node here. Then we calculate the HFDistance of these data and the test one to decide the nearest k data. We call InferDistance.m here and it will call TreeDistance.m. Then We do a majority voting to decide the label of test data and compare the accuracy with normal KNN.

---Important---

Sometimes Matrix of Mustlink and Cannotlink are not invertible (by definition they are PD and invertible, but in practice because of float computation of MATLAB, they are sometimes not), so you may need multiple attempts... :-(
