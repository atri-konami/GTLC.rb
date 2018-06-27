require_relative "./Term"
require_relative "./Abs"
require_relative "../error/NoRuleApplies"

class App < Term
    attr_reader :left, :right

    def initialize(t1, t2, existBracket)
        @left = t1
        @right = t2
        @existBracket = existBracket
    end

    def termShift(d, c=0)
        left = @left.termShift(d, c)
        right = @right.termShift(d, c)
        App.new(left, right, @existBracket)
    end

    def termSubst(j, s, c=0)
        left = @left.termSubst(j, s, c)
        right = @right.termSubst(j, s, c)
        App.new(left, right, @existBracket)
    end

    def eval1(ctx)
        begin 
            if @right.isVal && @left.instance_of?(Abs)
                @left.bod.termSubstTop @right
            elsif @left.isVal
                App.new(@left, @right.eval1(ctx), @existBracket)
            else
                App.new(@left.eval1(ctx), @right, @existBracket)
            end
        rescue NoRuleApplies => e
            self
        end
    end

    def isVal
        false
    end

    def to_s(ctx=[])
        @left.existBracket = @left.instance_of? Abs
        structTerm("#{@left.to_s(ctx)} #{@right.to_s(ctx)}")
    end

    def to_ds()
        structTerm("#{@left.to_ds} #{@right.to_ds}")
    end
end
