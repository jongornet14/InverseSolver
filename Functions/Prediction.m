function Y = Prediction(Bx,By,f,x_i_,z,num_F,pArray,dim)

F  = f.F;
S  = f.S;

Y = zeros(2,dim,length(x_i_));

x_i_ = sort(x_i_);

for dd = 1:dim
for k = 1:length(x_i_)    

    Fx = sum(S(FunctionSummation(Bx,F,x_i_(dd,:),num_F))./pArray(dd,k));
    
    y_j_ = Sample(cumsum(f.p_y_x(z,x_i_(dd,k))./sum(f.p_y_x(z,x_i_(dd,k)))),z(dd,:),1);
    
    Y(1,dd,k) = x_i_(dd,k);
    Y(2,dd,k) = Fx.*S(FunctionSummation(By,F,y_j_,num_F));

end
    Y(2,dd,:) = Y(2,dd,:)./sum(Y(2,dd,:));
end

end