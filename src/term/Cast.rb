require_relative './Term'
require_relative '../error/NoRuleApplies'
require_relative '../error/LCTypeError'
require_relative '../type/Primitive'
require_relative '../type/Arrow'
require_relative '../type/Any'

class Cast < Term
    attr_reader :term, :source, :dest

    def initialize(term, source, dest)
        @term = term
        @source = source
        @dest = dest
    end

    def isVal
        @term.isVal &&
        (isArrowCast || @source.isGround && @dest.instance_of?(Any))
    end

    def isArrowCast
        @source.instance_of?(Arrow) && @dest.instance_of?(Arrow)
    end

    def termShift(d, c=0)
        Cast.new(@term.termShift(d, c), @source, @dest)
    end

    def termSubst(j, s, c=0)
        Cast.new(@term.termSubst(j, s, c), @source, @dest)
    end

    def type(ctx)
        ttype = @term.type(ctx)
        if ttype === @source && @source.isConsistentWith(@dest)
            @dest
        else
            raise LCTypeError.new('Error on Cast typing', ctx, self)
        end
    end
    
    def eval1(ctx)
        case
        when isVal
            raise NoRuleApplies
        when 
            !@term.isVal
            then Cast.new(@term.eval1(ctx), @source, @dest)
        when 
            @source.instance_of?(Primitive) && @dest.instance_of?(Primitive) && @source === @dest,
            @source.instance_of?(Any) && @dest.instance_of?(Any)
            then @term
        when
            @term.instance_of?(Cast) && @term.dest.instance_of?(Any) && self.source.instance_of?(Any) && @term.source.isGround && self.dest.isGround
            then @term.source === self.dest ? @term.term : (raise NoRuleApplies)
        when @source.instance_of?(Arrow) && @dest.instance_of?(Any)
            then Cast.new(Cast.new(@term, @source, Arrow.new(Any.new, Any.new)), Arrow.new(Any.new, Any.new), @dest)
        when @source.instance_of?(Any) && @dest.instance_of?(Arrow)
            then Cast.new(Cast.new(@term, @source, Arrow.new(Any.new, Any.new)), Arrow.new(Any.new, Any.new), @dest)
        else
            raise NoRuleApplies
        end
    end

    def to_s(ctx)
        if @term.instance_of?(Cast) && @source === @term.dest
            "[#{@term.str_rec(ctx)} => #{@dest.to_s}]"
        else 
            "[#{@term.to_s(ctx)}: #{@source.to_s} => #{@dest.to_s}]"
        end
    end

    def to_ds
        @term.to_ds
    end

    def str_rec(ctx)
        if @term.instance_of?(Cast) && @source === @term.dest
            "#{@term.str_rec(ctx)} => #{@dest.to_s}"
        else
            "#{@term.to_s(ctx)}: #{@source.to_s} => #{@dest.to_s}"
        end
    end
end
        