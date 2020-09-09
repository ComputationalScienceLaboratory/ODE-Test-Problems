function jv = javp(~, u, v, k, k2, k4)

jv = -k2.*v - k4.*v - fft(real(ifft(u)).*ifft(conj(k).*v));

end
