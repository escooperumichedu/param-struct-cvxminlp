# instances/minlp2/alan.jl

using JuMP, AmplNLWriter, BARON
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

# Default
# global obj_k = [4, 3, 3, 6, 10]
# global k = [8, 9, 12, 7]
# global C = [1, 10, 0, 0, 0, 0, 3]

# Manipulated
global obj_k = [4, 3, 3, 6, 10]
global k = [8, 9, 12, 7]
global C = [1, 8, 0, 0, 0, 0, 3]

for i = 1:100

    function problem_instance_OA(solver)

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
        @constraint(m, e1, x[1] + x[2] + x[3] + x[4] == C[1])
        @constraint(m, e2, k[1] * x[1] + k[2] * x[2] + k[3] * x[3] + k[4] * x[4] == C[2])
        @NLconstraint(m, e3, x[1] * (obj_k[1] * x[1] + obj_k[2] * x[2] - x[3]) + x[2] * (obj_k[3] * x[1] + obj_k[4] * x[2] + x[3]) + x[3] * (x[2] - x[1] + obj_k[5] * x[3]) == objvar)
        @constraint(m, e4, x[1] - b[6] <= C[3])
        @constraint(m, e5, x[2] - b[7] <= C[4])
        @constraint(m, e6, x[3] - b[8] <= C[5])
        @constraint(m, e7, x[4] - b[9] <= C[6])
        @constraint(m, e8, b[6] + b[7] + b[8] + b[9] <= C[7])


        # ----- Objective ----- #
        @objective(m, Min, objvar)

        optimize!(m)

        val = objective_value(m)
        sol = solve_time(m)

        return val, sol

    end

    function problem_instance_BB(solver)

        m = Model(BARON.Optimizer)

        # ----- Variables ----- #
        @variable(m, objvar)
        x_Idx = Any[1, 2, 3, 4]
        @variable(m, x[x_Idx] >= 0)
        b_Idx = Any[6, 7, 8, 9]
        @variable(m, b[b_Idx], Bin)

        # ----- Constraints ----- #
        @constraint(m, e1, x[1] + x[2] + x[3] + x[4] == C[1])
        @constraint(m, e2, k[1] * x[1] + k[2] * x[2] + k[3] * x[3] + k[4] * x[4] == C[2])
        @NLconstraint(m, e3, x[1] * (obj_k[1] * x[1] + obj_k[2] * x[2] - x[3]) + x[2] * (obj_k[3] * x[1] + obj_k[4] * x[2] + x[3]) + x[3] * (x[2] - x[1] + obj_k[5] * x[3]) == objvar)
        @constraint(m, e4, x[1] - b[6] <= C[3])
        @constraint(m, e5, x[2] - b[7] <= C[4])
        @constraint(m, e6, x[3] - b[8] <= C[5])
        @constraint(m, e7, x[4] - b[9] <= C[6])
        @constraint(m, e8, b[6] + b[7] + b[8] + b[9] <= C[7])

        # ----- Objective ----- #
        @objective(m, Min, objvar)

        optimize!(m)

        val = objective_value(m)
        sol = solve_time(m)

        return val, sol

    end

    obj_val_OA, sol_time_OA = problem_instance_OA("B-OA")
    obj_val_BB, sol_time_BB = problem_instance_BB("BARON")

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

println("Sol time (BB): $(mean(sol_time_BB_vec))")
println("Sol time (OA): $(mean(sol_time_OA_vec))")