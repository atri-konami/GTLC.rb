require 'readline'
require_relative './ParseHelper'

module Console
    def start
        loop do
            term = Readline.readline(">> ", true)
            if term.nil? || term == 'exit'
                exit 0
            end
            puts ParseHelper.trimBracket(eval(term).to_s)
        end
    end

    def eval(str)
        str
    end
end