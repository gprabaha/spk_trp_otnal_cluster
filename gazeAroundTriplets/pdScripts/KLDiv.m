function dist=KLDiv(P,Q)
%  dist = KLDiv(P,Q) Kullback-Leibler divergence of two discrete probability
%  distributions
%  P and Q  are automatically normalised to have the sum of one on rows
% have the length of one at each 
% P =  n x nbins
% Q =  1 x nbins or n x nbins(one to one)
% dist = n x 1



if size(P,2)~=size(Q,2)
    error('the number of columns in P and Q should be the same');
end

if sum(~isfinite(P(:))) + sum(~isfinite(Q(:)))
   error('the inputs contain non-finite values!') 
end

% % normalizing the P and Q
% if size(Q,1)==1
%     Q = Q ./sum(Q);
%     P = P ./repmat(sum(P,2),[1 size(P,2)]);
%     dist =  sum(P.*log(P./repmat(Q,[size(P,1) 1])),2);
%     
% elseif size(Q,1)==size(P,1)
%     
%     Q = Q ./repmat(sum(Q,2),[1 size(Q,2)]);
%     P = P ./repmat(sum(P,2),[1 size(P,2)]);
%     dist =  sum(P.*log(P./Q),2);
% end

% resolving the case when P(i)==0
%dist(isnan(dist))=0;

Q = Q ./repmat(sum(Q,2),[1 size(Q,2)]);
P = P ./repmat(sum(P,2),[1 size(P,2)]);
M=log(P./Q);
M(isnan(M))=0;
dist = sum(P.*M,2);


end
% 
% The works for me only after making the correction suggested by Kimberly. Note that her correction replaces lines 29-31 in the original KLDiv function. The last part of the original code containing:
% 
% % resolving the case when P(i)==0
% dist(isnan(dist))=0;
% 
% Does anyone know why Jensen-Shannon divergence is not included as a standard option in Matlab's clustering algorithms?
% 
% Kimberly
% 15 Sep 2009
% 
% Hi ... thanks very much for writing this code and taking the time to post it! I had some trouble in the case where at least one of the entries of P and Q are both 0. In this case the last line of KLdiv.m:
% 
% % resolving the case when P(i)==0
% dist(isnan(dist))=0;
% 
% sets the divergence to 0, which is clearly not the case e.g. if P = [1 0 1], Q = [0 0 1].
% 
% I would suggest changing the last few lines to:
% 
% 
% Q = Q ./repmat(sum(Q,2),[1 size(Q,2)]);
% P = P ./repmat(sum(P,2),[1 size(P,2)]);
% M=log(P./Q);
% M(isnan(M))=0;
% dist = sum(P.*M,2);
% end
% 
% which seems to work for me.
% 
