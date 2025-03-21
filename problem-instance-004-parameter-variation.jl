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
obj_val_BB_vec = zeros(10)
obj_val_OA_vec = zeros(10)
sol_time_BB_vec = zeros(10)
sol_time_OA_vec = zeros(10)

# Default
# l = [5.52146091786225, 5.40367788220586, 4.60517018598809, 1.89711998488588, 1.38629436111989, 0]
# u = [7.82404601085629, 6.4377516497364, 6.03228654162824, 2.99573227355399, 2.484906649788, 1.09861228866811]
# C = [0.693147180559945, u[6], l[5], 1.79175946922805, 2.07944154167984, u[4], 2.30258509299405, u[5], 6000.0, 0.0, 1.0]
# k = [200000, 150000]
# obj_k = [250, 0.6, 500, 0.6, 340]

# Manipulated
l = [5.52146091786225, 5.40367788220586, 4.60517018598809, 1.89711998488588, 1.38629436111989, 0]
u = [5*rand()+l[1], 10*rand()+l[2], 10*rand()+l[3], 4.0, 3.0, 2.0]
C = [2*rand(), u[6], l[5], 4*rand(), 4*rand(), u[4], 4*rand(), u[5], 6000.0, 0.0, 1.0]
k = [200, 1500]
obj_k = [100, 0.6, 100, 0.6, 40]


