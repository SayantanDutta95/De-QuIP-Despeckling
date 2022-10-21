function ima = reprojection_UWA(ima_patchs,xg,yg)

    % find size of image patchs
    [M, N, P] = size(ima_patchs);
    if nargin <= 2
        xg = zeros(M,N);
        yg = zeros(M,N);
    end
    
    p = sqrt(P); % row and column size of each patch
    
    ima = zeros(M+p-1, N+p-1); % creat space for the denoised image
    norm = zeros(M+p-1, N+p-1); % creat space for the normalization
    
    for i = 1:M
        for j = 1:N
            
          % choose a range
          xrange = mod(round((i-1)+(1:p)+xg(i,j))-1,M+p-1)+1;
          yrange = mod(round((j-1)+(1:p)+yg(i,j))-1,N+p-1)+1;
            
          % take the set of patchs
          ima(xrange, yrange) = ima(xrange, yrange) + reshape(ima_patchs(i,j,:), p, p);
          
          % Count the number of repetition of patchs
          norm(xrange, yrange) = norm(xrange, yrange) + 1;
          
        end
    end
    
    % final reconstructed image after normalizing
    ima = ima ./ norm;
    
    clear norm;
    
end
