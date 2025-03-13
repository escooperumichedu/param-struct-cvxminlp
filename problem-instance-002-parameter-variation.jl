# instances/minlp2/alan.jl

using JuMP, AmplNLWriter
import Bonmin_jll

global time_limit = 10.0

println("
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
")
obj_val_BB_vec = zeros(100)
obj_val_OA_vec = zeros(100)
sol_time_BB_vec = zeros(100)
sol_time_OA_vec = zeros(100)

for i = 1:100

    C = [3.0, 3.5, 3.2, 11.0, 11.0, 10.0, 1.64, 4.25, 4.64, 0.0, 0.0, 0.0, 0.0]
    k = [8, 3, 8, 8, 10, 10]
    u = [10, 10, 10, 1.0, 1.0, 1.0, 1.0]



    function problem_instance(solver, k, C, u)

        m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
        set_optimizer_attribute(m, "bonmin.algorithm", solver)
        set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

        # ----- Variables ----- #
        @variable(m, objvar)
        x_Idx = Any[1, 2, 3, 4, 5, 6, 7]
        @variable(m, x[x_Idx] >= 0)
        b_Idx = Any[8, 9, 10, 11]
        @variable(m, b[b_Idx], Bin)
        set_upper_bound(x[1], u[1])
        set_upper_bound(x[2], u[2])
        set_upper_bound(x[3], u[3])
        set_upper_bound(x[4], u[4])
        set_upper_bound(x[5], u[5])
        set_upper_bound(x[6], u[6])
        set_upper_bound(x[7], u[7])


        # ----- Constraints ----- #
        @constraint(m, e1, x[1] + x[2] + x[3] + b[8] + b[9] + b[10] <= C[1])
        @NLconstraint(m, e2, (x[6])^2 + (x[1])^2 + (x[2])^2 + (x[3])^2 <= C[2])
        @constraint(m, e3, x[1] + b[8] <= C[3])
        @constraint(m, e4, x[2] + b[9] <= C[4])
        @constraint(m, e5, x[3] + b[10] <= C[5])
        @constraint(m, e6, x[1] + b[11] <= C[6])
        @NLconstraint(m, e7, (x[5])^2 + (x[2])^2 <= C[7])
        @NLconstraint(m, e8, (x[6])^2 + (x[3])^2 <= C[8])
        @NLconstraint(m, e9, (x[5])^2 + (x[3])^2 <= C[9])
        @constraint(m, e10, x[4] - b[8] == C[10])
        @constraint(m, e11, x[5] - b[9] == C[11])
        @constraint(m, e12, x[6] - b[10] == C[12])
        @constraint(m, e13, x[7] - b[11] == C[13])
        @NLconstraint(m, e14, -((x[4] - k[1])^2 + (x[5] - k[2])^2 + (x[6] - k[3])^2 - log(1 + x[7]) + (x[1] - k[4])^2 + (x[2] - k[5])^2 + (x[3] - k[6])^2) + objvar == 0.0)

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

    obj_val_BB, sol_time_BB = problem_instance("B-QG", k, C, u)
    obj_val_OA, sol_time_OA = problem_instance("B-OA", k, C, u)

    obj_val_BB_vec[i] = obj_val_BB
    obj_val_OA_vec[i] = obj_val_OA
    sol_time_BB_vec[i] = sol_time_BB
    sol_time_OA_vec[i] = sol_time_OA

end

using Statistics
mean(sol_time_BB_vec)
mean(sol_time_OA_vec)
mean(obj_val_BB_vec)
mean(obj_val_OA_vec)