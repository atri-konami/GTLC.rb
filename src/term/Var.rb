require_relative './Term'
require_relative './Cast'
require_relative '../error/NoRuleApplies'
require_relative '../error/LCTypeError'

class Var < Term
    attr_reader :idx

    def initialize(idx)
        @idx = idx
    end

    def termShift(d, c=0)
        idx = @idx
        idx += d if idx >= c
        Var.new(idx)
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
        true
    end

    def type(ctx)
        ctx.typesAt(@idx) || (raise LCTypeError.new('TypeError on Var'))
    end

    def toCast(ctx)
        self
    end

    def to_s(ctx)
        "#{ctx[@idx]}"
    end

    def to_ds
        "#{@idx}"
    end
end