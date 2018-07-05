require_relative './Type'
require_relative './Any'

class Arrow < Type
    attr_reader :dom, :cod

    def initialize(dom, cod)
        @dom = dom
        @cod = cod
    end

    def isGround
        @dom.instance_of?(Any) && @cod.instance_of?(Any)
    end

    def isConsistentWith(other)
        if other.instance_of? Arrow
            @dom.isConsistentWith(other.dom) && @cod.isConsistentWith(other.cod)
        elsif other.instance_of? Any
            true
        else
            false
        end
    end

    def ===(other)
        if other.instance_of?(Arrow)
            self.dom === other.dom && self.cod === other.cod
        elsif other.instance_of? Any
            true
        else
            false
        end
    end

    def to_s
        "#{domWithBracket} -> #{@cod}"
    end

    private

    def domWithBracket
        if @dom.instance_of? Arrow
            "(#{@dom})"
        else
            @dom
        end
    end
end