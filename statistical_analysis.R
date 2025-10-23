## Primary Outcome: Linear Model
study_data$group <- factor(study_data$group)    # convert to factor
study_data$group <- relevel(study_data$group, ref = "Water")  # set Water as baseline
model1 = lm(usg ~ group + age + sex, data = study_data)
summary(model1)
confint(model1)
plot(resid(model1))

# Check for assumption of linear model
library(car)
library(lmtest)

# i. Linearity: Residual vs Fitted plot
plot(model1$fitted.values, resid(model1),
     main = "Residuals vs Fitted",
     xlab = "Fitted values", ylab = "Residuals")
abline(h = 0, col = "red")

# Partial residual plots for predictors
crPlots(model1)

# ii. Independence: Durbin-Watson test
dwtest(model1)

# iii. Homoscedasticity: Breusch-Pagan test
bptest(model1)

# iv. Normality: Histogram and Q-Q plot of residuals
hist(resid(model1), main = "Histogram of residuals", xlab = "Residuals")
qqnorm(resid(model1)); qqline(resid(model1), col = "red")

shapiro.test(resid(model1))

# v. Multicollinearity
vif(model1)


## Secondary Outcome:
# 1. Weight recovery 
# Convert percentages to (0, 1) range
library(dplyr)
study_data = study_data %>%
  mutate(
    recovery_scaled = weight_recovery/100, # Convert to proportion
    recovery_scaled = case_when(
      recovery_scaled == 0 ~ 0.001, # Replace 0 with small value
      recovery_scaled == 1 ~ 0.999, # Replace 100% with value < 1
      TRUE ~ recovery_scaled # Keep others unchanged
    )
  )
library("betareg") # Using beta regression
weight_model = betareg(recovery_scaled ~ group + age + sex + weight_loss_pct, data = study_data, link = "logit")
summary(weight_model)

confint(weight_model)

# 2. Tolerability
tol_model = glm(tolerability ~ group + age + sex, family = binomial, data = study_data)
summary(tol_model)

confint(tol_model)

# 3. Thirst score
# Load required packages
library(MASS)     # For polr() function
library(brant)    # For proportional odds test
library(emmeans)  # For post-hoc comparisons

# Factor ordering (1-10 scale)
study_data$thirst_score = factor(study_data$thirst_score, 
                                  ordered = TRUE,
                                  levels = 1:10)
thirst_model = polr(thirst_score ~ group + age + sex,
                     data = study_data,
                     method = "logistic",
                     Hess = TRUE)  # For standard error
summary(thirst_model)

# Check Proportional Odds Assumption
brant_test = brant(thirst_model)

# Odds ratio and CI
or_results = exp(cbind(
  OR = coef(thirst_model),
  confint.default(thirst_model)  # Wald CIs
))
print(or_results)

#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
# USG model diagnostics
# Create figures directory if it doesn't exist
if (!dir.exists("figures")) {
  dir.create("figures")
}

# USG model diagnostics (4 plots)
pdf("figures/usg_diagnostics.pdf", width = 8, height = 8)
par(mfrow = c(2, 2)) # 2x2 grid
plot(model1) # Basic diagnostic plots
dev.off()

# Additional linearity check
pdf("figures/usg_crplots.pdf", width = 8, height = 6)
crPlots(model1) # Component+residual plots
dev.off()

# Weight recovery diagnostics
pdf("figures/weight_diagnostics.pdf", width = 8, height = 6)
par(mfrow = c(2, 2))
plot(weight_model, which = 1:4) # Beta regression diagnostics
dev.off()

# Tolerability diagnostics
pdf("figures/tol_diagnostics.pdf", width = 8, height = 6)
par(mfrow = c(2, 2))
plot(tol_model)
dev.off()

# Thirst score diagnostics
library(performance)
library(ggplot2)
p = check_model(thirst_model, residual_type = "normal")  # store the plot
ggplot2::ggsave("figures/thirst_diagnostics.pdf", p, width = 8, height = 6)
dev.off()


