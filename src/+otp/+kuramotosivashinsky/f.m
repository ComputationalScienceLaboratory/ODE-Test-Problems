function ut = f(~, u, k, k2, k4)

u2 = fft(real(ifft(u)).^2);

ut = - k2.*u - k4.*u -(k/2).*u2;

end
