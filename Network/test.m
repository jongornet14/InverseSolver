z = 0:0.01:10;
pert = ones(1,length(z));
signal = sin(z)./z+(1+1e-10).*z;

id = find(isnan(signal));
signal(id) = 1;

params.fx_i = pert./sum(pert);
params.fy_j = signal./sum(signal);

params.fF = (1+1e-10).*z./sum(signal);

figure
subplot(2,1,1)
plot(z,params.fx_i);
subplot(2,1,2)
plot(z,params.fy_j-params.fF)

%pert = (pert-min(pert))./(max(pert)-min(pert));
signal = (signal-min(signal))./(max(signal)-min(signal));

x_i = NyquistSample(z,pert);
y_j = NyquistSample(z,signal);

Rx = randi([1 length(x_i)],[1 1e6]);
Ry = randi([1 length(y_j)],[1 1e6]);

x_i = x_i(Rx);
y_j = y_j(Ry);

%%
Z = transpose(z);

dz = mean(diff(z));

r0 = sum(exp(-(Z-x_i).^2),2);
r0 = r0./sum(r0);

for ii = 1:length(x_i)
    
    r = rand;
    
    [c,index] = min(abs(r-cumsum(r0)));
    x_i_(ii) = z(index);
    p_x_i_(ii) = r;
    
end

P_Y_X = conv(TransitionFunction(z,0),r0);
P_Y_X = P_Y_X(1:length(z)).*dz;

Y = NyquistSample(Z,P_Y_X);

R = randi([1 length(Y)],[1 1e5]);
y_j_ = Y(R);

bins = linspace(z(1),z(end),1e2);
mapX = hist(x_i,bins);
mapY = hist(y_j,bins);
mapZ = hist(y_j_,bins);

mapX = mapX./sum(mapX);
mapY = mapY./sum(mapY);
mapZ = mapZ./sum(mapZ);

%%

figure
subplot(3,1,1)
plot(bins,mapX)
subplot(3,1,2)
plot(bins,mapY-max(mapY)./10.*bins)
subplot(3,1,3)
plot(bins,mapZ-max(mapZ)./10.*bins)

%%

params.x_i = x_i;
params.y_j = y_j;

params.Wx = vals.Wx;
params.Wy = vals.Wy;

[vals] = InverseSolver(params);

%%

figure
subplot(2,1,1)
plot(z,(params.fy_j-params.fF)./sum(params.fy_j-params.fF),'b');
hold on
plot(vals.z,vals.mapZ-vals.z.*(max(vals.mapZ)./(10)),'r')
%legend('$$\{y_j\}$$ Distribution','$$\{y_j\}$$ Predication','Interpreter','latex')
xlabel('$$x$$ Space','Interpreter','latex');ylabel('$$p(\{y_j\})$$','Interpreter','latex');title('Initiatial Prediction','Interpreter','latex')
subplot(2,1,2)
plot(z,(params.fy_j-params.fF)./sum(params.fy_j-params.fF),'b');
hold on
plot(vals.z,vals.pred-vals.z.*(max(vals.pred)./(10)),'k');
%legend('$$\{y_j\}$$ Distribution','$$\{y_j\}$$ Prediction','Interpreter','latex')
xlabel('$$x$$ Space','Interpreter','latex');ylabel('$$p(\{y_j\})$$','Interpreter','latex');title('Trained Prediction','Interpreter','latex')

%%

figure
%subplot(2,1,1)
plot(vals.z,vals.p_y_x)