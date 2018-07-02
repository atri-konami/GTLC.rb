require_relative './ParseHelper'
require_relative './term/Abs'
require_relative './term/App'
require_relative './term/Var'
require_relative './term/Const'
require_relative './type/Type'
require_relative './env/Context'
require_relative './error/LCTypeError'

class LC
    extend ParseHelper

    def self.parse(tterm, ctx)
        term = trimBracket(tterm)
        parsed = nil

        if md = isAbs(term)
            sym = md[1]
            bod = md[2]
            s = parse(bod, ctx.unshift(sym))
            ctx.shift
            parsed = Abs.new(sym, nil, s)
            # puts "Abs: #{parsed.to_s(env)}"
            # parsed
        elsif md = isVar(term)
            sym = md[1]
            idx = ctx.find_index sym
            if idx.nil?
                raise "Error: #{sym} does not exist in context"
            else
                parsed = Var.new(idx)
                # puts "Var: #{parsed.to_s(env)}"
            end
            # parsed
        elsif md = isApp(term)
            s1 = parse(md[1], ctx)
            s2 = parse(md[2], ctx)
            parsed = App.new(s1, s2)
            # puts "App: #{parsed.to_s(env)}"
            # parsed
        else
            raise "Error: invalid term"
        end
    end

    def self.isApp(term)
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

    def self.isAbs(term)
        if term.match(/^lam ([a-z][1-9]*)\. ?(.+)$/) && $~ && isTerm(trimBracket($~[2]))
            $~
        else
            nil
        end
    end

    def self.isVar(term)
        term.match /^([a-z0-9]+)$/
    end

    def self.isTerm(term)
        isAbs(term) || isVar(term) || isApp(term)
    end

    def self.eval(term, ctx=nil)
        begin
            if ctx
                ctx = Context.new(ctx.names)
            else
                ctx = Context.new
            end
            t = parse(term, ctx).eval(ctx)
            t.to_s(ctx)
        rescue => e
            $stderr.puts e.message
            $stderr.puts e.backtrace
            ""
        end
    end
end