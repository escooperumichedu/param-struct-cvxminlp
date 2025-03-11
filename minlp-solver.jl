# Solving Convex MINLP through Branch and Bound (Monolithic solution approach) or Outer Aproximation (Decomposed based approach)
# Branch and Bound (Br&Bo)
# Outer Approximation (OA)

println("
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
")

# Bonmin: https://github.com/coin-or/Bonmin
# AmplNLWriter: https://github.com/jump-dev/AmplNLWriter.jl?tab=readme-ov-file
# To use Br&Bo, set optimizer attribute "algorithm" to "B-BB"
# To use OA, set optimizer attribute "algorithm" to "B-OA"

using JuMP, AmplNLWriter
import Bonmin_jll

# Define the model using Bonmin as the optimizer
model_bb = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))

# Set the algorithm to Branch and Bound (B-BB) for the first model
set_optimizer_attribute(model_bb, "bonmin.algorithm", "B-BB")

# Define variables for the Branch and Bound model
@variables(model_bb, begin
    x1 >= 0  # Continuous variable
    x2 >= 0  # Continuous variable
    y, Int  # Integer variable
end)

# Define constraints for the Branch and Bound model
@constraints(model_bb, begin

    y >= -1
    y <= 1
end)

# Define the objective function for the Branch and Bound model
@objective(model_bb, Min, x1^2 + x2^2 + y)

# Solve the Branch and Bound model
println("Solving using Branch and Bound (B-BB)...")
optimize!(model_bb)

# Check the status of the solution
status = termination_status(model_bb)
if status == LOCALLY_SOLVED
    println("Optimal Objective Value: ", objective_value(model_bb))
    println("Optimal Solution:")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println("y = ", value(y))
else
    println("Solver did not find an optimal solution. Status: ", status)
end