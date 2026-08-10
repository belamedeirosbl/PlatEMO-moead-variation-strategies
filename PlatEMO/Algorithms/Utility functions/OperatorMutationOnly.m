function Offspring = OperatorMutationOnly(Problem, OffDec)

    [proM, disM] = deal(1, 20);

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);

    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);

        D    = length(idx);
        mu   = rand(1, D);
        Site = rand(1, D) < proM / D;

        temp = Site & mu <= 0.5;
        OffDec(idx(temp)) = OffDec(idx(temp)) + ...
            (hi(temp) - lo(temp)) .* ...
            ((2 .* mu(temp) + (1 - 2 .* mu(temp)) .* ...
            (1 - (OffDec(idx(temp)) - lo(temp)) ./ (hi(temp) - lo(temp))) .^ (disM + 1)) .^ (1 / (disM + 1)) - 1);

        temp = Site & mu > 0.5;
        OffDec(idx(temp)) = OffDec(idx(temp)) + ...
            (hi(temp) - lo(temp)) .* ...
            (1 - (2 .* (1 - mu(temp)) + 2 .* (mu(temp) - 0.5) .* ...
            (1 - (hi(temp) - OffDec(idx(temp))) ./ (hi(temp) - lo(temp))) .^ (disM + 1)) .^ (1 / (disM + 1)));

        OffDec(idx) = min(max(OffDec(idx), lo), hi);
    end

    Offspring = Problem.Evaluation(OffDec);
end