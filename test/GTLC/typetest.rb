# Test for GTLC Typing

require 'yaml'
require_relative '../../src/GTLC'
require_relative '../../src/error/LCTypeError'
require_relative '../../src/env/TypeContext'

def typemap(types)
    types.map{|t| GTLC.typeParse(t)}
end

td = YAML.load_file('typetest.yaml')

td.each_with_index{|data,i|
    begin
        ctx = TypeContext.new(['1', 'true', 'succ'], typemap(['Int', 'Bool', 'Int -> Int']))
        parsed = GTLC.parse(data['q'], ctx)
        gtlcType = parsed.type(ctx).to_s
        ciType = parsed.toCast(ctx).type(ctx).to_s
    rescue LCTypeError => e
        $stderr.puts "ERROR: #{e.message}"
        PP.pp(e.typeinfo, $stderr)
        gtlcType = ciType = "undefined"
    rescue => e
        $stderr.puts "ERROR: #{e.message}"
        PP.pp(e.backtrace, $stderr)
    ensure
        if gtlcType == "undefined"
            if gtlcType == data['a']
                puts "No.#{i}: #{data['q']} --> ok"
            else
                puts "No.#{i}: #{data['q']} --> ng"
            end
            puts "answer: #{data['a']}"
            puts "actual: #{gtlcType}"
        else
            puts "No.#{i}: #{data['q']}"

            if gtlcType == data['a']
                puts "GTLC typing --> ok"
            else
                puts "GTLC typing --> ng"
            end
            if ciType == data['a']
                puts "Cast Insertion typing --> ok"
            else
                puts "Cast Insertion typing --> ng"
            end
            if gtlcType == ciType
                puts "Typing consistency between the two --> ok"
            else
                puts "Typing consistency between the two --> ng"
            end
            puts "GTLC: #{gtlcType}"
            puts "CI: #{ciType}"
            puts "answer: #{data['a']}"
        end
        puts
    end
}