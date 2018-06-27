require_relative './Arrow'
require_relative './Primitive'
require_relative '../term/Abs'
require_relative '../term/App'
require_relative '../term/Var'
require_relative '../term/Const'
require_relative '../error/LCTypeError'

module TypeChecker
    def typeof(term, venv=[], cenv={})
        case term.class 
            when "Abs"
                env.unshift term.type
                t = typeof(term.bod, env)
                env.shift
                t
            when "App"
                t1 = typeof(term.left, env)
                t2 = typeof(term.right, env)
                if t1.instance_of?(Arrow) && t1.left === t2
                    t2.right
                else
                    raise LCTypeError,'Type Error'
                end
            when "Var"
                if venv[term.idx]
                    venv[term.idx]
                else
                    raise LCTypeError,'Type Error'
                end
            when "Const"
                if cenv.has_key? term.sym
                    cenv[term.sym]
                else
                    raise LCTypeError,'Type Error'
                end
            else
                raise 'invalid term'
            end
        end
    end
end

