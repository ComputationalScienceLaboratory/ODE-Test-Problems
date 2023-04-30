passedTotal = 0;
failedTotal = 0;

[passed, failed] = otptests.validateallpresets;

passedTotal = passedTotal + passed;
failedTotal = failedTotal + failed;

[passed, failed] = otptests.validatederivatives;

passedTotal = passedTotal + passed;
failedTotal = failedTotal + failed;


fprintf('\n\n      %d/%d Tests passed\n', passedTotal, passedTotal + failedTotal)