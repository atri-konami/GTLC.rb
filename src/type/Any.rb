require_relative './Type'

class Any < Type
    def initialize()
    end

    def isConsistentWith(other)
        true
    end

    def ===(other)
        true
    end

    def to_s
        "*"
    end
end