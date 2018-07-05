require 'readline'
require 'yaml'
require_relative './ParseHelper'

module Console
    def start
        puts "Input context file in ./env if you use"
        file = Readline.readline(">> ", true)
        ctx = nil
        if file != ""
            ap = File.expand_path("./env/#{file}", File.dirname(__FILE__))
            if FileTest.exist? ap
                puts "load from #{ap}"
                ctx = YAML.load_file(ap)
            end
        else
            puts "No env file specified"
        end

        loop do
            term = Readline.readline(">> ", true)
            if term.nil? || term == 'exit'
                exit 0
            end
            puts eval(term, ctx)
        end
    end
end