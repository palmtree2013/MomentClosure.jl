function zero_closure(sys::Union{RawMomentEquations, CentralMomentEquations})

    closure = Dict()
    closure_exp = Dict()

    if typeof(sys) == CentralMomentEquations
        for i in sys.iter_exp
            closure[sys.M[i]] = 0
            closure_exp[sys.M[i]] = 0
        end
    else
        μ = copy(sys.μ)
        μ_symbolic = copy(sys.μ)
        raw_to_central = raw_to_central_moments(sys.N, sys.exp_order)
        for i in sys.iter_exp
            μ[i] = simplify(-(raw_to_central[i]-μ[i]))
            closure[sys.μ[i]] = simplify(expand(μ[i]))

            μ[i] = simplify(expand(substitute(μ[i], closure_exp)))
            closure_exp[sys.μ[i]] = μ[i]
        end
    end

    close_eqs(sys, closure_exp, closure)

end
