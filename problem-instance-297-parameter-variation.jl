# instances/minlp2/clay0303h.jl

using JuMP, AmplNLWriter, BARON, Statistics
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
obj_val_BB_vec = zeros(10)
obj_val_OA_vec = zeros(10)
sol_time_BB_vec = zeros(10)
sol_time_OA_vec = zeros(10)

# Default
# global u = [1.0e15, 1.0, 2.0]
# global C = [16.0, 1.0, 24.0, 12.0, 3.0]
# global k = [2, 8, 3, 5, 4, 0.5, 0.2, 0.1]
# global k_obj = [0.5 6.5 7 2 3 2]

# Manipulated
global u = [1.0e15, 20.0, 20.0]
global C = [11.0, 1.0, 20.0, 6.0, 3.0]
global k = [2, 8, 3, 5, 4, 0.5, 0.2, 0.1]
global k_obj = [0.5 6.5 7 2 3 2]


for jj = 1:10

    function problem_instance_OA(solver)

        m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
        set_optimizer_attribute(m, "bonmin.algorithm", solver)
        set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

        # ----- Variables ----- #
        @variable(m, objvar)
        i_Idx = Any[1, 2, 3, 4, 5, 6]
        @variable(m, i[i_Idx], Int)
        set_upper_bound(i[1], u[1])
        set_upper_bound(i[2], u[1])
        set_upper_bound(i[3], u[1])
        set_upper_bound(i[4], u[2])
        set_upper_bound(i[5], u[2])
        set_upper_bound(i[6], u[3])


        # ----- Constraints ----- #
        @constraint(m, e1, i[1] + k[1] * i[2] + k[2] * i[3] + i[4] + k[3] * i[5] + k[4] * i[6] <= C[1])
        @constraint(m, e2, -k[2] * i[1] - k[5] * i[2] - k[1] * i[3] + k[1] * i[4] + k[5] * i[5] - i[6] <= -C[2])
        @constraint(m, e3, k[1] * i[1] + k[6] * i[2] + k[7] * i[3] - k[3] * i[4] - i[5] - k[5] * i[6] <= C[3])
        @constraint(m, e4, k[7] * i[1] + k[1] * i[2] + k[8] * i[3] - k[5] * i[4] + k[1] * i[5] + k[1] * i[6] <= C[4])
        @constraint(m, e5, -k[8] * i[1] - k[6] * i[2] + k[1] * i[3] + k[4] * i[4] - k[4] * i[5] + k[3] * i[6] <= C[5])
        @NLconstraint(m, e6, -(k_obj[1] * i[1] * i[1] + k_obj[2] * i[1] + k_obj[3] * i[6] * i[6] - i[6]) + i[2] + k_obj[4] * i[3] - k_obj[5] * i[4] + k_obj[6] * i[5] + objvar == 0.0)


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
        i_Idx = Any[1, 2, 3, 4, 5, 6]
        @variable(m, i[i_Idx], Int)
        set_upper_bound(i[1], u[1])
        set_upper_bound(i[2], u[1])
        set_upper_bound(i[3], u[1])
        set_upper_bound(i[4], u[2])
        set_upper_bound(i[5], u[2])
        set_upper_bound(i[6], u[3])


        # ----- Constraints ----- #
        @constraint(m, e1, i[1] + k[1] * i[2] + k[2] * i[3] + i[4] + k[3] * i[5] + k[4] * i[6] <= C[1])
        @constraint(m, e2, -k[2] * i[1] - k[5] * i[2] - k[1] * i[3] + k[1] * i[4] + k[5] * i[5] - i[6] <= -C[2])
        @constraint(m, e3, k[1] * i[1] + k[6] * i[2] + k[7] * i[3] - k[3] * i[4] - i[5] - k[5] * i[6] <= C[3])
        @constraint(m, e4, k[7] * i[1] + k[1] * i[2] + k[8] * i[3] - k[5] * i[4] + k[1] * i[5] + k[1] * i[6] <= C[4])
        @constraint(m, e5, -k[8] * i[1] - k[6] * i[2] + k[1] * i[3] + k[4] * i[4] - k[4] * i[5] + k[3] * i[6] <= C[5])
        @NLconstraint(m, e6, -(k_obj[1] * i[1] * i[1] + k_obj[2] * i[1] + k_obj[3] * i[6] * i[6] - i[6]) + i[2] + k_obj[4] * i[3] - k_obj[5] * i[4] + k_obj[6] * i[5] + objvar == 0.0)


        # ----- Objective ----- #
        @objective(m, Min, objvar)


        optimize!(m)

        val = objective_value(m)
        sol = solve_time(m)

        return val, sol

    end

    global obj_val_OA, sol_time_OA = problem_instance_OA("B-OA")
    global obj_val_BB, sol_time_BB = problem_instance_BB("BARON")

    sol_time_BB_vec[jj] = sol_time_BB
    sol_time_OA_vec[jj] = sol_time_OA
end



# using Statistics
# mean(sol_time_BB_vec)
# mean(sol_time_OA_vec)
# mean(obj_val_BB_vec)
# mean(obj_val_OA_vec)

println("Sol time (BB): $(median(sol_time_BB_vec))")
println("Sol time (OA): $(median(sol_time_OA_vec))")