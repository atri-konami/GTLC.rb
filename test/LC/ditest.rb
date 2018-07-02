# Test for De Bruijn Index Translation

require 'yaml'
require_relative '../../src/LC'
require_relative '../../src/env/Context'

td = YAML.load_file('ditest.yaml')

td.each_with_index{|data,i|
    begin
        ctx = Context.new
        act = LC.parse(data['q'], ctx).to_ds
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
