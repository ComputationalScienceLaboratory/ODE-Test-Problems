function j = jacdiffusion(~, u, epsilon, L)

j = blkdiag(L, L, L);

end
