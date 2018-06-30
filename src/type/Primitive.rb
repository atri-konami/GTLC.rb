require_relative './Type'
require_relative './Any'

class Primitive < Type
    attr_reader :type

    def initialize(tstr)
        @type = tstr
    end

    def isConsistentWith(other)
        self === other || other.instance_of?(Any)
    end
    
    def ===(other)
        if other.instance_of? Primitive
            self.type === other.type
        elsif other.instance_of? Any
            true
        else
            false
        end
    end

    def to_s
        "#{@type}"
    end
end