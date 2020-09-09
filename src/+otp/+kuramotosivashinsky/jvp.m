function jv = jvp(~, u, v, k, k2, k4)

jv = -k2.*v - k4.*v - k.*fft(real(ifft(u)).*ifft(v));

end
