function runalltests(testgui)

if nargin < 1
    testgui = false;
end


% set warnings off
warning off;

fprintf('\n   Running all tests \n\n');

validateallpresets;
validateallderivatives;

if testgui
    validateallplots;
end


end
