# Test for Typing

require 'yaml'
require_relative '../src/STLC'
require_relative '../src/error/LCTypeError'

td = YAML.load_file('tytest.yaml')

td.each_with_index{|data,i|
    begin
        act = STLC.parse(data['q']).type.to_s
    rescue LCTypeError => e
        $stderr.puts "ERROR: #{e.message}"
        PP.pp(e.typeinfo, $stderr)
    rescue => e
        $stderr.puts "ERROR: #{e.message}"
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




