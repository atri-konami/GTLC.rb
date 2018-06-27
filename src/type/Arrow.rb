class Arrow
    attr_reader :left, :right

    def initialize(left, right)
        @left = left
        @right = right
    end

    def ===(other)
        if other.instance_of?(Arrow)
            self.left === other.left && self.right === other.right
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