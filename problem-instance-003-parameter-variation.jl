# instances/minlp2/batchdes.jl

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


for i = 1:100

    function problem_instance_OA(solver)

        m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
        set_optimizer_attribute(m, "bonmin.algorithm", solver)
        set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

        # ----- Variables ----- #
        @variable(m, objvar)
        b_Idx = Any[1, 2, 3, 4, 5, 6, 7, 8, 9]
        @variable(m, b[b_Idx], Bin)
        x_Idx = Any[10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
        @variable(m, x[x_Idx])
        set_lower_bound(x[17], l[6])
        set_lower_bound(x[19], l[6])
        set_lower_bound(x[18], l[6])
        set_lower_bound(x[10], l[1])
        set_upper_bound(x[10], u[1])
        set_lower_bound(x[11], l[1])
        set_upper_bound(x[11], u[1])
        set_lower_bound(x[12], l[1])
        set_upper_bound(x[12], u[1])
        set_lower_bound(x[13], l[2])
        set_upper_bound(x[13], u[2])
        set_lower_bound(x[14], l[3])
        set_upper_bound(x[14], u[3])
        set_lower_bound(x[15], l[4])
        set_upper_bound(x[15], u[4])
        set_lower_bound(x[16], l[5])
        set_upper_bound(x[16], u[5])
        set_upper_bound(x[17], u[6])
        set_upper_bound(x[18], u[6])
        set_upper_bound(x[19], u[6])


        # ----- Constraints ----- #
        @constraint(m, e1, x[10] - x[13] >= C[1])
        @constraint(m, e2, x[11] - x[13] >= C[2])
        @constraint(m, e3, x[12] - x[13] >= C[3])
        @constraint(m, e4, x[10] - x[14] >= C[3])
        @constraint(m, e5, x[11] - x[14] >= C[4])
        @constraint(m, e6, x[12] - x[14] >= C[2])
        @constraint(m, e7, x[15] + x[17] >= C[5])
        @constraint(m, e8, x[15] + x[18] >= C[6])
        @constraint(m, e9, x[15] + x[19] >= C[3])
        @constraint(m, e10, x[16] + x[17] >= C[7])
        @constraint(m, e11, x[16] + x[18] >= C[8])
        @constraint(m, e12, x[16] + x[19] >= C[2])
        @NLconstraint(m, e13, k[1] * exp(x[15] - x[13]) + k[2] * exp(x[16] - x[14]) <= C[9])
        @constraint(m, e14, -C[1] * b[4] - C[2] * b[7] + x[17] == C[10])
        @constraint(m, e15, -C[1] * b[5] - C[2] * b[8] + x[18] == C[10])
        @constraint(m, e16, -C[1] * b[6] - C[2] * b[9] + x[19] == C[10])
        @constraint(m, e17, b[1] + b[4] + b[7] == C[11])
        @constraint(m, e18, b[2] + b[5] + b[8] == C[11])
        @constraint(m, e19, b[3] + b[6] + b[9] == C[11])
        @NLconstraint(m, e20, -(obj_k[1] * exp(obj_k[2] * x[10] + x[17]) + obj_k[3] * exp(obj_k[4] * x[11] + x[18]) + obj_k[5] * exp(obj_k[4] * x[12] + x[19])) + objvar == 0.0)


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
        b_Idx = Any[1, 2, 3, 4, 5, 6, 7, 8, 9]
        @variable(m, b[b_Idx], Bin)
        x_Idx = Any[10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
        @variable(m, x[x_Idx])
        set_lower_bound(x[17], l[6])
        set_lower_bound(x[19], l[6])
        set_lower_bound(x[18], l[6])
        set_lower_bound(x[10], l[1])
        set_upper_bound(x[10], u[1])
        set_lower_bound(x[11], l[1])
        set_upper_bound(x[11], u[1])
        set_lower_bound(x[12], l[1])
        set_upper_bound(x[12], u[1])
        set_lower_bound(x[13], l[2])
        set_upper_bound(x[13], u[2])
        set_lower_bound(x[14], l[3])
        set_upper_bound(x[14], u[3])
        set_lower_bound(x[15], l[4])
        set_upper_bound(x[15], u[4])
        set_lower_bound(x[16], l[5])
        set_upper_bound(x[16], u[5])
        set_upper_bound(x[17], u[6])
        set_upper_bound(x[18], u[6])
        set_upper_bound(x[19], u[6])


        # ----- Constraints ----- #
        @constraint(m, e1, x[10] - x[13] >= C[1])
        @constraint(m, e2, x[11] - x[13] >= C[2])
        @constraint(m, e3, x[12] - x[13] >= C[3])
        @constraint(m, e4, x[10] - x[14] >= C[3])
        @constraint(m, e5, x[11] - x[14] >= C[4])
        @constraint(m, e6, x[12] - x[14] >= C[2])
        @constraint(m, e7, x[15] + x[17] >= C[5])
        @constraint(m, e8, x[15] + x[18] >= C[6])
        @constraint(m, e9, x[15] + x[19] >= C[3])
        @constraint(m, e10, x[16] + x[17] >= C[7])
        @constraint(m, e11, x[16] + x[18] >= C[8])
        @constraint(m, e12, x[16] + x[19] >= C[2])
        @NLconstraint(m, e13, k[1] * exp(x[15] - x[13]) + k[2] * exp(x[16] - x[14]) <= C[9])
        @constraint(m, e14, -C[1] * b[4] - C[2] * b[7] + x[17] == C[10])
        @constraint(m, e15, -C[1] * b[5] - C[2] * b[8] + x[18] == C[10])
        @constraint(m, e16, -C[1] * b[6] - C[2] * b[9] + x[19] == C[10])
        @constraint(m, e17, b[1] + b[4] + b[7] == C[11])
        @constraint(m, e18, b[2] + b[5] + b[8] == C[11])
        @constraint(m, e19, b[3] + b[6] + b[9] == C[11])
        @NLconstraint(m, e20, -(obj_k[1] * exp(obj_k[2] * x[10] + x[17]) + obj_k[3] * exp(obj_k[4] * x[11] + x[18]) + obj_k[5] * exp(obj_k[4] * x[12] + x[19])) + objvar == 0.0)


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

println("Sol time (BB): $(median(sol_time_BB_vec))")
println("Sol time (OA): $(median(sol_time_OA_vec))")