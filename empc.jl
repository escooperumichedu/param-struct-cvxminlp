using JuMP, Plots, Ipopt, NLsolve

# Parameters
tau11 = -.2
tau22 = -.3
tau12 = -20
tau21 = -30
k11 = 10
k22 = 10
k12 = 0.01
k21 = 0.015

x1_sp = 5
x2_sp = 10
u1_sp = 2.8595600676844435
u2_sp = 1.4043993231807903
dt = 0.01
N = 100

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
function MPC_solve()
    mpcmodel = Model(Ipopt.Optimizer)

    # Variables
    JuMP.@variables mpcmodel begin
        x1[k=0:N] # State variable 1
        x2[k=0:N] # State variable 2
        u1[k=0:N], (upper_bound = 50.0, lower_bound = 0) # Control variable 1
        u2[k=0:N], (upper_bound = 50.0, lower_bound = 0) # Control variable 2
    end

    # Initial conditions
    @constraints mpcmodel begin
        x1_init, x1[0] == 6.0
        x2_init, x2[0] == 9.0
    end

    # Dynamics
    @NLconstraints mpcmodel begin
        dx1dt[k = 0:N-1], x1[k+1] == x1[k] + (k11*u1[k] + k12*u2[k] + x1[k]/tau11 + x2[k]/tau12)*dt
        dx2dt[k = 0:N-1], x2[k+1] == x2[k] + (k21*u1[k] + k22*u2[k] + x1[k]/tau21 + x2[k]/tau22)*dt
    end

    # Objective
    @objective(mpcmodel, Min, sum((1/x1_sp)^2*(x1[k] - x1_sp)^2 + (1/x2_sp)^2*(x2[k] - x2_sp)^2 + 1e-1*(1/u1_sp)^2*(u1[k] - u1_sp)^2 + 1e-1*(1/u2_sp)^2*(u2[k] - u2_sp)^2 for k=0:N) + 100*(1/x1_sp)^2*(x1[N] - x1_sp)^2 + 100*(1/x2_sp)^2*(x2[N] - x2_sp)^2)

    # Solve
    JuMP.optimize!(mpcmodel)

    # Return results
    return Array(JuMP.value.(x1)[0:N]), Array(JuMP.value.(x2)[0:N]), Array(JuMP.value.(u1)[0:N]), Array(JuMP.value.(u2)[0:N])
end

# Run MPC
x1_arr, x2_arr, u1_arr, u2_arr = MPC_solve()

# Plot results
times = [k * dt for k = 0:N]
plot(times, [x1_arr, x2_arr, u1_arr, u2_arr], layout=(2,2), label=["x1" "x2" "u1" "u2"], xlabel="Time", ylabel="Value of variable", size = (800,500))