function OffDec = OperatorNMSOnly(Problem, Parent)
    [alpha, gamma, beta] = deal(1.0, 2.0, 0.5);

    ParentDec = Parent.decs;
    ParentObj = Parent.objs;
    n         = size(ParentDec, 1);
    D         = size(ParentDec, 2);

    OffDec = ParentDec(1, :);   % fallback

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);
    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);

        w_uniform = ones(1, size(ParentObj, 2)) / size(ParentObj, 2);
        scores    = max(ParentObj .* w_uniform, [], 2);
        [~, ord]  = sort(scores);                  % melhor primeiro
        sorted    = ParentDec(ord, idx);

        n_best = max(1, n - 1);
        xc     = mean(sorted(1:n_best, :), 1);     % [1 x d]
        xw     = sorted(end, :);                    % pior vizinho

        r = rand;
        if r < 0.4
            % Reflexao
            xnew = (1 + alpha) .* xc - alpha .* xw;
        elseif r < 0.6
            % Expansao
            xnew = (1 + alpha*gamma) .* xc - alpha*gamma .* xw;
        elseif r < 0.8
            % Contracao externa
            xnew = (1 + alpha*beta) .* xc - alpha*beta .* xw;
        else
            % Contracao interna
            xnew = (1 - beta) .* xc + beta .* xw;
        end

        OffDec(idx) = min(max(xnew, lo), hi);
    end

    if ~isempty(Type{3}), OffDec(Type{3}) = ParentDec(1, Type{3}); end
    if ~isempty(Type{4}), OffDec(Type{4}) = ParentDec(1, Type{4}); end
    if ~isempty(Type{5}), OffDec(Type{5}) = ParentDec(1, Type{5}); end
end