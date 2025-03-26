using JuMP

m = Model()

u = [1.0e15, 1.0, 2.0]
C = [16.0, 1.0, 24.0, 12.0, 3.0]
k = [2, 8, 3, 5, 4, 0.5, 0.2, 0.1]
k_obj = [0.5 6.5 7 2 3 2]
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
@constraint(m, e1, i[1]+k[1]*i[2]+k[2]*i[3]+i[4]+k[3]*i[5]+k[4]*i[6] <= C[1])
@constraint(m, e2, -k[2]*i[1]-k[5]*i[2]-k[1]*i[3]+k[1]*i[4]+k[5]*i[5]-i[6] <= -C[2])
@constraint(m, e3, k[1]*i[1]+k[6]*i[2]+k[7]*i[3]-k[3]*i[4]-i[5]-k[5]*i[6] <= C[3])
@constraint(m, e4, k[7]*i[1]+k[1]*i[2]+k[8]*i[3]-k[5]*i[4]+k[1]*i[5]+k[1]*i[6] <= C[4])
@constraint(m, e5, -k[8]*i[1]-k[6]*i[2]+k[1]*i[3]+k[4]*i[4]-k[4]*i[5]+k[3]*i[6] <= C[5])
@NLconstraint(m, e6, -(k_obj[1]*i[1]*i[1]+k_obj[2]*i[1]+k_obj[3]*i[6]*i[6]-i[6])+i[2]+k_obj[4]*i[3]-k_obj[5]*i[4]+k_obj[6]*i[5]+objvar == 0.0)


# ----- Objective ----- #
@objective(m, Min, objvar)