class Context
    attr_reader :names, :default_size

    def initialize(names=[])
        @names = names
        @default_size = names.size
    end

    def unshift(name)
        @names.unshift name
        self
    end

    def unshiftName(name)
        @names.unshift name
        self
    end

    def shift
        if names.size == @default_size
            raise RuntimeError, "default environment must not shift."
        end
        @names.shift
        nil
    end

    def shiftName
        if names.size == @default_size
            raise RuntimeError, "default environment must not shift."
        end
        @names.shift
        nil
    end

    def [](idx)
        @names[idx]
    end

    def name_at(idx)
        @names[idx]
    end

    def find_index(name)
        @names.find_index(name)
    end

    def include?(name)
        @names.include? name
    end

    def to_s
        @names.to_s
    end
end
