# Test for Reduction

require 'yaml'
require_relative '../../src/LC'
require_relative '../../src/env/Context'

td = YAML.load_file('redtest.yaml')

td.each_with_index{|data,i|
    begin
        ctx = Context.new
        act = LC.parse(data['q'], ctx).eval(ctx)
    rescue => e
        $stderr.puts "ERROR: #{e.message}"
        PP.pp(e.backtrace, $stderr)
    ensure
        if act == data['a']
            puts "No.#{i}: #{data['q']} --> ok"
        else
            puts "No.#{i}: #{data['q']} --> ng"
        end
        puts "answer: #{data['a']}"
        puts "actual: #{act}"
    end
}
