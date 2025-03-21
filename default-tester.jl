using JuMP, AmplNLWriter, BARON, CSV, DataFrames, Statistics
import Bonmin_jll
global time_limit = 300.0

dir_instances = "C:\\Users\\goson\\Desktop\\git\\param-struct-cvxminlp\\instances-2.csv"

instances = CSV.read(dir_instances, DataFrame, header=false)

results = zeros(285, 4)
for i = 1:285
    prob = instances[i, 1]

    println("
    ******************************************************************************
    ******************************************************************************
    ******************************************************************************
    ******************************************************************************
    ******************************************************************************
    ******************************************************************************
    ")

    obj_val_BB_vec = zeros(1)
    obj_val_OA_vec = zeros(1)
    sol_time_BB_vec = zeros(1)
    sol_time_OA_vec = zeros(1)

    for j = 1:1
        function problem_instance(solver)
            include("D:\\minlp\\minlp2\\$(prob).jl")

            if solver == "B-OA"
                set_optimizer(m, () -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))  # Fix: Pass as a callable function
                set_optimizer_attribute(m, "bonmin.algorithm", "B-OA")  # Fix: Use actual string value
                set_optimizer_attribute(m, "bonmin.time_limit", time_limit)
            elseif solver == "BARON"
                set_optimizer(m, BARON.Optimizer)
                set_optimizer_attribute(m, "MaxTime", time_limit)
            end

            optimize!(m)
            sol = solve_time(m)

            # Check termination status
            status = termination_status(m)
            if status == MOI.INFEASIBLE || status == MOI.INFEASIBLE_OR_UNBOUNDED
                println("Problem is infeasible. Skipping objective value retrieval.")
                return 1e12, sol  # Return a large value to indicate infeasibility
            elseif sol >= (time_limit - 1.0)
                return 1e12, sol  # Return a large value if time limit is reached
            else
                return objective_value(m), sol
            end
        end

        global obj_val_BB, sol_time_BB = problem_instance("BARON")
        global obj_val_OA, sol_time_OA = problem_instance("B-OA")
    end

    println("Sol time (BARON): $(mean(sol_time_BB))")
    println("Solution (BARON): $(mean(obj_val_BB))")
    println("Sol time (OA): $(mean(sol_time_OA))")
    println("Solution (OA): $(mean(obj_val_OA))")
    println("$(mean(sol_time_BB)), $(mean(obj_val_BB)), $(mean(sol_time_OA)), $(mean(obj_val_OA))")
    results[i, 1] = sol_time_BB
    results[i, 2] = obj_val_BB
    results[i, 3] = sol_time_OA
    results[i, 4] = obj_val_OA
end

results[310,1]
df_results = DataFrame(results, :auto)
CSV.write("results-from-tmax-025-test-instance-360sec.csv", df_results)