function j = jacdiffusion(~, ~, ~, L)

j = blkdiag(L, L, L);

end
