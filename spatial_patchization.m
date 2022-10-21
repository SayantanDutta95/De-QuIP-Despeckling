function [ima_patchs, ima_normalization] = spatial_patchization(im_ini,WP)
%spatial_patchization computes the collection of patches extracted from an image  

% image size
[m,n] = size(im_ini);
ima_patchs=zeros(m-WP+1,n-WP+1,WP^2);
ima_normalization=zeros(m,n);

% creat image patchs
for i=1:(m-WP+1)
    for j=1:(n-WP+1)
        xrange = mod((i:i+WP-1)-1,m)+1;
        yrange = mod((j:j+WP-1)-1,n)+1;
        B = im_ini(xrange, yrange);
        ima_patchs(i,j,:) = B(:);
        ima_normalization(xrange, yrange) = ...
            ima_normalization(xrange, yrange) + ones(WP,WP);
    end
end

end
