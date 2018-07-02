require_relative './Context'
require_relative '../type/Primitive'

class TypeContext < Context
    attr_reader :types

    def initialize(names=[], types=[])
        super(names)
        @types = types
    end

    def unshift(name, type=nil)
        checkLength
        super(name)
        if type
            @types.unshift type
        else
            @types.unshift Primitive.new('Unit')
        end
        self
    end

    def shift
        checkLength
        super
        @types.shift
        nil
    end

    def typesAt(idx)
        @types[idx]
    end

    def checkLength
        if names.size != types.size
            raise RuntimeError, "names' size must equal to types' size"
        end
    end
end