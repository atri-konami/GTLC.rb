require_relative './ParseHelper'
require_relative './term/Abs'
require_relative './term/App'
require_relative './term/Var'
require_relative './term/Const'
require_relative './type/Type'
require_relative './error/LCTypeError'

module LC
    extend ParseHelper

    module_function

    def parse(tterm, env=[])
        term = trimBracket(tterm)
        parsed = nil

        if md = isAbs(term)
            sym = md[1]
            bod = md[2]
            s = parse(bod, env.unshift(sym))
            env.shift
            parsed = Abs.new(sym, nil, s)
            # puts "Abs: #{parsed.to_s(env)}"
            # parsed
        elsif md = isVar(term)
            sym = md[1]
            idx = env.find_index sym
            if idx.nil?
                $stderr.puts "Error: #{sym} does not exist in environment"
                parsed = Const.new(sym)
            else
                parsed = Var.new(idx)
                # puts "Var: #{parsed.to_s(env)}"
            end
            parsed
        elsif md = isApp(term)
            s1 = parse(md[1], env)
            s2 = parse(md[2], env)
            parsed = App.new(s1, s2)
            # puts "App: #{parsed.to_s(env)}"
            # parsed
        else
            raise "Error: invalid term"
        end
    end

    def isApp(term)
        tokens = term.split(' ')
        md = Array.new(3)
        (tokens.size - 2).downto(0) {|d|
            form = tokens[0..d].join(' ')
            latt = tokens[d+1..-1].join(' ')
            if isTerm(trimBracket(form)) && isTerm(trimBracket(latt))
                md[1] = form
                md[2] = latt
                break
            end
        }

        if md[1] && md[2]
            md
        else
            nil
        end
    end

    def isAbs(term)
        if term.match(/^lam ([a-z][1-9]*|[a-z][1-9]*: ?.+)\. ?(.+)$/) && $~ && isTerm(trimBracket($~[2]))
            $~
        else
            nil
        end
    end

    def isVar(term)
        term.match /^([a-z][1-9]*)$/
    end

    def isTerm(term)
        isAbs(term) || isVar(term) || isApp(term)
    end

    def eval(term)
        begin
            parse(term).eval
        rescue => e
            $stderr.puts e.message
            $stderr.puts e.backtrace
            ""
        end
    end
end