require_relative './LC'
require_relative './ParseHelper'
require_relative './type/Primitive'
require_relative './type/Arrow'

class STLC < LC
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
        if term.match(/^lam ([a-z][1-9]*): ?([a-zA-Z]+?)\. ?(.+)$/) && $~ && isTerm(trimBracket($~[3]))
            $~
        else
            nil
        end
    end

    def self.typeParse(tstr)
        left = right = nil
        if !tstr.include?('->') && !tstr.include?('(') && !tstr.include?(')')
            Primitive.new(tstr)
        else
            ret = nil
            ts = tstr.split(/ ?-> ?/)
            0.upto(ts.size-2) {|d|
                form = ts[0..d].join('->')
                latt = ts[d+1..-1].join('->')
                begin
                    left = typeParse(trimBracket(form))
                    right = typeParse(trimBracket(latt))
                    break
                rescue => e
                    next
                end
            }

            if left && right
                Arrow.new(left, right)
            else
                raise 'Type Error'
            end
        end
    end

    def self.eval(term)
        begin
            lt = parse(term)
            puts "#{lt} has a type of #{lt.type}"
            puts "Evalation:"
            t = lt.eval
            "#{t}: #{t.type}"
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
