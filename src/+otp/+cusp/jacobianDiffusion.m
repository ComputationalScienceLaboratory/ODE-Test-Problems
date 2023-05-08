function j = jacobianDiffusion(~, L)

j = blkdiag(L, L, L);

end
