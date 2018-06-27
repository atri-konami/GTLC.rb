require_relative '../ParseHelper'
require_relative './Primitive'
require_relative './Arrow'

class Type
    def self.parse(tstr)
        left = right = nil
        if !tstr.include?('->')
            Primitive.new(tstr)
        else
            ret = nil
            ts = tstr.split(/ ?-> ?/)
            puts ts
            0.upto(ts.size-2) {|d|
                form = ts[0..d].join('->')
                latt = ts[d+1..-1].join('->')
                begin
                    left = parse(trimBracket(form))
                    right = parse(trimBracket(latt))
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

    def self.trimBracket(term)
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
