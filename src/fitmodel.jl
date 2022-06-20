"""
```julia
FrequentistRegression{RegressionType}
```

Type to represent frequentist regression models returned by `fitmodel` functions. This type is used internally by the package to represent all frequentist regression models. `RegressionType` is a `Symbol` representing the model class.
"""
struct FrequentistRegression{RegressionType}
    model
    formula::FormulaTerm
    link
end

"""
```julia
FrequentistRegression(::Symbol, model, formula, link = GLM.IdentityLink)
```

Constructor for `FrequentistRegression`. `model` can be any regression model. Used by `fitmodel` functions to return a frequentist regression model container.
"""
FrequentistRegression(RegressionType::Symbol, model, formula, link = GLM.IdentityLink) = FrequentistRegression{RegressionType}(model, formula, link)

"""
```julia
BayesianRegression{RegressionType}
```

Type to represent bayesian regression models returned by `fitmodel` functions. This type is used internally by the package to represent all bayesian regression models. `RegressionType` is a `Symbol` representing the model class.
"""
struct BayesianRegression{RegressionType}
    chain
    formula::FormulaTerm
end

"""
```julia
BayesianRegression(::Symbol, chain)
```

Constructor for `BayesianRegression`. `model` can be any regression model. Used by `fitmodel` functions to return a bayesian regression model container.
"""
BayesianRegression(RegressionType::Symbol, chain, formula) = BayesianRegression{RegressionType}(chain, formula)

# Print Messages
include("print.jl")

# Frequentist getter functions
include("frequentist/getter.jl")

# Frequentist Regression Models
include("frequentist/linear_regression.jl")
include("frequentist/logistic_regression.jl")
include("frequentist/negativebinomial_regression.jl")
include("frequentist/poisson_regression.jl")

# Bayesian Regression Models
include("bayesian/linear_regression.jl")
include("bayesian/logistic_regression.jl")
include("bayesian/negativebinomial_regression.jl")
include("bayesian/poisson_regression.jl")

# Bayesian getter functions
include("bayesian/getter.jl")

"""
```julia
   @fitmodel(formula, args...)
```

Macro for calling `fitmodel` without using `@formula` to create the formula. 

# Example
```julia
using CRRao, RDatasets
sanction = dataset("Zelig", "sanction")
model = @fitmodel(Num ~ Target + Coop + NCost, sanction, NegBinomRegression())
```
"""
macro fitmodel(formula, args...)
    quote
        fitmodel(@formula($formula), $(map(esc, args)...))
    end
end
