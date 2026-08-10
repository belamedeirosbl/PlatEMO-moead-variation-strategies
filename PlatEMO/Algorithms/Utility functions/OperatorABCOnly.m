function OffDec = OperatorABCOnly(Problem, Parent)

    ParentDec = Parent.decs;            
    [T, D]    = size(ParentDec);

    % x_i: primeira linha (solução atual do subproblema i)
    xi = ParentDec(1, :);

    % x_k: vizinho aleatório k != i (linha aleatória das demais)
    k  = randi(T - 1) + 1;             
    xk = ParentDec(k, :);

    OffDec = xi;                      

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);

    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];

        d = idx(randi(length(idx)));

        phi = -1 + 2 * rand();        

        OffDec(d) = xi(d) + phi * (xi(d) - xk(d));

        % Clipa nos limites
        OffDec(d) = min(max(OffDec(d), Problem.lower(d)), Problem.upper(d));
    end

end