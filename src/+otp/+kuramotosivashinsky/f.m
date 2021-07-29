function ut = f(~, u, ik, k24)

ut = k24 .* u - (ik/2) .* fft(ifft(u).^2);

end
