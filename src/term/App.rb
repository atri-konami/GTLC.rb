require_relative "./Term"
require_relative "./Abs"
require_relative '../type/Arrow'
require_relative "../error/NoRuleApplies"
require_relative "../error/LCTypeError"

class App < Term
    attr_reader :left, :right

    def initialize(t1, t2)
        @left = t1
        @right = t2
    end

    def termShift(d, c=0)
        left = @left.termShift(d, c)
        right = @right.termShift(d, c)
        App.new(left, right)
    end

    def termSubst(j, s, c=0)
        left = @left.termSubst(j, s, c)
        right = @right.termSubst(j, s, c)
        App.new(left, right)
    end

    def eval1(ctx)
        begin 
            if @right.isVal && @left.instance_of?(Abs)
                @left.bod.termSubstTop @right
            elsif @left.isVal
                App.new(@left, @right.eval1(ctx))
            else
                App.new(@left.eval1(ctx), @right)
            end
        rescue NoRuleApplies => e
            self
        end
    end

    def isVal
        false
    end

    def type(ctx)
        t1 = @left.type(ctx)
        t2 = @right.type(ctx)
        if t1.instance_of?(Arrow) && t1.left === t2
            t1.right
        else
            raise LCTypeError.new("TypeError on App", ctx, @left, @right)
        end
    end

    def to_s(ctx)
        if @right.instance_of? App
            rightStr = "(#{@right.to_s(ctx)})"
        else
            rightStr = @right.to_s(ctx)
        end

        if @left.instance_of? Abs
            leftStr = "(#{@left.to_s(ctx)})"
        else
            leftStr = @left.to_s(ctx)
        end

        "#{leftStr} #{rightStr}"
    end

    def to_ds()
        if @right.instance_of? App
            rightStr = "(#{@right.to_ds})"
        else
            rightStr = @right.to_ds
        end

        if @left.instance_of? Abs
            leftStr = "(#{@left.to_ds})"
        else
            leftStr = @left.to_ds
        end

        "#{leftStr} #{rightStr}"
    end
end
