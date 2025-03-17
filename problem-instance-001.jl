# instances/minlp2/alan.jl

using JuMP, AmplNLWriter, BARON
import Bonmin_jll

global time_limit = 10.0

using Ipopt
println(dirname(pathof(Ipopt)))

println("
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
")

function problem_instance(solver)

    m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
    set_optimizer_attribute(m, "bonmin.algorithm", solver)
    set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

    # ----- Variables ----- #
    @variable(m, objvar)
    x_Idx = Any[1, 2, 3, 4]
    @variable(m, x[x_Idx] >= 0)
    b_Idx = Any[6, 7, 8, 9]
    @variable(m, b[b_Idx], Bin)


    # ----- Constraints ----- #
    @constraint(m, e1, x[1] + x[2] + x[3] + x[4] == 1.0)
    @constraint(m, e2, 8 * x[1] + 9 * x[2] + 12 * x[3] + 7 * x[4] == 10.0)
    @NLconstraint(m, e3, x[1] * (4 * x[1] + 3 * x[2] - x[3]) + x[2] * (3 * x[1] + 6 * x[2] + x[3]) + x[3] * (x[2] - x[1] + 10 * x[3]) == objvar)
    @constraint(m, e4, x[1] - b[6] <= 0.0)
    @constraint(m, e5, x[2] - b[7] <= 0.0)
    @constraint(m, e6, x[3] - b[8] <= 0.0)
    @constraint(m, e7, x[4] - b[9] <= 0.0)
    @constraint(m, e8, b[6] + b[7] + b[8] + b[9] <= 3.0)


    # ----- Objective ----- #
    @objective(m, Min, objvar)

    optimize!(m)

    if termination_status(m) == LOCALLY_SOLVED
        println("Optimal Objective Value: ", objective_value(m))
        println("Solution Time: ", solve_time(m), " seconds")
    else
        println("Error")
    end

    val = objective_value(m)
    sol = solve_time(m)

    return val, sol

end

function adj_problem_instance(solver)

    m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
    set_optimizer_attribute(m, "bonmin.algorithm", solver)
    set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

    # ----- Variables ----- #
    @variable(m, objvar)
    x_Idx = Any[1, 2, 3, 4]
    @variable(m, x[x_Idx] >= 0)
    b_Idx = Any[6, 7, 8, 9]
    @variable(m, b[b_Idx], Bin)


    # ----- Constraints ----- #
    @constraint(m, e1, x[1] + x[2] + x[3] + x[4] == 1.0)
    @constraint(m, e2, 8 * x[1] + 9 * x[2] + 12 * x[3] + 7 * x[4] == 9.0)
    @NLconstraint(m, e3, x[1] * (4 * x[1] + 3 * x[2] - x[3]) + x[2] * (3 * x[1] + 6 * x[2] + x[3]) + x[3] * (x[2] - x[1] + 10 * x[3]) == objvar)
    @constraint(m, e4, x[1] - b[6] <= 15.0)
    @constraint(m, e5, x[2] - b[7] <= 5.0)
    @constraint(m, e6, x[3] - b[8] <= 15.0)
    @constraint(m, e7, x[4] - b[9] <= 5.0)
    @constraint(m, e8, b[6] + b[7] + b[8] + b[9] <= 3.0)


    # ----- Objective ----- #
    @objective(m, Min, objvar)

    optimize!(m)

    if termination_status(m) == LOCALLY_SOLVED
        println("Optimal Objective Value: ", objective_value(m))
        println("Solution Time: ", solve_time(m), " seconds")
    else
        println("Error")
    end

    val = objective_value(m)
    sol = solve_time(m)

    return val, sol

end


obj_val_BB, sol_time_BB = problem_instance("B-BB")
obj_val_OA, sol_time_OA = problem_instance("B-OA")

# adj_obj_val_BB, adj_sol_time_BB = adj_problem_instance("B-BB")
# adj_obj_val_OA, adj_sol_time_OA = adj_problem_instance("B-OA")


println("Results from original problem:
obj_val_BB: $obj_val_BB
obj_val_OA: $obj_val_OA
sol_time_BB: $sol_time_BB
sol_time_OA: $sol_time_OA
")

# println("Results from adjusted problem parameters:
# obj_val_BB: $adj_obj_val_BB
# obj_val_OA: $adj_obj_val_OA
# sol_time_BB: $adj_sol_time_BB
# sol_time_OA: $adj_sol_time_OA
# ")