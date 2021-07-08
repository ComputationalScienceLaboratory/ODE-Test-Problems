function ut = f(~, u, k, k24)

u2 = fft(real(ifft(u)).^2);

ut = -k24.*u - (k/2).*u2;

end
