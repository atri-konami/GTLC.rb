# Test for De Bruijn Index Translation

require 'yaml'
require_relative '../src/LC'

td = YAML.load_file('ditest.yaml')

td.each_with_index{|data,i|
    act = LC.toDebruijnIndex(data['q']).to_ds
    if act == data['a']
        puts "No.#{i}: #{data['q']} --> ok"
    else
        puts "No.#{i}: #{data['q']} --> ng"
        puts "answer: #{data['a']}"
        puts "actual: #{act}"
    end
}




