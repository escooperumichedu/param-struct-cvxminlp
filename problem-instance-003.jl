# instances/minlp2/st_el4.jl

using JuMP, AmplNLWriter
import Bonmin_jll

global time_limit = 900.0

println("
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
")


m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
set_optimizer_attribute(m, "bonmin.algorithm", "B-BB")
set_optimizer_attribute(m, "bonmin.time_limit", time_limit)



function problem_instance(solver)

    m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
    set_optimizer_attribute(m, "bonmin.algorithm", solver)
    set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

    # ----- Variables ----- #
    @variable(m, objvar)
    x_Idx = Any[1, 2, 3, 4, 5, 6, 7]
    @variable(m, x[x_Idx] >= 0)
    b_Idx = Any[8, 9, 10, 11]
    @variable(m, b[b_Idx], Bin)
    set_upper_bound(x[1], 10.0)
    set_upper_bound(x[2], 10.0)
    set_upper_bound(x[3], 10.0)
    set_upper_bound(x[4], 1.0)
    set_upper_bound(x[5], 1.0)
    set_upper_bound(x[6], 1.0)
    set_upper_bound(x[7], 1.0)


    # ----- Constraints ----- #
    @constraint(m, e1, x[1] + x[2] + x[3] + b[8] + b[9] + b[10] <= 5.0)
    @NLconstraint(m, e2, (x[6])^2 + (x[1])^2 + (x[2])^2 + (x[3])^2 <= 5.5)
    @constraint(m, e3, x[1] + b[8] <= 1.2)
    @constraint(m, e4, x[2] + b[9] <= 1.8)
    @constraint(m, e5, x[3] + b[10] <= 2.5)
    @constraint(m, e6, x[1] + b[11] <= 1.2)
    @NLconstraint(m, e7, (x[5])^2 + (x[2])^2 <= 1.64)
    @NLconstraint(m, e8, (x[6])^2 + (x[3])^2 <= 4.25)
    @NLconstraint(m, e9, (x[5])^2 + (x[3])^2 <= 4.64)
    @constraint(m, e10, x[4] - b[8] == 0.0)
    @constraint(m, e11, x[5] - b[9] == 0.0)
    @constraint(m, e12, x[6] - b[10] == 0.0)
    @constraint(m, e13, x[7] - b[11] == 0.0)
    @NLconstraint(m, e14, -((x[4] - 1)^2 + (x[5] - 2)^2 + (x[6] - 1)^2 - log(1 + x[7]) + (x[1] - 1)^2 + (x[2] - 2)^2 + (x[3] - 3)^2) + objvar == 0.0)


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
    x_Idx = Any[1, 2, 3, 4, 5, 6, 7]
    @variable(m, x[x_Idx] >= 0)
    b_Idx = Any[8, 9, 10, 11]
    @variable(m, b[b_Idx], Bin)
    set_upper_bound(x[1], 10.0)
    set_upper_bound(x[2], 10.0)
    set_upper_bound(x[3], 10.0)
    set_upper_bound(x[4], 1.0)
    set_upper_bound(x[5], 1.0)
    set_upper_bound(x[6], 1.0)
    set_upper_bound(x[7], 1.0)


    # ----- Constraints ----- #
    @constraint(m, e1, x[1] + x[2] + x[3] + b[8] + b[9] + b[10] <= 5.0)
    @NLconstraint(m, e2, (x[6])^2 + (x[1])^2 + (x[2])^2 + (x[3])^2 <= 5.5)
    @constraint(m, e3, x[1] + b[8] <= 1.2)
    @constraint(m, e4, x[2] + b[9] <= 1.8)
    @constraint(m, e5, x[3] + b[10] <= 2.5)
    @constraint(m, e6, x[1] + b[11] <= 1.2)
    @NLconstraint(m, e7, (x[5])^2 + (x[2])^2 <= 1.64)
    @NLconstraint(m, e8, (x[6])^2 + (x[3])^2 <= 4.25)
    @NLconstraint(m, e9, (x[5])^2 + (x[3])^2 <= 4.64)
    @constraint(m, e10, x[4] - b[8] == 0.0)
    @constraint(m, e11, x[5] - b[9] == 0.0)
    @constraint(m, e12, x[6] - b[10] == 0.0)
    @constraint(m, e13, x[7] - b[11] == 0.0)
    @NLconstraint(m, e14, -((x[4] - 1)^2 + (x[5] - 2)^2 + (x[6] - 1)^2 - log(1 + x[7]) + (x[1] - 1)^2 + (x[2] - 2)^2 + (x[3] - 3)^2) + objvar == 0.0)


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