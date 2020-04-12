function varargout=caret_makemedialwall_flat(hem)
% function varargout=caret_makemedialwall_flat(hem)
% Generates flat medial wall representation 
% caret_makemedialwall_flat('lh')
% caret_makemedialwall_flat('rh')

C=caret_load([hem '.INFLATED.coord']);
T=caret_load([hem '.CLOSED.topo']);

TC=T; 
TC.perimeter_id={'CUT'};
TC=rmfield(TC,'header');

CF=C; 
CF.configuration_id={'FLAT'}; 
CF=rmfield(CF,'header');
CF.topo_file=[hem '.MEDIAL.topo'];
switch (hem)
    case 'lh'
        i=C.data(:,1)>21;
        CF.data=[C.data(:,2:3) zeros(size(C.data,1),1)]; 
    case 'rh'
        i=C.data(:,1)<-21.5;
        CF.data=[-C.data(:,2) C.data(:,3) zeros(size(C.data,1),1)]; 
end; 
CF.data(~i,:)=0;
indx=find(i); 

A=false(size(T.data));
length(indx)
for j=1:length(indx)
    A=A | T.data==indx(j);
    if (mod(j,1000)==0)
        fprintf('%d\n',j); 
    end; 
end;
TC.data=T.data(all(A,2),:);
TC.num_tiles=size(TC.data,1);

caret_save([hem '.MEDIAL.coord'],CF);
caret_save([hem '.MEDIAL.topo'],TC);