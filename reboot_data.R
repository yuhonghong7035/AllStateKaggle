library(RSQLite)

# data shopping point 2 
sqlitedb.filename <- file.path("db", "allstate_data.sqlite3")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, dbname=sqlitedb.filename)

# data state
data.state <- dbGetQuery(
  con,
  "
  select
  customer_ID,
  state
  from
  customers
  "
)

# last shopping pt data
data.last.shopping.pt <- dbGetQuery(
  con,
"
select
T1.customer_ID,
T2.last_shopping_pt,
T1.A as last_A,
T1.B as last_B,
T1.C as last_C,
T1.D as last_D,
T1.E as last_E,
T1.F as last_F,
T1.G as last_G,
T1.cost as last_cost
from
transactions T1 inner join
(
  select
  customer_ID,
  max(shopping_pt) as last_shopping_pt
  from
  transactions
  where
  record_type = 0
  group by customer_ID
) T2 on (T1.customer_ID = T2.customer_ID and T1.shopping_pt = T2.last_shopping_pt)
")

data.min.cost.shopping.pt <- dbGetQuery(
  con,
  "
  select
  T1.customer_ID,
  T2.min_cost_shopping_pt,
  T1.A as min_cost_A,
  T1.B as min_cost_B,
  T1.C as min_cost_C,
  T1.D as min_cost_D,
  T1.E as min_cost_E,
  T1.F as min_cost_F,
  T1.G as min_cost_G,
  T1.cost as min_cost_cost
  from
  transactions T1 inner join
  (
  select
  T1.customer_ID,
  max(T1.shopping_pt) as min_cost_shopping_pt
  from
  transactions T1 inner join
  (
    select
    customer_ID,
    min(cost) as min_cost
    from transactions
    where
    record_type = 0
    group by customer_ID
  ) T2 on (T1.customer_ID = T2.customer_ID and T1.cost = T2.min_cost)
  where
  record_type = 0
  group by T1.customer_ID
  ) T2 on (T1.customer_ID = T2.customer_ID and T1.shopping_pt = min_cost_shopping_pt)
  ")


data.info.user <- dbGetQuery(
  con,
  "
  select
  T1.customer_ID,
  T1.location,
  T1.day,
  T1.group_size,
  T1.homeowner,
  T1.car_age,
  T1.car_value,
  T1.risk_factor,
  T1.age_oldest,
  T1.age_youngest,
  T1.married_couple,
  T1.C_previous,
  T1.duration_previous
  from
  transactions T1 inner join
  (
  select
  T1.customer_ID,
  max(T1.shopping_pt) as min_cost_shopping_pt
  from
  transactions T1 inner join
  (
  select
  customer_ID,
  min(cost) as min_cost
  from transactions
  where
  record_type = 0
  group by customer_ID
  ) T2 on (T1.customer_ID = T2.customer_ID and T1.cost = T2.min_cost)
  where
  record_type = 0
  group by T1.customer_ID
  ) T2 on (T1.customer_ID = T2.customer_ID and T1.shopping_pt = min_cost_shopping_pt)
  ")


data.real <- dbGetQuery(
  con,
  "
  select
  T1.customer_ID,
  T1.shopping_pt as real_shopping_pt,
  T1.A as real_A,
  T1.B as real_B,
  T1.C as real_C,
  T1.D as real_D,
  T1.E as real_E,
  T1.F as real_F,
  T1.G as real_G,
  T1.cost as real_cost
  from
  transactions T1
  where
  record_type = 1
  ")

data.location.shopped <- dbGetQuery(
  con,
  "
select
T1.location,
T1.nb_shopped_A_0/(T1.nb_shopped_A_0+T1.nb_shopped_A_1+T1.nb_shopped_A_2) as prc_location_shopped_A_0,
T1.nb_shopped_A_1/(T1.nb_shopped_A_0+T1.nb_shopped_A_1+T1.nb_shopped_A_2) as prc_location_shopped_A_1,
T1.nb_shopped_A_2/(T1.nb_shopped_A_0+T1.nb_shopped_A_1+T1.nb_shopped_A_2) as prc_location_shopped_A_2,
T1.nb_shopped_B_0/(T1.nb_shopped_B_0+T1.nb_shopped_B_1) as prc_location_shopped_B_0,
T1.nb_shopped_B_1/(T1.nb_shopped_B_0+T1.nb_shopped_B_1) as prc_location_shopped_B_1,
T1.nb_shopped_C_1/(T1.nb_shopped_C_1+T1.nb_shopped_C_2+nb_shopped_C_3+nb_shopped_C_4) as prc_location_shopped_C_1,
T1.nb_shopped_C_2/(T1.nb_shopped_C_1+T1.nb_shopped_C_2+nb_shopped_C_3+nb_shopped_C_4) as prc_location_shopped_C_2,
T1.nb_shopped_C_3/(T1.nb_shopped_C_1+T1.nb_shopped_C_2+nb_shopped_C_3+nb_shopped_C_4) as prc_location_shopped_C_3,
T1.nb_shopped_C_4/(T1.nb_shopped_C_1+T1.nb_shopped_C_2+nb_shopped_C_3+nb_shopped_C_4) as prc_location_shopped_C_4,
T1.nb_shopped_D_1/(T1.nb_shopped_D_1+T1.nb_shopped_D_2+nb_shopped_D_3) as prc_location_shopped_D_1,
T1.nb_shopped_D_2/(T1.nb_shopped_D_1+T1.nb_shopped_D_2+nb_shopped_D_3) as prc_location_shopped_D_2,
T1.nb_shopped_D_3/(T1.nb_shopped_D_1+T1.nb_shopped_D_2+nb_shopped_D_3) as prc_location_shopped_D_3,
T1.nb_shopped_E_0/(T1.nb_shopped_E_0+T1.nb_shopped_E_1) as prc_location_shopped_E_0,
T1.nb_shopped_E_1/(T1.nb_shopped_E_0+T1.nb_shopped_E_1) as prc_location_shopped_E_1,
T1.nb_shopped_F_0/(T1.nb_shopped_F_0+T1.nb_shopped_F_1+T1.nb_shopped_F_2+T1.nb_shopped_F_3) as prc_location_shopped_F_0,
T1.nb_shopped_F_1/(T1.nb_shopped_F_0+T1.nb_shopped_F_1+T1.nb_shopped_F_2+T1.nb_shopped_F_3) as prc_location_shopped_F_1,
T1.nb_shopped_F_2/(T1.nb_shopped_F_0+T1.nb_shopped_F_1+T1.nb_shopped_F_2+T1.nb_shopped_F_3) as prc_location_shopped_F_2,
T1.nb_shopped_F_3/(T1.nb_shopped_F_0+T1.nb_shopped_F_1+T1.nb_shopped_F_2+T1.nb_shopped_F_3) as prc_location_shopped_F_3,
T1.nb_shopped_G_1/(T1.nb_shopped_G_1+T1.nb_shopped_G_2+T1.nb_shopped_G_3+T1.nb_shopped_G_4) as prc_location_shopped_G_1,
T1.nb_shopped_G_2/(T1.nb_shopped_G_1+T1.nb_shopped_G_2+T1.nb_shopped_G_3+T1.nb_shopped_G_4) as prc_location_shopped_G_2,
T1.nb_shopped_G_3/(T1.nb_shopped_G_1+T1.nb_shopped_G_2+T1.nb_shopped_G_3+T1.nb_shopped_G_4) as prc_location_shopped_G_3,
T1.nb_shopped_G_4/(T1.nb_shopped_G_1+T1.nb_shopped_G_2+T1.nb_shopped_G_3+T1.nb_shopped_G_4) as prc_location_shopped_G_4,
T1.nb_shopped_A_0/T2.nb_total_A_0 as prc_all_shopped_A_0,
T1.nb_shopped_A_1/T2.nb_total_A_0 as prc_all_shopped_A_1,
T1.nb_shopped_A_2/T2.nb_total_A_0 as prc_all_shopped_A_2,
T1.nb_shopped_B_0/T2.nb_total_B_0 as prc_all_shopped_B_0,
T1.nb_shopped_B_1/T2.nb_total_B_1 as prc_all_shopped_B_1,
T1.nb_shopped_C_1/T2.nb_total_C_1 as prc_all_shopped_C_1,
T1.nb_shopped_C_2/T2.nb_total_C_2 as prc_all_shopped_C_2,
T1.nb_shopped_C_3/T2.nb_total_C_3 as prc_all_shopped_C_3,
T1.nb_shopped_C_4/T2.nb_total_C_4 as prc_all_shopped_C_4,
T1.nb_shopped_D_1/T2.nb_total_D_1 as prc_all_shopped_D_1,
T1.nb_shopped_D_2/T2.nb_total_D_2 as prc_all_shopped_D_2,
T1.nb_shopped_D_3/T2.nb_total_D_3 as prc_all_shopped_D_3,
T1.nb_shopped_E_0/T2.nb_total_E_0 as prc_all_shopped_E_0,
T1.nb_shopped_E_1/T2.nb_total_E_1 as prc_all_shopped_E_1,
T1.nb_shopped_F_0/T2.nb_total_F_0 as prc_all_shopped_F_0,
T1.nb_shopped_F_1/T2.nb_total_F_1 as prc_all_shopped_F_1,
T1.nb_shopped_F_2/T2.nb_total_F_2 as prc_all_shopped_F_2,
T1.nb_shopped_F_3/T2.nb_total_F_3 as prc_all_shopped_F_3,
T1.nb_shopped_G_1/T2.nb_total_G_1 as prc_all_shopped_G_1,
T1.nb_shopped_G_2/T2.nb_total_G_2 as prc_all_shopped_G_2,
T1.nb_shopped_G_3/T2.nb_total_G_3 as prc_all_shopped_G_3,
T1.nb_shopped_G_4/T2.nb_total_G_4 as prc_all_shopped_G_4  
from
(
  select
  location,
  sum(case when A = 0 then 1 else 0 end)*1.0 as nb_shopped_A_0,
  sum(case when A = 1 then 1 else 0 end)*1.0 as nb_shopped_A_1,
  sum(case when A = 2 then 1 else 0 end)*1.0 as nb_shopped_A_2,
  sum(case when B = 0 then 1 else 0 end)*1.0 as nb_shopped_B_0,
  sum(case when B = 1 then 1 else 0 end)*1.0 as nb_shopped_B_1,
  sum(case when C = 1 then 1 else 0 end)*1.0 as nb_shopped_C_1,
  sum(case when C = 2 then 1 else 0 end)*1.0 as nb_shopped_C_2,
  sum(case when C = 3 then 1 else 0 end)*1.0 as nb_shopped_C_3,
  sum(case when C = 4 then 1 else 0 end)*1.0 as nb_shopped_C_4,
  sum(case when D = 1 then 1 else 0 end)*1.0 as nb_shopped_D_1,
  sum(case when D = 2 then 1 else 0 end)*1.0 as nb_shopped_D_2,
  sum(case when D = 3 then 1 else 0 end)*1.0 as nb_shopped_D_3,
  sum(case when E = 0 then 1 else 0 end)*1.0 as nb_shopped_E_0,
  sum(case when E = 1 then 1 else 0 end)*1.0 as nb_shopped_E_1,
  sum(case when F = 0 then 1 else 0 end)*1.0 as nb_shopped_F_0,
  sum(case when F = 1 then 1 else 0 end)*1.0 as nb_shopped_F_1,
  sum(case when F = 2 then 1 else 0 end)*1.0 as nb_shopped_F_2,
  sum(case when F = 3 then 1 else 0 end)*1.0 as nb_shopped_F_3,
  sum(case when G = 1 then 1 else 0 end)*1.0 as nb_shopped_G_1,
  sum(case when G = 2 then 1 else 0 end)*1.0 as nb_shopped_G_2,
  sum(case when G = 3 then 1 else 0 end)*1.0 as nb_shopped_G_3,
  sum(case when G = 4 then 1 else 0 end)*1.0 as nb_shopped_G_4
  from
  transactions
  where
  record_type = 1
  group by location
) T1,
(
  select
  sum(case when A = 0 then 1 else 0 end)*1.0 as nb_total_A_0,
  sum(case when A = 1 then 1 else 0 end)*1.0 as nb_total_A_1,
  sum(case when A = 2 then 1 else 0 end)*1.0 as nb_total_A_2,
  sum(case when B = 0 then 1 else 0 end)*1.0 as nb_total_B_0,
  sum(case when B = 1 then 1 else 0 end)*1.0 as nb_total_B_1,
  sum(case when C = 1 then 1 else 0 end)*1.0 as nb_total_C_1,
  sum(case when C = 2 then 1 else 0 end)*1.0 as nb_total_C_2,
  sum(case when C = 3 then 1 else 0 end)*1.0 as nb_total_C_3,
  sum(case when C = 4 then 1 else 0 end)*1.0 as nb_total_C_4,
  sum(case when D = 1 then 1 else 0 end)*1.0 as nb_total_D_1,
  sum(case when D = 2 then 1 else 0 end)*1.0 as nb_total_D_2,
  sum(case when D = 3 then 1 else 0 end)*1.0 as nb_total_D_3,
  sum(case when E = 0 then 1 else 0 end)*1.0 as nb_total_E_0,
  sum(case when E = 1 then 1 else 0 end)*1.0 as nb_total_E_1,
  sum(case when F = 0 then 1 else 0 end)*1.0 as nb_total_F_0,
  sum(case when F = 1 then 1 else 0 end)*1.0 as nb_total_F_1,
  sum(case when F = 2 then 1 else 0 end)*1.0 as nb_total_F_2,
  sum(case when F = 3 then 1 else 0 end)*1.0 as nb_total_F_3,
  sum(case when G = 1 then 1 else 0 end)*1.0 as nb_total_G_1,
  sum(case when G = 2 then 1 else 0 end)*1.0 as nb_total_G_2,
  sum(case when G = 3 then 1 else 0 end)*1.0 as nb_total_G_3,
  sum(case when G = 4 then 1 else 0 end)*1.0 as nb_total_G_4
  from
  transactions
  where
  record_type = 1
) T2
  "
)

data.location.shopped.mean <- colMeans(data.location.shopped)
data.location.shopped.mean <- data.frame(t(data.location.shopped.mean))
data.location.shopped.mean <- data.location.shopped.mean[,colnames(data.location.shopped.mean) != "location"]


# make big data
null.location.data <- subset(data.info.user, is.na(location))
not.null.location.data <- subset(data.info.user, ! is.na(location))

tmp.null <- cbind(null.location.data, data.location.shopped.mean)
tmp.not.null <- merge(data.info.user, data.location.shopped, by=c("location"))

tmp.null <- tmp.null[, sort(colnames(tmp.null))]
tmp.not.null <- tmp.not.null[, sort(colnames(tmp.not.null))]

tmp <- rbind(tmp.null, tmp.not.null)

tmp <- merge(tmp, data.state, on=c("customer_ID"))
tmp <- merge(tmp, data.last.shopping.pt, on=c("customer_ID"))
tmp <- merge(tmp, data.min.cost.shopping.pt, on=c("customer_ID"))
tmp <- merge(tmp, data.real, on=c("customer_ID"))

data.train <- tmp

normalize.train <- function(data) {
  
  rownames(data) <- data$customer_ID
  data <- data[, colnames(data) != "customer_ID"]
  
  data$state <- factor(data$state)
  
  data <- data[, colnames(data) != "day"]
  data <- data[, colnames(data) != "time"]
  
  data$homeowner <- factor(ifelse(data$homeowner == 1, "Yes", "No"))
  
  data$car_value <- factor(data$car_value)
  
  data$risk_factor <- factor(ifelse(is.na(data$risk_factor), "NotAvailable", data$risk_factor))
  
  data$married_couple <- factor(ifelse(data$married_couple == 1, "Yes", "No"))
  
  data$C_previous <- factor(ifelse(is.na(data$C_previous), "NotAvailable", data$C_previous))
  
  data$duration_previous <- ifelse(is.na(data$duration_previous), 5, data$duration_previous)  
  
  for(letter in c("A","B","C","D","E","F","G")) {
    data[, paste("value", letter, "last", sep="_")] <- factor(data[, paste("value", letter, "last", sep="_")])
    data[, paste("first", letter, sep="_")] <- factor(data[, paste("first", letter, sep="_")])
    data[, paste("real", letter, sep="_")] <- factor(data[, paste("real", letter, sep="_")])
  }
  
  return(data)
  
}
