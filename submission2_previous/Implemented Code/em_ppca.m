%% Principal Component Analysis Based On Expectation Maximization Algorithm
function [W,sigma_square,Xn,t_mean,M] = em_ppca(t,k)

% Check dimenality Constraint
if k<1 |  k>size(t,2)
   error('Number of PCs must be integer, >0, <dim');
end

%No of Iteration
iter = 20;

% find height and width of data matrix
[height,width] = size(t); 

% Find mean value of [t1 t2 ... tm]
% Mind mean vector of observed data vectors
t_mean = (sum(t(:,1:width)')')/width; 

% Normalize Data matrix
t = t - (t_mean)*ones(1,width);

% Initialy W and sigma^2 will be randomly selected.
W = randn(height,k);
sigma_square = randn(1,1);

disp('EM Algorithm running...');
for i=1:iter
    % Find M = W'W + Sigma^2*I
    M = W'*W + sigma_square*eye(k,k); 
    
    % Find inverse of M
    In_M = inv(M);     
    
    % Expected Xn
    Xn = zeros(k,width); 
    Xn_Xn_T = zeros(k,k); 
    for i=1:width
       Xn(:,i) = (In_M)*W'*t(:,i); 
        % Find Expected of XnXn'
       Xn_Xn_T = Xn_Xn_T + (sigma_square*(In_M) + Xn(:,i)*(Xn(:,i)')); 
    end
        
    % Take Old value of W
    old_W = W;
       
    temp1 = zeros(height,k);
    for i=1:width
        temp1 = temp1 + t(:,i)*(Xn(:,i)');
    end
    
    % Take new value of W
    W = (temp1)*inv(Xn_Xn_T); 

    sum11 = 0;
    for i=1:width
        temp2 = sigma_square*(In_M) + Xn(:,i)*(Xn(:,i)');
        sum11 = sum11 + (norm(t(:,1))^2 - 2*(Xn(:,i)')*(W')*(t(:,i)) + trace(temp2*(W')*W));
    end    
    sigma_square = sum11/(width*height);
end

disp('EM Algorithm completed. W is created. Press enter to continue...');
pause;

% Find M = W'W + sigma^2*I
M = W'*W + sigma_square*eye(k,k);
% Inverse of M
In_M = inv(M); 
% Latent Variable Xn
Xn = (In_M)*W'*t; 

disp('Principal Component are ready...press enter to continue...');
pause;

end