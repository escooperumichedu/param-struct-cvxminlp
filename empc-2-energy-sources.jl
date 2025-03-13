using JuMP, Plots, Ipopt, NLsolve, AmplNLWriter, Bonmin_jll

global time_limit = 10.0
solver = "B-OA"



# Parameters
tau11 = -0.2
tau22 = -0.3
tau12 = -20
tau21 = -30
k11 = 10
k22 = 10
k12 = 0.01
k21 = 0.015
M = 1000 # Big-M

x1_sp = 5
x2_sp = 10
u1_sp = 2.8595600676844435
u2_sp = 1.4043993231807903
dt = 0.01
N = 100

u2_price = 50 * rand(N + 1)
u3_price = 50 * rand(N + 1)
min_on_time = 10  # Minimum number of time steps an input must stay on

# Steady-state calculation
function f(u)
    x1 = x1_sp
    x2 = x2_sp
    [
        k11 * u[1] + k12 * u[2] + x1 / tau11 + x2 / tau12,  # dx1/dt = 0
        k21 * u[1] + k22 * u[2] + x1 / tau21 + x2 / tau22   # dx2/dt = 0
    ]
end

sol = nlsolve(f, [u1_sp, u2_sp])
u1_sp, u2_sp = sol.zero

# MPC solver
function MPC_solve(solver)
    mpcmodel = Model(Ipopt.Optimizer)

    mpcmodel = Model(() -> AmplNLWriter.Optimizer(Bonmin_jll.amplexe))
    set_optimizer_attribute(mpcmodel, "bonmin.algorithm", solver)
    set_optimizer_attribute(mpcmodel, "bonmin.time_limit", 10.0)

    # Variables
    JuMP.@variables mpcmodel begin
        x1[k=0:N] # State variable 1
        x2[k=0:N] # State variable 2
        u1[k=0:N], (upper_bound=50.0, lower_bound=0) # Control variable 1
        u2[k=0:N], (upper_bound=50.0, lower_bound=0) # Control variable 2 - Intermittent Renewable
        u3[k=0:N], (upper_bound=50.0, lower_bound=0) # Control variable 2 - Intermittent Renewable
        y[k=0:N], Bin # If =0 use u2, if =1 use u3
    end

    # Initial conditions
    @constraints mpcmodel begin
        x1_init, x1[0] == 6.0
        x2_init, x2[0] == 9.0
        energy_source1[k=0:N], u2[k] <= M * (1 - y[k])
        energy_source2[k=0:N], u3[k] <= M * y[k]
        # Detect switching: z[k] = 1 if y[k] != y[k+1]
        minimum_on1[k=1:N-min_on_time], sum(y[h] for h=k:k+min_on_time-1) >= min_on_time * (y[k] - y[k-1])
        minimum_on2[k=1:N-min_on_time], sum(1 - y[h] for h=k:min(N, k+min_on_time-1)) ≥ min(min_on_time, N-k+1) * (y[k-1] - y[k])
    end

    # Dynamics
    @NLconstraints mpcmodel begin
        dx1dt[k=0:N-1], x1[k+1] == x1[k] + (k11 * u1[k] + k12 * (u2[k] + u3[k]) + x1[k] / tau11 + x2[k] / tau12) * dt
        dx2dt[k=0:N-1], x2[k+1] == x2[k] + (k21 * u1[k] + k22 * (u2[k] + u3[k]) + x1[k] / tau21 + x2[k] / tau22) * dt
    end

    # Objective
    @NLobjective(mpcmodel, Min,
        sum((1 / x1_sp)^2 * (x1[k] - x1_sp)^2 + (1 / x2_sp)^2 * (x2[k] - x2_sp)^2 + 1e-1 * (1 / u1_sp)^2 * (u1[k] - u1_sp)^2 + u2_price[k+1] * (1 - y[k]) * 1e-1 * (1 / u2_sp)^2 * (u2[k] - u2_sp)^2 + u3_price[k+1] * (y[k]) * 1e-1 * (1 / u2_sp)^2 * (u3[k] - u2_sp)^2 for k = 0:N) +
        100 * (1 / x1_sp)^2 * (x1[N] - x1_sp)^2 +
        100 * (1 / x2_sp)^2 * (x2[N] - x2_sp)^2
    )

    # Solve
    JuMP.optimize!(mpcmodel)
    st = solve_time(mpcmodel)
    # Return results
    return Array(JuMP.value.(x1)[0:N]), Array(JuMP.value.(x2)[0:N]), Array(JuMP.value.(u1)[0:N]), Array(JuMP.value.(u2)[0:N]), Array(JuMP.value.(u3)[0:N]), st
end

# Run MPC
x1_arr_OA, x2_arr_OA, u1_arr_OA, u2_arr_OA, u3_arr_OA, st_OA = MPC_solve("B-OA")

# Plot results
times = [k * dt for k = 0:N]
p1 = plot(times, [x1_arr_OA, x2_arr_OA, u1_arr_OA, u2_arr_OA, u3_arr_OA], layout=(2, 3), label=["x1" "x2" "u1" "u2" "u3"], xlabel="Time", ylabel="Value of variable", size=(800, 500))

# Run MPC
x1_arr_QG, x2_arr_QG, u1_arr_QG, u2_arr_QG, u3_arr_QG, st_QG = MPC_solve("B-QG")

# Plot results
times = [k * dt for k = 0:N]
p2 = plot(times, [x1_arr_QG, x2_arr_QG, u1_arr_QG, u2_arr_QG, u3_arr_QG], layout=(2, 3), label=["x1" "x2" "u1" "u2" "u3"], xlabel="Time", ylabel="Value of variable", size=(800, 500))

println("
OA: $st_OA
QG: $st_QG
")

p = plot(p1, p2, size = (1100, 300))