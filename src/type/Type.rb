class Type
    def isConsistentWith(other)
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def ===(other)
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end
end
