function OffDec = OperatorMMOPSOOnly(Problem, Parent)
    [w, c1, c2, delta] = deal(0.3, 1.5 + rand*0.5, 1.5 + rand*0.5, 0.9);

    ParentDec = Parent.decs;
    n         = size(ParentDec, 1);   
    x         = ParentDec(1, :);      
    D         = size(x, 2);

    OffDec = x;

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);
    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);

        pbest_idx = 1; 
        objs = Parent.objs;
        if size(objs, 1) > 1
            scores = sum(objs, 2);
            [~, pbest_idx] = min(scores);
        end
        x_pbest = ParentDec(pbest_idx, idx);

        gbest_idx = randi(n);
        x_gbest   = ParentDec(gbest_idx, idx);

        v = x(idx) - x(idx);   % zero — sem histórico disponível

        r1 = rand(1, length(idx));
        r2 = rand(1, length(idx));

        if rand < delta
            v_new = w .* v + c1 .* r1 .* (x_pbest - x(idx));
        else
            v_new = w .* v + c2 .* r2 .* (x_gbest - x(idx));
        end

        OffDec(idx) = x(idx) + v_new;
        OffDec(idx) = min(max(OffDec(idx), lo), hi);
    end

    if ~isempty(Type{3}), OffDec(Type{3}) = x(Type{3}); end
    if ~isempty(Type{4}), OffDec(Type{4}) = x(Type{4}); end
    if ~isempty(Type{5}), OffDec(Type{5}) = x(Type{5}); end
end