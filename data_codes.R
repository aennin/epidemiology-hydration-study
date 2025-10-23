set.seed(123)

# Sample size (n = 100, 50 per group)
n = 100

# Create participant IDs
id = paste0("P", 1001:(1000 + n))

# Randomize to Water (0) or Sport Drink (1)
group = rep(c("Water", "Sport Drink"), each = n/2) # Fixed equal allocation

# Simulate baseline characteristics
age = round(rnorm(n, mean = 25, sd = 3)) # Healthy young adults
sex = sample(c("Male", "Female"), size = n, replace = TRUE, prob = c(0.6, 0.4))
# More males in exercise studies
weight_pre = round(rnorm(n, mean = 70, sd = 5), 1) # kg

# Simulate exercise-induced weight loss (1-3% of body weight)
weight_loss_pct = runif(n, min = 1, max = 3)
weight_loss_kg = round(weight_pre * (weight_loss_pct / 100), 2)

# PRIMARY OUTCOME: Urine Specific Gravity (USG)
usg = ifelse(group == "Sport Drink", 
             rnorm(n, mean = 1.012, sd = 0.003), # Better hydration
             rnorm(n, mean = 1.020, sd = 0.004)) # Mild dehydration

# SECONDARY OUTCOMES:

# 1. Weight recovery (% of lost weight regained)
weight_recovery = ifelse(group == "Sport Drink",
                         runif(n, min = 90, max = 100), # 90 - 100% recovery
                         runif(n, min = 80, max = 92)) # 80 - 92% recovery

# 2. Thirst score (1 - 10 VAS)
thirst_score = ifelse(group == "Sport Drink",
                      pmax(1, pmin(10, round(rnorm(n, mean = 3, sd = 1)))), # Bounded 1-10
                      pmax(1, pmin(10, round(rnorm(n, mean = 5, sd = 1.2)))))

# 3. Tolerability (binary: 0 =no side effects, 1 = bloating/nausea)
tolerability = ifelse(group == "Sport Drink",
                      rbinom(n, size = 1, prob = 0.25), # 25% chance
                      rbinom(n, size = 1, prob = 0.10)) # 10% chance
# Combine into dataframe
study_data = data.frame(id, group, age, sex, weight_pre, weight_loss_pct, weight_loss_kg, usg, weight_recovery, thirst_score, tolerability)

# Save as CSV
write.csv(study_data, "hydration_study_N100_simulated_data.csv", row.names = FALSE)

