# Test for Reduction

require 'yaml'
require_relative '../src/LC'

td = YAML.load_file('redtest.yaml')

td.each_with_index{|data,i|
    begin
        act = LC.parse(data['q']).eval.to_s
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
