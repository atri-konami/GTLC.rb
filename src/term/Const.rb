require_relative './Term'
require_relative '../error/NoRuleApplies'
require_relative '../error/LCTypeError'

class Const < Term
    attr_reader :sym

    def initialize(sym)
        @sym = sym
    end

    def termShift(d, c=0)
        self
    end

    def termSubst(j, s, c=0)
        self
    end

    def isVal
        true
    end

    def type(ctx=[])
        if ctx[]
            cenv[@sym]
        else
            raise LCTypeError.new('TypeError on Const', ctx, venv, cenv, @sym)
        end
    end

    def eval1(ctx)
        raise NoRuleApplies
    end

    def to_s(env=[])
        "#{@sym}"
    end
end

