# Test for GTLC Reduction

require 'yaml'
require_relative '../../src/GTLC'
require_relative '../../src/error/CastError'
require_relative '../../src/env/TypeContext'
require_relative '../../src/type/Primitive'

def typemap(types)
    types.map{|t| GTLC.typeParse(t)}
end

td = YAML.load_file('redtest.yaml')

td.each_with_index{|data,i|
    begin
        ctx = TypeContext.new(['1', 'true', 'succ'], typemap(['Int', 'Bool', 'Int -> Int']))
        act = GTLC.parse(data['q'], ctx).toCast(ctx).eval(ctx).to_s(ctx)
    rescue CastError => e
        $stderr.puts "ERROR: invalid cast"
        $stderr.puts "Term: #{e.term}"
        act = "undefined"
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
