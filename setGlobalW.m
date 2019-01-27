function setGlobalW(t,l,w)
global W
global wn
W(wn(t),:,t)=[l,w];
wn(t)=wn(t)+1;
end
