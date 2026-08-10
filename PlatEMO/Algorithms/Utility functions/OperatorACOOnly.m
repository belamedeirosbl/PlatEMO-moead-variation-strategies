function OffDec = OperatorACOOnly(Problem, Parent)

    Delta = 0.05;                          

    ParentDec = Parent.decs;            
    xi        = ParentDec(1, :);            
    D_full    = size(ParentDec, 2);

    OffDec = xi;                        

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);

    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);

        X   = ParentDec(:, idx);         

        tau = mean(X, 1);                   % [1 x |idx|]

        mu  = tau + Delta * (xi(idx) - tau);

        sigma = std(X, 0, 1);
        sigma = max(sigma, 1e-6 * (hi - lo)); % evita sigma = 0

        v = mu + sigma .* randn(1, length(idx));

        OffDec(idx) = min(max(v, lo), hi);
    end
end