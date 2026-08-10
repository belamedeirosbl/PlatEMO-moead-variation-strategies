function OffDec = OperatorSBXOnly(Problem, Parent)

    [proC, disC] = deal(1, 20);

    Parent = Parent.decs;
    Parent1 = Parent(1, :);
    Parent2 = Parent(2, :);

    D       = size(Parent1, 2);
    OffDec  = zeros(1, D);

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);

    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        P1  = Parent1(idx);
        P2  = Parent2(idx);
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);

        n  = length(idx);
        mu = rand(1, n);
        beta = zeros(1, n);
        beta(mu <= 0.5) = (2 .* mu(mu <= 0.5)) .^ (1 / (disC + 1));
        beta(mu > 0.5)  = (2 - 2 .* mu(mu > 0.5)) .^ (-1 / (disC + 1));
        beta = beta .* (-1) .^ randi([0, 1], 1, n);
        beta(rand(1, n) < 0.5) = 1;
        if rand > proC
            beta(:) = 1;
        end

        OffDec(idx) = (P1 + P2) / 2 + beta .* (P1 - P2) / 2;
        OffDec(idx) = min(max(OffDec(idx), lo), hi);
    end

    if ~isempty(Type{3}), OffDec(Type{3}) = Parent1(Type{3}); end
    if ~isempty(Type{4}), OffDec(Type{4}) = Parent1(Type{4}); end
    if ~isempty(Type{5}), OffDec(Type{5}) = Parent1(Type{5}); end
end