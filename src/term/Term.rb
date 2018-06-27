require_relative '../error/NoRuleApplies'

class Term
    attr_accessor :existBracket

    def structTerm(term)
        if @existBracket
            "(#{term})"
        else
            term
        end
    end
    
    def termShift(d, c=0)
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def termSubst(j, s, c=0)
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def termSubstTop(s)
        termSubst(0, (s.termShift(1))).termShift(-1)
    end

    def isVal
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def eval1(ctx)
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def eval(ctx=[])
        puts self
        evalrec(ctx)
    end

    protected

    def evalrec(ctx)
        t = self
        begin
           t = eval1(ctx)
           puts "\t---> #{t}"
           t.evalrec(ctx)
        rescue NoRuleApplies
            t
        end
    end
end