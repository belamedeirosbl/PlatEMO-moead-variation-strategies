function OffDec = OperatorCMAESOnly(Problem, Parent)
    ParentDec = Parent.decs;
    n         = size(ParentDec, 1);  
    D         = size(ParentDec, 2);  
    OffDec = ParentDec(1, :);        

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);
    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);
        d   = length(idx);

        X = ParentDec(:, idx);   % matriz de vizinhos [n x d]

        m = mean(X, 1);          % [1 x d]

        if n >= 2
            Xc = X - m;                      
            C  = (Xc' * Xc) / (n - 1);       
        else
            C = eye(d);
        end

        sigma = mean(hi - lo) / 4;


        [V, Dmat] = eig(C);
        Dmat      = max(real(Dmat), 0);         
        sqrtC     = real(V * sqrt(Dmat) * V');

        z    = randn(1, d);
        xnew = m + sigma * (z * sqrtC);

        OffDec(idx) = min(max(xnew, lo), hi);
    end

    if ~isempty(Type{3}), OffDec(Type{3}) = ParentDec(1, Type{3}); end
    if ~isempty(Type{4}), OffDec(Type{4}) = ParentDec(1, Type{4}); end
    if ~isempty(Type{5}), OffDec(Type{5}) = ParentDec(1, Type{5}); end
end