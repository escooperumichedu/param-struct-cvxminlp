using JuMP

m = Model()

# ----- Variables ----- #
@variable(m, objvar)
x_Idx = Any[1, 2, 3]
@variable(m, 0 <= x[x_Idx] <= 10)
b_Idx = Any[4, 5, 6, 7]
@variable(m, b[b_Idx], Bin)

# ----- Constraints ----- #
@constraint(m, e1, x[1]+x[2]+x[3]+b[4]+b[5]+b[6] <= 5.0)
@NLconstraint(m, e2,  (x[1])^2+ (x[2])^2+ (x[3])^2+b[6] <= 5.5)
@constraint(m, e3, x[1]+b[4] <= 1.2)
@constraint(m, e4, x[2]+b[5] <= 1.8)
@constraint(m, e5, x[3]+b[6] <= 2.5)
@constraint(m, e6, x[1]+b[7] <= 1.2)
@NLconstraint(m, e7,  (x[2])^2+b[5] <= 1.64)
@NLconstraint(m, e8,  (x[3])^2+b[6] <= 4.25)
@NLconstraint(m, e9,  (x[3])^2+b[5] <= 4.64)
@NLconstraint(m, e10, -( (x[1]-1)^2+ (x[2]-2)^2+ (x[3]-3)^2)+b[4]+3*b[5]+b[6]+0.693147180559945*b[7]+objvar == 6.0)


# ----- Objective ----- #
@objective(m, Min, objvar)

 
