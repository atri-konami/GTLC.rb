# Test for De Bruijn Index Translation

require 'yaml'
require_relative '../../src/LC'

td = YAML.load_file('ditest.yaml')

td.each_with_index{|data,i|
    begin
        act = LC.parse(data['q']).to_ds
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
