class LCTypeError < Exception
    attr_reader :typeinfo
    def initialize(mes, ctx, venv, cenv, *terms)
        super(mes)
        @typeinfo = []
        terms.each{|t|
            @typeinfo << "#{t.to_s(ctx)}: #{t.type(ctx, venv, cenv)}"
        }
    end
end