"""
Implementation of the No U-Turn Sampler for MCMC.

Please [read the documentation](https://tamaspapp.eu/DynamicHMC.jl/latest/). For the
impatient: you probably want to

1. define a log density problem (eg for Bayesian inference) using the `LogDensityProblems`
package, then

2. use it with [`mcmc_with_warmup`](@ref).
"""
module DynamicHMC

export
    # kinetic energy
    GaussianKineticEnergy,
    # NUTS
    TreeOptionsNUTS,
    # reporting
    NoProgressReport, LogProgressReport,
    # mcmc
    InitialStepsizeSearch, DualAveraging, FindLocalOptimum,
    TuningNUTS, mcmc_with_warmup, default_warmup_stages, fixed_stepsize_warmup_stages

using ArgCheck: @argcheck
using DocStringExtensions: FIELDS, FUNCTIONNAME, SIGNATURES, TYPEDEF
using LinearAlgebra: checksquare, cholesky, diag, dot, Diagonal, Symmetric, UniformScaling
using LogDensityProblems: capabilities, LogDensityOrder, dimension, logdensity_and_gradient
import NLSolversBase, Optim # optimization step in mcmc
using Parameters: @with_kw, @unpack
using Random: AbstractRNG, randn, Random, randexp
using Statistics: cov, mean, median, middle, quantile, var

# copy from StatsFuns.jl
function logaddexp(x, y)
    isfinite(x) && isfinite(y) || return max(x,y)
    x > y ? x + log1p(exp(y - x)) : y + log1p(exp(x - y))
end

include("trees.jl")
include("hamiltonian.jl")
include("stepsize.jl")
include("NUTS.jl")
include("reporting.jl")
include("mcmc.jl")
include("diagnostics.jl")

end # module
