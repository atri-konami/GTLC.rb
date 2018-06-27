require_relative './ParseHelper'
require_relative './term/Abs'
require_relative './term/App'
require_relative './term/Var'
require_relative './term/Const'
require_relative './type/Type'

module LC
    extend ParseHelper
    module_function

    def parse(tterm, env=[])
        term = trimBracket(tterm)
        existBracket = tterm != term
        parsed = nil

        if md = isAbs(term)
            sym = md[1]
            bod = md[2]
            type = nil
            if sym.include? ':'
                st = sym.split(/: ?/)
                sym = st[0]
                type = Type.parse st[1]
            end
            s = parse(bod, env.unshift(sym))
            env.shift
            parsed = Abs.new(sym, type, s, existBracket)
            # puts "Abs: #{parsed.to_s(env)}"
            parsed
        elsif md = isVar(term)
            sym = md[1]
            idx = env.find_index sym
            if idx.nil?
                $stderr.puts "Error: #{sym} does not exist in environment"
                parsed = Const.new(sym)
            else
                parsed = Var.new(idx, existBracket)
                # puts "Var: #{parsed.to_s(env)}"
            end
            parsed
        elsif md = isApp(term)
            s1 = parse(md[1], env)
            s2 = parse(md[2], env)
            parsed = App.new(s1, s2, existBracket)
            # puts "App: #{parsed.to_s(env)}"
            parsed
        else
            raise "Error: invalid term"
        end
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