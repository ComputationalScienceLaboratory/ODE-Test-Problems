function dfull = jacobianVectorProduct(t, statepluscontrol, g, m, l, E0, v)

state   = statepluscontrol(1:4, :);
control = statepluscontrol(5:end, :);

vstate = v(1:4, :);
vcontrol = v(5:end, :);

dstate = otp.pendulumdae.jacobianDifferentialVectorProduct(t, state, g, m, l, E0, vstate) ...
    - otp.pendulumdae.invariantsHessianAdjointVectorProduct(t, state, g, m, l, E0, control, vstate) ...
    - otp.pendulumdae.invariantsJacobianAdjointVectorProduct(t, state, g, m, l, E0, vcontrol);

c = otp.pendulumdae.invariantsJacobianVectorProduct(t, state, g, m, l, E0, vstate);

dfull = [dstate; c];

end
