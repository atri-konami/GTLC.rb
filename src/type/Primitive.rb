class Primitive
    attr_reader :type

    def initialize(tstr)
        @type = tstr
    end
    
    def ===(other)
        if other.instance_of?(Primitive)
            self.type === other.type
        else
            false
        end
    end

    def to_s
        @type
    end
end