function jv = jvp(~, u, v, k, k24)

jv = -k24.*v - k.*fft(real(ifft(u)).*ifft(v));

end
