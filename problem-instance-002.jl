# instances/minlp2/alan.jl

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

# function problem_instance(solver)

m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
set_optimizer_attribute(m, "bonmin.algorithm", "B-BB")
set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

# ----- Variables ----- #
@variable(m, objvar)
x_Idx = Any[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
@variable(m, x[x_Idx])
b_Idx = Any[17, 18, 19, 20, 21, 22]
@variable(m, b[b_Idx], Bin)
set_lower_bound(x[4], 0.0)
set_lower_bound(x[16], 0.0)
set_lower_bound(x[6], 0.0)
set_lower_bound(x[14], 0.0)
set_lower_bound(x[3], 0.0)
set_lower_bound(x[11], 0.0)
set_lower_bound(x[12], 0.0)
set_lower_bound(x[5], 0.0)
set_lower_bound(x[2], 0.0)
set_lower_bound(x[9], 0.0)
set_lower_bound(x[15], 0.0)
set_lower_bound(x[1], 0.0)
set_lower_bound(x[7], 0.0)
set_lower_bound(x[8], 0.0)
set_lower_bound(x[13], 0.0)
set_lower_bound(x[10], 0.0)
set_upper_bound(x[1], 300.0)
set_upper_bound(x[2], 300.0)
set_upper_bound(x[3], 300.0)
set_upper_bound(x[4], 300.0)
set_upper_bound(x[5], 300.0)
set_upper_bound(x[6], 300.0)
set_upper_bound(x[7], 300.0)
set_upper_bound(x[8], 300.0)
set_upper_bound(x[9], 300.0)
set_upper_bound(x[10], 300.0)
set_upper_bound(x[11], 300.0)
set_upper_bound(x[12], 300.0)
set_upper_bound(x[13], 300.0)
set_upper_bound(x[14], 300.0)
set_upper_bound(x[15], 300.0)
set_upper_bound(x[16], 300.0)
set_start_value(x[1], 60.0)
set_start_value(x[2], 60.0)
set_start_value(x[3], 60.0)
set_start_value(x[4], 60.0)
set_start_value(x[5], 60.0)
set_start_value(x[6], 60.0)
set_start_value(x[7], 60.0)
set_start_value(x[8], 60.0)
set_start_value(x[9], 60.0)
set_start_value(x[10], 60.0)
set_start_value(x[11], 60.0)
set_start_value(x[12], 60.0)
set_start_value(x[13], 60.0)
set_start_value(x[14], 60.0)
set_start_value(x[15], 60.0)
set_start_value(x[16], 60.0)

# ----- Constraints ----- #
@constraint(m, e2, x[1] + x[3] + x[5] + x[7] <= 100.0)
@constraint(m, e3, x[2] + x[4] + x[6] + x[8] <= 200.0)
@constraint(m, e4, x[9] + x[11] + x[13] + x[15] <= 150.0)
@constraint(m, e5, x[10] + x[12] + x[14] + x[16] <= 120.0)
@constraint(m, e6, x[1] + x[9] - 120 * b[17] == 0.0)
@constraint(m, e7, x[2] + x[10] - 140 * b[17] == 0.0)
@constraint(m, e8, x[3] + x[11] - 130 * b[18] == 0.0)
@constraint(m, e9, x[4] + x[12] - 180 * b[18] == 0.0)
@constraint(m, e10, x[5] + x[13] - 120 * b[19] == 0.0)
@constraint(m, e11, x[6] + x[14] - 140 * b[19] == 0.0)
@constraint(m, e12, x[7] + x[15] - 130 * b[20] == 0.0)
@constraint(m, e13, x[8] + x[16] - 180 * b[20] == 0.0)
@constraint(m, e14, 260 * b[17] + 310 * b[18] - 2500 * b[21] <= 0.0)
@constraint(m, e15, 260 * b[19] + 310 * b[20] - 3200 * b[22] <= 0.0)
@constraint(m, e16, 260 * b[17] + 310 * b[18] - 50 * b[21] >= 0.0)
@constraint(m, e17, 260 * b[19] + 310 * b[20] - 50 * b[22] >= 0.0)
@constraint(m, e18, b[17] + b[19] == 1.0)
@constraint(m, e19, b[18] + b[20] == 1.0)


# ----- Objective ----- #
@objective(m, Min, -(50 * (x[1] + x[2] + x[3] + x[4] + x[9] + x[10] + x[11] + x[12])^2.5 + 70 * (x[5] + x[6] + x[7] + x[8] + x[13] + x[14] + x[15] + x[16])^2.5 + 10 * x[1] + 15 * x[2] + 20 * x[3] + 10 * x[4] + 5 * x[5] + 5 * x[6] + 30 * x[7] + 10 * x[8] + 25 * x[9] + 20 * x[10] + 15 * x[11] + 20 * x[12] + 30 * x[13] + 10 * x[14] + 10 * x[15] + 30 * x[16]) - 2000 * b[21] - 2500 * b[22])


optimize!(m)

# val = objective_value(m)
# sol = solve_time(m)

# return val, sol


# end

# function adj_problem_instance(solver)

#     m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
#     set_optimizer_attribute(m, "bonmin.algorithm", solver)
#     set_optimizer_attribute(m, "bonmin.time_limit", time_limit)
#     set_optimizer_attribute(m, "bonmin.root_algorithm", "B-OA")

#     # ----- Variables ----- #
#     @variable(m, objvar)
#     x_Idx = Any[11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
#     @variable(m, 0 <= x[x_Idx] <= 5)
#     i_Idx = Any[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
#     @variable(m, 0 <= i[i_Idx] <= 5, Int)


#     # ----- Constraints ----- #
#     @NLconstraint(m, e1, sqrt(0.0001 + (i[1])^2 + (i[2])^2 + (i[3])^2 + (i[4])^2 + (i[5])^2 + (i[6])^2 + (i[7])^2 + (i[8])^2 + (i[9])^2 + (i[10])^2 + (x[11])^2 + (x[12])^2 + (x[13])^2 + (x[14])^2 + (x[15])^2 + (x[16])^2 + (x[17])^2 + (x[18])^2 + (x[19])^2 + (x[20])^2) <= 10.0)
#     @constraint(m, e2, -0.175 * i[1] - 0.39 * i[2] - 0.83 * i[3] - 0.805 * i[4] - 0.06 * i[5] - 0.4 * i[6] - 0.52 * i[7] - 0.415 * i[8] - 0.655 * i[9] - 0.63 * i[10] - 0.29 * x[11] - 0.43 * x[12] - 0.015 * x[13] - 0.985 * x[14] - 0.165 * x[15] - 0.105 * x[16] - 0.37 * x[17] - 0.2 * x[18] - 0.49 * x[19] - 0.34 * x[20] - objvar == 0.0)


#     # ----- Objective ----- #
#     @objective(m, Min, objvar)

#     optimize!(m)

#     if termination_status(m) == LOCALLY_SOLVED
#         println("Optimal Objective Value: ", objective_value(m))
#         println("Solution Time: ", solve_time(m), " seconds")
#         val = objective_value(m)
#         sol = solve_time(m)
#     else
#         println("Error")
#     end

#     val = objective_value(m)
#     sol = solve_time(m)

#     return val, sol


# end


# obj_val_BB, sol_time_BB = problem_instance("B-BB")
# obj_val_OA, sol_time_OA = problem_instance("B-OA")

# adj_obj_val_BB, adj_sol_time_BB = adj_problem_instance("B-BB")
# adj_obj_val_OA, adj_sol_time_OA = adj_problem_instance("B-OA")


# println("Results from original problem:
# obj_val_BB: $obj_val_BB
# obj_val_OA: $obj_val_OA
# sol_time_BB: $sol_time_BB
# sol_time_OA: $sol_time_OA
# ")

# println("Results from adjusted problem parameters:
# obj_val_BB: $adj_obj_val_BB
# obj_val_OA: $adj_obj_val_OA
# sol_time_BB: $adj_sol_time_BB
# sol_time_OA: $adj_sol_time_OA
# ")