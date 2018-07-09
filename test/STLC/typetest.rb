# Test for Typing

require 'yaml'
require_relative '../../src/STLC'
require_relative '../../src/error/LCTypeError'
require_relative '../../src/env/TypeContext'

td = YAML.load_file('typetest.yaml')

td.each_with_index{|data,i|
    begin
        ctx = TypeContext.new
        act = STLC.parse(data['q'], ctx).type(ctx).to_s
    rescue LCTypeError => e
        $stderr.puts "ERROR: #{e.message}"
        PP.pp(e.typeinfo, $stderr)
        act = 'undefined'
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
        puts
    end
}