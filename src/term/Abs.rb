require_relative './Term'
require_relative '../type/Type'
require_relative '../type/Arrow'
require_relative '../error/NoRuleApplies'

class Abs < Term
    attr_reader :sym, :argType, :bod

    def initialize(sym, type, bod)
        @sym = sym
        @argType = type
        @bod = bod
    end

    def termShift(d, c=0)
        bod = @bod.termShift(d, c + 1)
        Abs.new(@sym, @argType, bod)
    end

    def termSubst(j, s, c=0)
        bod = @bod.termSubst(j, s, c + 1)
        Abs.new(@sym, @argType, bod)
    end

    def eval1(ctx)
        raise NoRuleApplies
    end

    def isVal
        true
    end

    def type(ctx)
        ctx.unshift(@sym, @argType)
        bodType = @bod.type(ctx)
        ctx.shift
        Arrow.new(@argType, bodType)
    end

    def to_s(ctx)
        while ctx.include? @sym
            @sym += %Q(')
        end
        ctx.unshiftName @sym
        str = "lam #{@sym}#{@argType ? ": #{@argType}"  : ""}. #{@bod.to_s(ctx)}"
        ctx.shiftName
        str
    end

    def to_ds
        "lam.#{bod.to_ds}"
    end
end