#----------------------------------------------------------------------------
#Script Name：data_manipul.R
#Purpose:This scribes how to Use a data frame to process the data
#Author:Honghong Wang
#Email:873751229@qq.com
#Date:2024-3-22
#----------------------------------------------------------------------------
# 导入需要的包
library(tidyverse)
library(ggplot2)

# 1. 导入和保存数据
# 导入数据
data <- read.csv("D:\\growth_rates.csv")
# 保存数据为 CSV 文件到指定路径中
write.csv(data, file = "D:/R example/R example.csv", row.names = FALSE)

# 2. 检查数据结构
str(data)

# 3. 检查是否有缺失数据，检查“Growth_Rate”列是否有缺失数据
any(is.na(data$Growth_Rate)) 

# 4. 提取列值或选择/添加列
# 提取 Growth_Rate 列的值
name_values <- data$Growth_Rate
# 查看提取出的Growth_Rate 列的值
print(name_values)
# 添加新列
data$trend <- ifelse(data$Growth_Rate >= 0, "Increase", "Reduce")
# 查看添加的新列"trend"
print(data)

# 5. 将宽表格转换为长格式
data_new <- pivot_longer(data, cols = c(Growth_Rate, Growth_Rate.1,Growth_Rate.2,Growth_Rate.3), names_to = "variable", values_to = "value")
# 查看新表
print(data_new)
# 保存新表
write.csv(data_new, "D:/R example/data_new.csv", row.names = FALSE)

# 6.添加列"year"
# 创建包含年份的序列
years <- 2001:2020
# 将数据框和年份序列合并
data_new$year <- years
# 查看包含新列的数据框
print(data_new)

# 7. 可视化数据
#画条形图
ggplot(data_new, aes(x = year, y = value, fill = variable)) +
  geom_bar(stat = "identity") +
  labs(title = "Data Visualization", x = "Variable", y = "Value") +
  theme_minimal()
# 修改条形图的颜色和大小
ggplot(data_new, aes(x = year, y = value, fill = variable)) +
  geom_bar(stat = "identity", color = "black", size = 0.5) + 
  labs(title = "Data Visualization", x = "Variable", y = "Value") +
  theme_minimal()

#-------------------------------------------------------------------------
