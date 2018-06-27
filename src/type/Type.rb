require_relative '../ParseHelper'
require_relative './Primitive'
require_relative './Arrow'

class Type
    extend ParseHelper
    def self.parse(tstr)
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
end
