function runalltests(varargin)


p = inputParser;
addParameter(p, 'TestPlots', true);
addParameter(p, 'TestMovies', false);

parse(p, varargin{:});

s = p.Results;

testplots  = s.TestPlots;
testmovies = s.TestMovies;

fprintf('\n   Running all tests \n\n');

validateallpresets;
validateallderivatives;

if testplots || testmovies
    validateallplots(testplots, testmovies);
end


%% Problem specific tests
problemtests.validateqg;

end
