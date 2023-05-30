eval(strcat('problem = otp.','bouncingball','.presets.','Canonical'))
filename = join(strsplit(problem.Name, ' '),''); 
sol      = problem.solve('RelTol', 1e-10);
mov      = problem.movie(sol, 'Save', 'filename');
