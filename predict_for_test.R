source("reboot_data.R")

load(file.path("last_model", "model_glm_A_restricted.RData"))

error.pred <- function(real, predict) {
  nb.ko <- sum(real != predict)
  nb.all <- length(real)
  
  return(nb.ko/nb.all)
}

# A
load(file.path("last_model", "model_glm_A_restricted.RData"))

data.test.normalized$predicted_A_0 <- predict(model.A.0.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_A_1 <- predict(model.A.1.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_A_2 <- predict(model.A.2.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_A <- max.col(data.test.normalized[,c("predicted_A_0","predicted_A_1","predicted_A_2")])-1

# cat("Error A : ", with(data.test.normalized, error.pred(real_A, predicted_A)), "\n")

# B
load(file.path("last_model", "model_glm_B_restricted.RData"))

data.test.normalized$predicted_B_0 <- predict(model.B.0.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_B_1 <- predict(model.B.1.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_B <- max.col(data.test.normalized[,c("predicted_B_0","predicted_B_1")])-1

# cat("Error B : ", with(data.test.normalized, error.pred(real_B, predicted_B)), "\n")

# C
load(file.path("last_model", "model_glm_C_restricted.RData"))

data.test.normalized$predicted_C_1 <- predict(model.C.1.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_C_2 <- predict(model.C.2.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_C_3 <- predict(model.C.3.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_C_4 <- predict(model.C.4.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_C <- max.col(data.test.normalized[,c("predicted_C_1","predicted_C_2","predicted_C_3","predicted_C_4")])

# cat("Error C : ", with(data.test.normalized, error.pred(real_C, predicted_C)), "\n")

# D
load(file.path("last_model", "model_glm_D_restricted.RData"))

data.test.normalized$predicted_D_1 <- predict(model.D.1.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_D_2 <- predict(model.D.2.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_D_3 <- predict(model.D.3.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_D <- max.col(data.test.normalized[,c("predicted_D_1","predicted_D_2","predicted_D_3")])

# cat("Error D : ", with(data.test.normalized, error.pred(real_D, predicted_D)), "\n")

# E
load(file.path("last_model", "model_glm_E_restricted.RData"))

data.test.normalized$predicted_E_0 <- predict(model.E.0.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_E_1 <- predict(model.E.1.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_E <- max.col(data.test.normalized[,c("predicted_E_0","predicted_E_1")]) - 1

# cat("Error E : ", with(data.test.normalized, error.pred(real_E, predicted_E)), "\n")

# F
load(file.path("last_model", "model_glm_F_restricted.RData"))

data.test.normalized$predicted_F_0 <- predict(model.F.0.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_F_1 <- predict(model.F.1.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_F_2 <- predict(model.F.2.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_F_3 <- predict(model.F.3.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_F <- max.col(data.test.normalized[,c("predicted_F_0","predicted_F_1","predicted_F_2","predicted_F_3")]) - 1

# cat("Error F : ", with(data.test.normalized, error.pred(real_F, predicted_F)), "\n")

# G
load(file.path("last_model", "model_glm_G_restricted.RData"))

data.test.normalized$predicted_G_1 <- predict(model.G.1.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_G_2 <- predict(model.G.2.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_G_3 <- predict(model.G.3.restricted, newdata=data.test.normalized, type="response")
data.test.normalized$predicted_G_4 <- predict(model.G.4.restricted, newdata=data.test.normalized, type="response")

data.test.normalized$predicted_G <- max.col(data.test.normalized[,c("predicted_G_1","predicted_G_2","predicted_G_3","predicted_G_4")])

# cat("Error G : ", with(data.test.normalized, error.pred(real_G, predicted_G)), "\n")

# ABCDEFG
# data.test.normalized$real_ABCDEFG <- with(
#   data.test.normalized,
#   paste(
#     as.character(real_A),
#     as.character(real_B),
#     as.character(real_C),
#     as.character(real_D),
#     as.character(real_E),
#     as.character(real_F),
#     as.character(real_G),
#     sep=""
#   )
# )
    
data.test.normalized$predicted_ABCDEFG <- with(
  data.test.normalized,
  paste(
    as.character(predicted_A),
    as.character(predicted_B),
    as.character(predicted_C),
    as.character(predicted_D),
    as.character(predicted_E),
    as.character(predicted_F),
    as.character(predicted_G),
    sep=""
  )
)

df <- data.frame(
  customer_ID=rownames(data.test.normalized),
  plan=data.test.normalized$predicted_ABCDEFG
)

write.table(df, file="last_model_submission_glm_no_prob.csv", row.names=FALSE, sep=",", quote=FALSE)
