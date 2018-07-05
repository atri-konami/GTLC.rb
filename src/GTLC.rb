require_relative './LC'
require_relative './STLC'
require_relative './ParseHelper'
require_relative './type/Any'

class GTLC < STLC
    def self.parse(tterm, ctx)
        term = trimBracket(tterm)
        parsed = nil

        if md = isAbs(term)
            sym = md[1]
            type = typeParse(md[2])
            bod = md[3]
            s = parse(bod, ctx.unshift(sym))
            ctx.shift
            parsed = Abs.new(sym, type, s)
            # puts "Abs: #{parsed.to_s(env)}"
            parsed
        else
            super(tterm, ctx)
        end
    end
    
    def self.isAbs(term)
        if term.match(/^lam ([a-z][1-9]*):? ?([a-zA-Z]*?)\. ?(.+)$/) && $~ && isTerm(trimBracket($~[3]))
            $~
        else
            nil
        end
    end

    def self.typeParse(tstr)
        if tstr === "*" || tstr === ""
            Any.new
        else
            super(tstr)
        end
    end

    def self.eval(term, ctx)
        begin
            if ctx
                ctx = TypeContext.new(ctx['names'], ctx['types'].map{|t| typeParse(t)})
            else
                ctx = TypeContext.new
            end
            lt = parse(term, ctx)
            puts "#{lt.to_s(ctx)} has a type #{lt.type(ctx)}"
            puts "Cast Insertion:"
            ct = lt.toCast(ctx)
            puts "#{ct.to_s(ctx)} has a type #{ct.type(ctx)}"
            puts
            puts "Evaluation: "
            t = ct.eval(ctx)
            "#{t.to_s(ctx)}: #{t.type(ctx)}"
        rescue LCTypeError => e
            $stderr.puts e.message
            $stderr.puts e.typeinfo
            puts "evaluation did not execute."
            ""
        rescue => e
            $stderr.puts e.message
            $stderr.puts e.backtrace
            ""
        end
    end
end
