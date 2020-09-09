function j = jac(~, u, k, k2, k4)

j = -diag(k2) - diag(k4) - diag(k)*ifft(fft(diag(ifft(u))).').';

end
