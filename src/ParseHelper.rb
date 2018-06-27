module ParseHelper 
    module_function

    def trimBracket(term)
        bcnt = 0
        if term[0] == '('
            bcnt += 1
            term[1..-2].each_char{|c|
                if c == '('
                    bcnt += 1
                elsif c == ')'
                    bcnt -= 1
                end
                if bcnt == 0
                    break
                end
            }

            if bcnt == 1 && term[-1] == ')'
                term[1..-2]
            else
                term
            end
        else
            term
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
end