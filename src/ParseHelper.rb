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
end