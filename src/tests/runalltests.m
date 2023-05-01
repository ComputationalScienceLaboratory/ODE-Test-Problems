passedTotal = 0;
failedTotal = 0;

[passed, failed] = validateallpresets;

passedTotal = passedTotal + passed;
failedTotal = failedTotal + failed;

[passed, failed] = validatederivatives;

passedTotal = passedTotal + passed;
failedTotal = failedTotal + failed;


fprintf('\n\n      %d/%d Tests passed\n', passedTotal, passedTotal + failedTotal)