for i = 1:10

    function problem_instance_OA(solver)

        m = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
        set_optimizer_attribute(m, "bonmin.algorithm", solver)
        set_optimizer_attribute(m, "bonmin.time_limit", time_limit)

        # ----- Variables ----- #
        @variable(m, objvar)
        x_Idx = Any[1, 2, 3, 4, 5, 6, 25, 26, 27, 28, 29, 30]
        @variable(m, x[x_Idx])
        b_Idx = Any[7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
        @variable(m, b[b_Idx], Bin)
        set_lower_bound(x[27], 0.0)
        set_lower_bound(x[25], 0.0)
        set_lower_bound(x[30], 0.0)
        set_lower_bound(x[26], 0.0)
        set_lower_bound(x[29], 0.0)
        set_lower_bound(x[28], 0.0)
        set_lower_bound(x[1], 11.5)
        set_upper_bound(x[1], 52.5)
        set_lower_bound(x[2], 12.5)
        set_upper_bound(x[2], 51.5)
        set_lower_bound(x[3], 10.5)
        set_upper_bound(x[3], 53.5)
        set_lower_bound(x[4], 7.0)
        set_upper_bound(x[4], 82.0)
        set_lower_bound(x[5], 6.5)
        set_upper_bound(x[5], 82.5)
        set_lower_bound(x[6], 5.5)
        set_upper_bound(x[6], 83.5)


        # ----- Constraints ----- #
        @constraint(m, e1, -300 * x[25] - 240 * x[26] - 100 * x[27] - 300 * x[28] - 240 * x[29] - 100 * x[30] + objvar == 0.0)
        @constraint(m, e2, -x[1] + x[2] + x[25] >= 0.0)
        @constraint(m, e3, -x[1] + x[3] + x[26] >= 0.0)
        @constraint(m, e4, -x[2] + x[3] + x[27] >= 0.0)
        @constraint(m, e5, x[1] - x[2] + x[25] >= 0.0)
        @constraint(m, e6, x[1] - x[3] + x[26] >= 0.0)
        @constraint(m, e7, x[2] - x[3] + x[27] >= 0.0)
        @constraint(m, e8, -x[4] + x[5] + x[28] >= 0.0)
        @constraint(m, e9, -x[4] + x[6] + x[29] >= 0.0)
        @constraint(m, e10, -x[5] + x[6] + x[30] >= 0.0)
        @constraint(m, e11, x[4] - x[5] + x[28] >= 0.0)
        @constraint(m, e12, x[4] - x[6] + x[29] >= 0.0)
        @constraint(m, e13, x[5] - x[6] + x[30] >= 0.0)
        @constraint(m, e14, x[1] - x[2] + 46 * b[7] <= 40.0)
        @constraint(m, e15, x[1] - x[3] + 46 * b[8] <= 42.0)
        @constraint(m, e16, x[2] - x[3] + 46 * b[9] <= 41.0)
        @constraint(m, e17, -x[1] + x[2] + 46 * b[10] <= 40.0)
        @constraint(m, e18, -x[1] + x[3] + 46 * b[11] <= 42.0)
        @constraint(m, e19, -x[2] + x[3] + 46 * b[12] <= 41.0)
        @constraint(m, e20, x[4] - x[5] + 81 * b[13] <= 75.5)
        @constraint(m, e21, x[4] - x[6] + 81 * b[14] <= 76.5)
        @constraint(m, e22, x[5] - x[6] + 81 * b[15] <= 77.0)
        @constraint(m, e23, -x[4] + x[5] + 81 * b[16] <= 75.5)
        @constraint(m, e24, -x[4] + x[6] + 81 * b[17] <= 76.5)
        @constraint(m, e25, -x[5] + x[6] + 81 * b[18] <= 77.0)
        @constraint(m, e26, b[7] + b[10] + b[13] + b[16] == 1.0)
        @constraint(m, e27, b[8] + b[11] + b[14] + b[17] == 1.0)
        @constraint(m, e28, b[9] + b[12] + b[15] + b[18] == 1.0)
        @NLconstraint(m, e29, ((-17.5) + x[1])^2 + ((-7) + x[4])^2 + 6814 * b[19] <= 6850.0)
        @NLconstraint(m, e30, ((-18.5) + x[2])^2 + ((-7.5) + x[5])^2 + 6678 * b[20] <= 6714.0)
        @NLconstraint(m, e31, ((-16.5) + x[3])^2 + ((-8.5) + x[6])^2 + 6958 * b[21] <= 6994.0)
        @NLconstraint(m, e32, ((-52.5) + x[1])^2 + ((-77) + x[4])^2 + 6556 * b[22] <= 6581.0)
        @NLconstraint(m, e33, ((-53.5) + x[2])^2 + ((-77.5) + x[5])^2 + 6697 * b[23] <= 6722.0)
        @NLconstraint(m, e34, ((-51.5) + x[3])^2 + ((-78.5) + x[6])^2 + 6985 * b[24] <= 7010.0)
        @NLconstraint(m, e35, ((-17.5) + x[1])^2 + ((-13) + x[4])^2 + 5950 * b[19] <= 5986.0)
        @NLconstraint(m, e36, ((-18.5) + x[2])^2 + ((-12.5) + x[5])^2 + 5953 * b[20] <= 5989.0)
        @NLconstraint(m, e37, ((-16.5) + x[3])^2 + ((-11.5) + x[6])^2 + 6517 * b[21] <= 6553.0)
        @NLconstraint(m, e38, ((-52.5) + x[1])^2 + ((-83) + x[4])^2 + 7432 * b[22] <= 7457.0)
        @NLconstraint(m, e39, ((-53.5) + x[2])^2 + ((-82.5) + x[5])^2 + 7432 * b[23] <= 7457.0)
        @NLconstraint(m, e40, ((-51.5) + x[3])^2 + ((-81.5) + x[6])^2 + 7432 * b[24] <= 7457.0)
        @NLconstraint(m, e41, ((-12.5) + x[1])^2 + ((-7) + x[4])^2 + 7189 * b[19] <= 7225.0)
        @NLconstraint(m, e42, ((-11.5) + x[2])^2 + ((-7.5) + x[5])^2 + 7189 * b[20] <= 7225.0)
        @NLconstraint(m, e43, ((-13.5) + x[3])^2 + ((-8.5) + x[6])^2 + 7189 * b[21] <= 7225.0)
        @NLconstraint(m, e44, ((-47.5) + x[1])^2 + ((-77) + x[4])^2 + 6171 * b[22] <= 6196.0)
        @NLconstraint(m, e45, ((-46.5) + x[2])^2 + ((-77.5) + x[5])^2 + 6172 * b[23] <= 6197.0)
        @NLconstraint(m, e46, ((-48.5) + x[3])^2 + ((-78.5) + x[6])^2 + 6748 * b[24] <= 6773.0)
        @NLconstraint(m, e47, ((-12.5) + x[1])^2 + ((-13) + x[4])^2 + 6325 * b[19] <= 6361.0)
        @NLconstraint(m, e48, ((-11.5) + x[2])^2 + ((-12.5) + x[5])^2 + 6464 * b[20] <= 6500.0)
        @NLconstraint(m, e49, ((-13.5) + x[3])^2 + ((-11.5) + x[6])^2 + 6748 * b[21] <= 6784.0)
        @NLconstraint(m, e50, ((-47.5) + x[1])^2 + ((-83) + x[4])^2 + 7047 * b[22] <= 7072.0)
        @NLconstraint(m, e51, ((-46.5) + x[2])^2 + ((-82.5) + x[5])^2 + 6907 * b[23] <= 6932.0)
        @NLconstraint(m, e52, ((-48.5) + x[3])^2 + ((-81.5) + x[6])^2 + 7195 * b[24] <= 7220.0)
        @constraint(m, e53, b[19] + b[22] == 1.0)
        @constraint(m, e54, b[20] + b[23] == 1.0)
        @constraint(m, e55, b[21] + b[24] == 1.0)


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
        x_Idx = Any[1, 2, 3, 4, 5, 6, 25, 26, 27, 28, 29, 30]
        @variable(m, x[x_Idx])
        b_Idx = Any[7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
        @variable(m, b[b_Idx], Bin)
        set_lower_bound(x[27], 0.0)
        set_lower_bound(x[25], 0.0)
        set_lower_bound(x[30], 0.0)
        set_lower_bound(x[26], 0.0)
        set_lower_bound(x[29], 0.0)
        set_lower_bound(x[28], 0.0)
        set_lower_bound(x[1], 11.5)
        set_upper_bound(x[1], 52.5)
        set_lower_bound(x[2], 12.5)
        set_upper_bound(x[2], 51.5)
        set_lower_bound(x[3], 10.5)
        set_upper_bound(x[3], 53.5)
        set_lower_bound(x[4], 7.0)
        set_upper_bound(x[4], 82.0)
        set_lower_bound(x[5], 6.5)
        set_upper_bound(x[5], 82.5)
        set_lower_bound(x[6], 5.5)
        set_upper_bound(x[6], 83.5)


        # ----- Constraints ----- #
        @constraint(m, e1, -300 * x[25] - 240 * x[26] - 100 * x[27] - 300 * x[28] - 240 * x[29] - 100 * x[30] + objvar == 0.0)
        @constraint(m, e2, -x[1] + x[2] + x[25] >= 0.0)
        @constraint(m, e3, -x[1] + x[3] + x[26] >= 0.0)
        @constraint(m, e4, -x[2] + x[3] + x[27] >= 0.0)
        @constraint(m, e5, x[1] - x[2] + x[25] >= 0.0)
        @constraint(m, e6, x[1] - x[3] + x[26] >= 0.0)
        @constraint(m, e7, x[2] - x[3] + x[27] >= 0.0)
        @constraint(m, e8, -x[4] + x[5] + x[28] >= 0.0)
        @constraint(m, e9, -x[4] + x[6] + x[29] >= 0.0)
        @constraint(m, e10, -x[5] + x[6] + x[30] >= 0.0)
        @constraint(m, e11, x[4] - x[5] + x[28] >= 0.0)
        @constraint(m, e12, x[4] - x[6] + x[29] >= 0.0)
        @constraint(m, e13, x[5] - x[6] + x[30] >= 0.0)
        @constraint(m, e14, x[1] - x[2] + 46 * b[7] <= 40.0)
        @constraint(m, e15, x[1] - x[3] + 46 * b[8] <= 42.0)
        @constraint(m, e16, x[2] - x[3] + 46 * b[9] <= 41.0)
        @constraint(m, e17, -x[1] + x[2] + 46 * b[10] <= 40.0)
        @constraint(m, e18, -x[1] + x[3] + 46 * b[11] <= 42.0)
        @constraint(m, e19, -x[2] + x[3] + 46 * b[12] <= 41.0)
        @constraint(m, e20, x[4] - x[5] + 81 * b[13] <= 75.5)
        @constraint(m, e21, x[4] - x[6] + 81 * b[14] <= 76.5)
        @constraint(m, e22, x[5] - x[6] + 81 * b[15] <= 77.0)
        @constraint(m, e23, -x[4] + x[5] + 81 * b[16] <= 75.5)
        @constraint(m, e24, -x[4] + x[6] + 81 * b[17] <= 76.5)
        @constraint(m, e25, -x[5] + x[6] + 81 * b[18] <= 77.0)
        @constraint(m, e26, b[7] + b[10] + b[13] + b[16] == 1.0)
        @constraint(m, e27, b[8] + b[11] + b[14] + b[17] == 1.0)
        @constraint(m, e28, b[9] + b[12] + b[15] + b[18] == 1.0)
        @NLconstraint(m, e29, ((-17.5) + x[1])^2 + ((-7) + x[4])^2 + 6814 * b[19] <= 6850.0)
        @NLconstraint(m, e30, ((-18.5) + x[2])^2 + ((-7.5) + x[5])^2 + 6678 * b[20] <= 6714.0)
        @NLconstraint(m, e31, ((-16.5) + x[3])^2 + ((-8.5) + x[6])^2 + 6958 * b[21] <= 6994.0)
        @NLconstraint(m, e32, ((-52.5) + x[1])^2 + ((-77) + x[4])^2 + 6556 * b[22] <= 6581.0)
        @NLconstraint(m, e33, ((-53.5) + x[2])^2 + ((-77.5) + x[5])^2 + 6697 * b[23] <= 6722.0)
        @NLconstraint(m, e34, ((-51.5) + x[3])^2 + ((-78.5) + x[6])^2 + 6985 * b[24] <= 7010.0)
        @NLconstraint(m, e35, ((-17.5) + x[1])^2 + ((-13) + x[4])^2 + 5950 * b[19] <= 5986.0)
        @NLconstraint(m, e36, ((-18.5) + x[2])^2 + ((-12.5) + x[5])^2 + 5953 * b[20] <= 5989.0)
        @NLconstraint(m, e37, ((-16.5) + x[3])^2 + ((-11.5) + x[6])^2 + 6517 * b[21] <= 6553.0)
        @NLconstraint(m, e38, ((-52.5) + x[1])^2 + ((-83) + x[4])^2 + 7432 * b[22] <= 7457.0)
        @NLconstraint(m, e39, ((-53.5) + x[2])^2 + ((-82.5) + x[5])^2 + 7432 * b[23] <= 7457.0)
        @NLconstraint(m, e40, ((-51.5) + x[3])^2 + ((-81.5) + x[6])^2 + 7432 * b[24] <= 7457.0)
        @NLconstraint(m, e41, ((-12.5) + x[1])^2 + ((-7) + x[4])^2 + 7189 * b[19] <= 7225.0)
        @NLconstraint(m, e42, ((-11.5) + x[2])^2 + ((-7.5) + x[5])^2 + 7189 * b[20] <= 7225.0)
        @NLconstraint(m, e43, ((-13.5) + x[3])^2 + ((-8.5) + x[6])^2 + 7189 * b[21] <= 7225.0)
        @NLconstraint(m, e44, ((-47.5) + x[1])^2 + ((-77) + x[4])^2 + 6171 * b[22] <= 6196.0)
        @NLconstraint(m, e45, ((-46.5) + x[2])^2 + ((-77.5) + x[5])^2 + 6172 * b[23] <= 6197.0)
        @NLconstraint(m, e46, ((-48.5) + x[3])^2 + ((-78.5) + x[6])^2 + 6748 * b[24] <= 6773.0)
        @NLconstraint(m, e47, ((-12.5) + x[1])^2 + ((-13) + x[4])^2 + 6325 * b[19] <= 6361.0)
        @NLconstraint(m, e48, ((-11.5) + x[2])^2 + ((-12.5) + x[5])^2 + 6464 * b[20] <= 6500.0)
        @NLconstraint(m, e49, ((-13.5) + x[3])^2 + ((-11.5) + x[6])^2 + 6748 * b[21] <= 6784.0)
        @NLconstraint(m, e50, ((-47.5) + x[1])^2 + ((-83) + x[4])^2 + 7047 * b[22] <= 7072.0)
        @NLconstraint(m, e51, ((-46.5) + x[2])^2 + ((-82.5) + x[5])^2 + 6907 * b[23] <= 6932.0)
        @NLconstraint(m, e52, ((-48.5) + x[3])^2 + ((-81.5) + x[6])^2 + 7195 * b[24] <= 7220.0)
        @constraint(m, e53, b[19] + b[22] == 1.0)
        @constraint(m, e54, b[20] + b[23] == 1.0)
        @constraint(m, e55, b[21] + b[24] == 1.0)


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