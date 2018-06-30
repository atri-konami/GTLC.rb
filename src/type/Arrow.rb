require_relative './Type'
require_relative './Any'

class Arrow < Type
    attr_reader :left, :right

    def initialize(left, right)
        @left = left
        @right = right
    end

    def isConsistentWith(other)
        if other.instance_of? Arrow
            @left.isConsistentWith(other.left) && @right.isConsistentWith(other.right)
        elsif other.instance_of? Any
            true
        else
            false
        end
    end

    def ===(other)
        if other.instance_of?(Arrow)
            self.left === other.left && self.right === other.right
        elsif other.instance_of? Any
            true
        else
            false
        end
    end

    def to_s
        "#{leftWithBracket} -> #{@right}"
    end

    private

    def leftWithBracket
        if @left.instance_of? Arrow
            "(#{@left})"
        else
            @left
        end
    end
end