require_relative './LC'
require_relative './STLC'
require_relative './ParseHelper'
require_relative './type/Any'

class GTLC < STLC
    def self.parse(tterm, env=[])
        term = trimBracket(tterm)
        parsed = nil

        if md = isAbs(term)
            sym = md[1]
            type = typeParse(md[2])
            bod = md[3]
            s = parse(bod, env.unshift(sym))
            env.shift
            parsed = Abs.new(sym, type, s)
            # puts "Abs: #{parsed.to_s(env)}"
            parsed
        else
            super(tterm, env)
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
end
