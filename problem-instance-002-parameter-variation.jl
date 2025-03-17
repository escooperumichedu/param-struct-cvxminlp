# instances/minlp2/st_e14.jl

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
# global u = [10.0, 1.0]
# global C = [5.0, 5.5, 1.2, 1.8, 2.5, 1.2, 1.64, 4.25, 4.64, 0, 0, 0, 0]
# global obj_k = [1 2 1 1 1 2 3]

# Manipulated
# global u = [10.0, 1.0]
# global C = [0.0, 0.5, 0.0, 1.8, 2.5, 1.2, 1.0, 1.0, 1.0, 0, 0, 0, 0]
# global obj_k = [1 2 5 5 5 5 3]


for i = 1:100

    function problem_instance_OA(solver)

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
        set_upper_bound(x[2], u[1])
        set_upper_bound(x[3], u[1])
        set_upper_bound(x[4], u[2])
        set_upper_bound(x[5], u[2])
        set_upper_bound(x[6], u[2])
        set_upper_bound(x[7], u[2])


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
        @NLconstraint(m, e14, -((x[4] - obj_k[1])^2 + (x[5] - obj_k[2])^2 + (x[6] - obj_k[3])^2 - log(obj_k[4] + x[7]) + (x[1] - obj_k[5])^2 + (x[2] - obj_k[6])^2 + (x[3] - obj_k[7])^2) + objvar == 0.0)

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
        x_Idx = Any[1, 2, 3, 4, 5, 6, 7]
        @variable(m, x[x_Idx] >= 0)
        b_Idx = Any[8, 9, 10, 11]
        @variable(m, b[b_Idx], Bin)
        set_upper_bound(x[1], u[1])
        set_upper_bound(x[2], u[1])
        set_upper_bound(x[3], u[1])
        set_upper_bound(x[4], u[2])
        set_upper_bound(x[5], u[2])
        set_upper_bound(x[6], u[2])
        set_upper_bound(x[7], u[2])


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
        @NLconstraint(m, e14, -((x[4] - obj_k[1])^2 + (x[5] - obj_k[2])^2 + (x[6] - obj_k[3])^2 - log(obj_k[4] + x[7]) + (x[1] - obj_k[5])^2 + (x[2] - obj_k[6])^2 + (x[3] - obj_k[7])^2) + objvar == 0.0)

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