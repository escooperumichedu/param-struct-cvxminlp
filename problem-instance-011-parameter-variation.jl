# instances/minlp2/batchdes.jl

using JuMP, AmplNLWriter, BARON
import Bonmin_jll

global time_limit = 60.0

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
sol_time_OA_vec = zeros(100)

# Default
# l = [5.52146091786225, 5.40367788220586, 4.60517018598809, 1.89711998488588, 1.38629436111989, 0]
# u = [7.82404601085629, 6.4377516497364, 6.03228654162824, 2.99573227355399, 2.484906649788, 1.09861228866811]
# C = [0.693147180559945, u[6], l[5], 1.79175946922805, 2.07944154167984, u[4], 2.30258509299405, u[5], 6000.0, 0.0, 1.0]
# k = [200000, 150000]
# obj_k = [250, 0.6, 500, 0.6, 340]

# Manipulated
l = [5.52146091786225, 5.40367788220586, 4.60517018598809, 1.89711998488588, 1.38629436111989, 0]
u = [7.82404601085629, 6.4377516497364, 6.03228654162824, 4.0, 3.0, 2.0]
C = [0.693147180559945, u[6], l[5], 1.79175946922805, 2.07944154167984, u[4], 2.30258509299405, u[5], 6000.0, 0.0, 1.0]
k = [200, 1500]
obj_k = [100, 0.6, 100, 0.6, 40]


for i = 1:10

    function problem_instance_OA(solver)

        m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
        set_optimizer_attribute(m, "bonmin.algorithm", solver)
        set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

        # ----- Variables ----- #
        @variable(m, objvar)
        x_Idx = Any[11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        @variable(m, 0 <= x[x_Idx] <= 5)
        i_Idx = Any[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        @variable(m, 0 <= i[i_Idx] <= 5, Int)


        # ----- Constraints ----- #
        @constraint(m, e1, 0.53 * i[1] + 0.65 * i[2] + 0.49 * i[3] + 0.82 * i[4] + 0.88 * i[5] + 0.97 * i[6] + 0.53 * i[7] + 0.33 * i[8] + 0.11 * i[9] + 0.61 * i[10] + 0.78 * x[11] + 0.09 * x[12] + 0.27 * x[13] + 0.15 * x[14] + 0.28 * x[15] + 0.44 * x[16] + 0.53 * x[17] + 0.46 * x[18] + 0.88 * x[19] + 0.15 * x[20] + objvar == 0.0)
        @NLconstraint(m, e2, (2^(i[1] + i[2]) + 2^(i[2] + i[3]) + 2^(i[3] + i[4]) + 2^(i[4] + i[5]) + 2^(i[5] + i[6]) + 2^(i[6] + i[7]) + 2^(i[7] + i[8]) + 2^(i[8] + i[9]) + 2^(i[9] + i[10]) + 2^(i[10] + x[11]) + 2^(x[11] + x[12]) + 2^(x[12] + x[13]) + 2^(x[13] + x[14]) + 2^(x[14] + x[15]) + 2^(x[15] + x[16]) + 2^(x[16] + x[17]) + 2^(x[17] + x[18]) + 2^(x[18] + x[19]) + 2^(x[19] + x[20]))^2 <= 57600.0)


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
        x_Idx = Any[11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        @variable(m, 0 <= x[x_Idx] <= 5)
        i_Idx = Any[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        @variable(m, 0 <= i[i_Idx] <= 5, Int)


        # ----- Constraints ----- #
        @constraint(m, e1, 0.53 * i[1] + 0.65 * i[2] + 0.49 * i[3] + 0.82 * i[4] + 0.88 * i[5] + 0.97 * i[6] + 0.53 * i[7] + 0.33 * i[8] + 0.11 * i[9] + 0.61 * i[10] + 0.78 * x[11] + 0.09 * x[12] + 0.27 * x[13] + 0.15 * x[14] + 0.28 * x[15] + 0.44 * x[16] + 0.53 * x[17] + 0.46 * x[18] + 0.88 * x[19] + 0.15 * x[20] + objvar == 0.0)
        @NLconstraint(m, e2, (2^(i[1] + i[2]) + 2^(i[2] + i[3]) + 2^(i[3] + i[4]) + 2^(i[4] + i[5]) + 2^(i[5] + i[6]) + 2^(i[6] + i[7]) + 2^(i[7] + i[8]) + 2^(i[8] + i[9]) + 2^(i[9] + i[10]) + 2^(i[10] + x[11]) + 2^(x[11] + x[12]) + 2^(x[12] + x[13]) + 2^(x[13] + x[14]) + 2^(x[14] + x[15]) + 2^(x[15] + x[16]) + 2^(x[16] + x[17]) + 2^(x[17] + x[18]) + 2^(x[18] + x[19]) + 2^(x[19] + x[20]))^2 <= 57600.0)


        # ----- Objective ----- #
        @objective(m, Min, objvar)


        optimize!(m)

        val = objective_value(m)
        sol = solve_time(m)

        return val, sol

    end

    global obj_val_OA, sol_time_OA = problem_instance_OA("B-OA")
    global obj_val_BB, sol_time_BB = problem_instance_BB("BARON")

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

println("Sol time (BB): $(median(sol_time_BB_vec))")
println("Sol time (OA): $(median(sol_time_OA_vec))")