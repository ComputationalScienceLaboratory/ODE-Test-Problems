function jv = javp(~, u, v, k, k24)

jv = -k24.*v - fft(real(ifft(u)).*ifft(conj(k).*v));

end
