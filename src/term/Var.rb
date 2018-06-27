require_relative "./Term"
require_relative '../error/NoRuleApplies'
require_relative '../error/LCTypeError'

class Var < Term
    attr_reader :idx

    def initialize(idx, existBracket=false)
        @idx = idx
        @existBracket = existBracket
    end

    def termShift(d, c=0)
        idx = @idx
        idx += d if idx >= c
        Var.new(idx, @existBracket)
    end

    def termSubst(j, s, c=0)
        if @idx == j + c
            s.termShift(c)
        else
            self
        end
    end

    def eval1(ctx)
        raise NoRuleApplies
    end

    def isVal
        false
    end

    def type(ctx=[], venv=[], cenv={})
        if venv[@idx]
            venv[@idx]
        else
            raise LCTypeError.new('TypeError on Var')
        end
    end

    def to_s(ctx=[])
        structTerm("#{ctx[@idx]}")
    end

    def to_ds
        structTerm("#{@idx}")
    end
end