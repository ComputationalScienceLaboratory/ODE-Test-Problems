function j = jacobiandiffusion(~, L)

j = blkdiag(L, L, L);

end
