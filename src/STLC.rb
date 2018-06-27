require_relative './LC'
require_relative './ParseHelper'
require 'pp'

module STLC
    extend LC, ParseHelper
    module_function

    def parse(tterm, env=[])
        term = trimBracket(tterm)
        existBracket = tterm != term
        parsed = nil

        if md = isAbs(term)
            sym = md[1]
            type = Type.parse(md[2])
            bod = md[3]
            s = parse(bod, env.unshift(sym))
            env.shift
            parsed = Abs.new(sym, type, s, existBracket)
            # puts "Abs: #{parsed.to_s(env)}"
            parsed
        else
            LC.parse(tterm, env)
        end
    end
    
    def isAbs(term)
        if term.match(/^lam ([a-z][1-9]*): ?(.+?)\. ?(.+)$/) && $~ && isTerm(trimBracket($~[3]))
            $~
        else
            nil
        end
    end

    def eval(term)
        begin
            lt = parse(term)
            puts "#{lt} has a type of #{lt.type}"
            puts "Evalation:"
            lt.eval
        rescue LCTypeError => e
            $stderr.puts e.message
            $stderr.puts e.typeinfo
            puts "evaluation did not execute."
        rescue => e
            $stderr.puts e.message
            $stderr.puts e.backtrace
            ""
        end
    end
end
