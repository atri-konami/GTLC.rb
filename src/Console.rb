require 'readline'
require_relative './ParseHelper'

module Console
    def start
        loop do
            term = Readline.readline(">> ", true)
            if term.nil? || term == 'exit'
                exit 0
            end
            puts eval(term)
        end
    end
end