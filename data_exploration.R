#----------------------------------------------------------------------------
#Script Name：data_exploration.R
#Purpose:This scribes how to clean data,handle missing values,detect multicollinearity, analyze relationships between variables using statistical methods, and visualize data to gain insights into ecological interactions.
#Author:Honghong Wang
#Email:873751229@qq.com
#Date:2024-4-16
#------------------------------------------------------------------------------
#问题一：删除缺失数据的点并检测环境因素的共线性,分以下几步：
# 1.加载"ade4"包
library(ade4)
# 2.导入并查看doubs数据集
data("doubs")
doubs

# 3.移除有缺失数据的站点
doubs_clean <- na.omit(doubs)

# 4.计算环境因素之间的相关性
env_cor <- cor(doubs$env[, c("dfs", "alt", "slo", "flo", "pH", "har", "pho", "nit", "amm", "oxy", "bdo")])

# 5.绘制相关性矩阵的热图
install.packages("corrplot")
library(corrplot)
corrplot(env_cor, method="color")

# 6.检测环境因素之间的共线性
# 6.1安装并加载car包，它包含了计算VIF所需的函数
install.packages("car")
library(car)
# 6.2提取环境因素的数据
env_data <- doubs_clean$env[, c("dfs", "alt", "slo", "flo", "pH", "har", "pho", "nit", "amm", "oxy", "bdo")]
# 6.3#将环境因素数据转换为数据框
env_data <- as.data.frame(env_data)
# 6.4计算线性模型
lm_model <- lm(env_data)
# 6.5计算VIF
vif_values <- car::vif(lm_model)
# 6.6 输出VIF值，VIF值大于10可能表示存在共线性问题
print(vif_values)
# 6.7共线性结果解读：alt、pho、nit和amm与其他自变量之间存在较高的共线性，需要在建模过程中通过变量选择或正则化方法处理这些共线性。


#问题二：分析鱼类与环境因素之间的关系并可视化,分以下几步：
# 1.安装和加载所需要的包
library(ggplot2)

# 2.通过散点图看鱼类数量与环境因素的关系
# 2.1 鱼类数据
fish_data <- doubs$fish

# 2.2 设置环境因素变量名列表
env_data <- c("dfs", "alt", "slo", "flo", "pH", "har", "pho", "nit", "amm", "oxy", "bdo")

# 2.3 设置鱼类数量变量名列表
fish_names <- c("Cogo", "Satr", "Phph", "Neba", "Thth", "Teso", "Chna", "Chto", "Lele", "Lece", "Baba", "Spbi", "Gogo", "Eslu", "Pefl", "Rham", "Legi", "Scer", "Cyca", "Titi", "Abbr", "Icme", "Acce", "Ruru", "Blbj", "Alal", "Anan")

# 创建包含环境因素和鱼类数量的数据框
data_df <- cbind(doubs$env, doubs$fish)

# 循环绘制散点图
for (factor in env_data) {
  for (fish in fish_names) {
    plot_title <- paste("Scatter plot of", fish, "vs", factor)
    p <- ggplot(data_df, aes_string(x = factor, y = fish)) +
      geom_point() +
      labs(x = factor, y = fish, title = plot_title)
    print(p)
  }
}

#3.计算鱼类与环境因素之间的相关性
#3.1计算鱼类数量与环境因素之间的相关性
ish_data <- doubs$fish
env_data <- doubs$env
fish_env_cor <- cor(fish_data, env_data)
#3.2输出相关性矩阵
print(fish_env_cor)
#3.3#可视化相关性矩阵
library(corrplot)
corrplot(fish_env_cor, method = "color")
#3.4结果解读：相关系数的数值范围在 -1 到 1 之间，越接近 1 表示两者正相关性越强，越接近 -1 表示两者负相关性越强，而接近 0 表示两者之间没有线性相关性。

#4.主成分分析
#4.1 加载所需包
install.packages("FactoMineR")
install.packages("factoextra")
library(FactoMineR)
library(factoextra)
#4.2提取环境因素数据
env_data <- doubs$env[, c("dfs", "alt", "slo", "flo", "pH", "har", "pho", "nit", "amm", "oxy", "bdo")]
#4.3进行主成分分析
pca_result <- PCA(env_data, graph = FALSE)
#4.4提取主成分分析结果
pca_var <- get_pca_var(pca_result)
pca_ind <- get_pca_ind(pca_result)
#4.5绘制主成分分析的解释方差比例图
fviz_eig(pca_result, addlabels = TRUE)
#4.6绘制主成分分析的因子负荷量图
fviz_pca_var(pca_result, col.var = "contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))
#4.7绘制主成分分析的个体得分图
fviz_pca_ind(pca_result, geom = "point", habillage = doubs$fish)

#-----------------------------------------------------------------------------             
             