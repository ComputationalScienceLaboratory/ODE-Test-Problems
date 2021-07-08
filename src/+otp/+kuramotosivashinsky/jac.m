function j = jac(~, u, k, k24)

j = -diag(k24) - k.*ifft(fft(diag(ifft(u))).').';

end
