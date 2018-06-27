require_relative './Term'
require_relative '../type/Type'
require_relative '../type/Arrow'
require_relative '../error/NoRuleApplies'

class Abs < Term
    attr_reader :sym, :argType, :bod

    def initialize(sym, type, bod, existBracket=false)
        @sym = sym
        @argType = type
        @bod = bod
        @existBracket = existBracket
    end

    def termShift(d, c=0)
        bod = @bod.termShift(d, c + 1)
        Abs.new(@sym, @argType, bod, @existBracket)
    end

    def termSubst(j, s, c=0)
        bod = @bod.termSubst(j, s, c + 1)
        Abs.new(@sym, @argType, bod, @existBracket)
    end

    def eval1(ctx)
        raise NoRuleApplies
    end

    def isVal
        true
    end

    def type(ctx=[], venv=[], cenv={})
        ctx.unshift @sym
        venv.unshift @argType
        bodType = @bod.type(ctx, venv, cenv)
        venv.shift
        ctx.shift
        Arrow.new(@argType, bodType)
    end

    def to_s(ctx=[])
        ctx.unshift(@sym)
        str = "lam #{@sym}#{@argType ? ": #{@argType}"  : ""}. #{@bod.to_s(ctx)}"
        ctx.shift
        structTerm(str)
    end

    def to_ds
        structTerm("lam.#{@bod.to_ds}")
    end
end