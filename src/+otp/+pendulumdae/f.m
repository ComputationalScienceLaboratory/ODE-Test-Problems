function dfull = f(t, statepluscontrol, g, m, l, E0)

state   = statepluscontrol(1:4, :);
control = statepluscontrol(5:end, :);

dstate = otp.pendulumdae.fDifferential(t, state, g, m, l, E0) ...
    - otp.pendulumdae.jacobianAdjointVectorProductAlgebraic(t, state, g, m, l, E0, control);

c = otp.pendulumdae.fAlgebraic(t, state, g, m, l, E0);

dfull = [dstate; c];

end
