function dfull = jacobianVectorProduct(t, statepluscontrol, g, m, l, E0, v)

state   = statepluscontrol(1:4, :);
control = statepluscontrol(5:end, :);

vstate = v(1:4, :);
vcontrol = v(5:end, :);

dstate = otp.pendulumdae.jacobianVectorProductDifferential(t, state, g, m, l, E0, vstate) ...
    - otp.pendulumdae.hessianAdjointVectorProductAlgebraic(t, state, g, m, l, E0, control, vstate) ...
    - otp.pendulumdae.jacobianAdjointVectorProductAlgebraic(t, state, g, m, l, E0, vcontrol);

c = otp.pendulumdae.jacobianVectorProductAlgebraic(t, state, g, m, l, E0, vstate);

dfull = [dstate; c];

end
