function dfull = f(t, statepluscontrol, g, m, l, E0)

state   = statepluscontrol(1:4, :);
control = statepluscontrol(5:end, :);

dstate = otp.pendulumdae.fdifferential(t, state, g, m, l, E0) ...
    - otp.pendulumdae.constraintsjacobian(t, state, g, m, l, E0).'*control;

c = otp.pendulumdae.constraints(t, state, g, m, l, E0);

dfull = [dstate; c];

end
