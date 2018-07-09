class CastError < Exception
    attr_reader :term
    def initialize(mes, term, ctx)
        super(mes)
        @term = term.to_s(ctx)
    end
end