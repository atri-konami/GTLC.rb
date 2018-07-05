class LCTypeError < Exception
    attr_reader :typeinfo
    def initialize(mes, ctx, *terms)
        super(mes)
        @typeinfo = []
        terms.each{|t|
            @typeinfo << [t.to_s(ctx), t.type(ctx).to_s]
        }
    end
end