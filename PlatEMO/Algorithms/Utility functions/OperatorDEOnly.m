function OffDec = OperatorDEOnly(Problem, Parent)
    [CR, F] = deal(1, 0.5);
    ParentDec = Parent.decs;
    Parent1   = ParentDec(1, :);
    Parent2   = ParentDec(2, :);
    Parent3   = ParentDec(3, :);
    D         = size(Parent1, 2);
    OffDec    = Parent1;
    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);
    if ~isempty([Type{1:2}])
        idx  = [Type{1:2}];
        lo   = Problem.lower(idx);
        hi   = Problem.upper(idx);
        Site = rand(1, length(idx)) < CR;
        OffDec(idx(Site)) = Parent1(idx(Site)) + F .* (Parent2(idx(Site)) - Parent3(idx(Site)));
        OffDec(idx) = min(max(OffDec(idx), lo), hi);
    end
    if ~isempty(Type{3}), OffDec(Type{3}) = Parent1(Type{3}); end
    if ~isempty(Type{4}), OffDec(Type{4}) = Parent1(Type{4}); end
    if ~isempty(Type{5}), OffDec(Type{5}) = Parent1(Type{5}); end
end