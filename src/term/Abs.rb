require_relative './Term'
require_relative '../type/Type'
require_relative '../error/NoRuleApplies'

class Abs < Term
    attr_reader :sym, :type, :bod

    def initialize(sym, type, bod, existBracket=false)
        @sym = sym
        @type = type
        @bod = bod
        @existBracket = existBracket
    end

    def termShift(d, c=0)
        bod = @bod.termShift(d, c + 1)
        Abs.new(@sym, @type, bod, @existBracket)
    end

    def termSubst(j, s, c=0)
        bod = @bod.termSubst(j, s, c + 1)
        Abs.new(@sym, @type, bod, @existBracket)
    end

    def eval1(ctx)
        raise NoRuleApplies
    end

    def isVal
        true
    end

    def to_s(ctx=[])
        ctx.unshift(@sym)
        str = "lam #{@sym}#{if @type then ": #{@type}" else "" end}. #{@bod.to_s(ctx)}"
        ctx.shift
        structTerm(str)
    end

    def to_ds
        structTerm("lam.#{@bod.to_ds}")
    end
end