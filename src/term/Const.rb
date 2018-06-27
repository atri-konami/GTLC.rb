require_relative './Term'
require_relative '../error/NoRuleApplies'

class Const < Term
    attr_reader :sym

    def initialize(sym, existBracket=false)
        @sym = sym
        @existBracket = existBracket
    end

    def to_s(env=[])
        until env.find_index(@sym).nil?
            @sym += "'"
        end
        @sym
    end

    def isVal
        true
    end

    def termShift(d, c=0)
        self
    end

    def termSubst(j, s, c=0)
        self
    end

    def eval1(ctx)
        raise NoRuleApplies
    end
end

