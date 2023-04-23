function solExtend = odextend(sol, f, tfinal, y0, opts)
% OCTAVE FIX: naive odextend implementation to fix event function

% OCTAVE BUG: Octave solvers fail to detect an event sometimes
solNew = feval(sol.solver, f, [sol.x(end), tfinal], y0, opts);

solExtend.solver = sol.solver;

if sol.y(:, end) == solNew.y(:, 1)
    startIdx = 2;
else
    startIdx = 1;
end
solExtend.x = [sol.x, solNew.x(startIdx:end)];
solExtend.y = [sol.y, solNew.y(:, startIdx:end)];

if isfield(solNew, 'ie')
    % OCTAVE FIX: event data is transposed compared to MATLAB
    % For scalar problems with one event, it's ambiguous on how to join events. Since this function is typically called
    % by Octave, we choose vertical concatenation.
    if size(sol.ie, 1) > 1 || (isscalar(sol.ie) && size(sol.ye, 1) == 1)
        join = @vertcat;
    else
        join = @horzcat;
    end
    
    solExtend.ie = join(sol.ie, solNew.ie);
    solExtend.xe = join(sol.xe, solNew.xe);
    solExtend.ye = join(sol.ye, solNew.ye);
else
    solExtend.ie = sol.ie;
    solExtend.xe = sol.xe;
    solExtend.ye = sol.ye;
end

if isfield(sol, 'stats') && isfield(solNew, 'stats')
    stats = fieldnames(sol.stats);
    for i = 1:length(stats)
        stat = stats{i};
        solExtend.stats.(stat) = sol.stats.(stat) + solNew.stats.(stat);
    end
end

end
