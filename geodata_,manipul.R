#----------------------------------------------------------------------------
#Script Name：geodata_,manipul.R
#Purpose:This scribes How to perform spatial data analysis using R, which includes tasks like creating buffers, clipping, extracting raster values, merging datasets, and handling spatial data.
#Author:Honghong Wang
#Email:873751229@qq.com
#Date:2024-4-29
#-----------------------------------------------------------------------------
#加载所需包
library(terra)


# 下载并加载所需包
install.packages("terra")
install.packages("sf")
library(terra)
library(sf)

# 载入所需数据
doubs_dem <- terra::rast("D://王红红学习文件//研究生课程//数据驱动的生态学研究方法//课堂练习//map.tif")
doubs_river <- sf::st_read("D://王红红学习文件//研究生课程//数据驱动的生态学研究方法//课堂练习//river.shp")
doubs_points <- sf::st_read("D://王红红学习文件//研究生课程//数据驱动的生态学研究方法//课堂练习//dian.shp")

# 转换投影坐标系
doubs_river_utm <- st_transform(doubs_river,32631)

# 建立缓冲区
doubs_river_buffer <- st_buffer(doubs_river_utm,dist = 8000)
plot(st_geometry(doubs_river_buffer),axes = TRUE)

library(ggplot2)
ggplot() + geom_sf(data = doubs_river_buffer) # 自行转换为地理坐标系

# 裁剪所需高程数据
terra::crs(doubs_dem) # 得到地理坐标系CRS

# 设置地理坐标系CRS
utm_crs <- "EPSG:32631"

# 转换
doubs_dem_utm <- terra::project(doubs_dem,utm_crs)
terra::crs(doubs_dem_utm)

# 进行裁剪
doubs_dem_utm_cropped = crop(doubs_dem_utm,doubs_river_buffer)
doubs_dem_utm_masked = mask(doubs_dem_utm_cropped,doubs_river_buffer)
# 可视化
plot(doubs_dem_utm_masked,axes =TRUE)

# 提取集水区面积
install.packages("qgisprocess")


# 设置 QGIS 进程路径的环境变量
Sys.setenv(R_QGIS_PROCESS_PATH = "D://Qgis//apps//qgis-ltr//bin//qgis_process.exe")

# 检查环境变量是否设置成功
Sys.getenv("R_QGIS_PROCESS_PATH")

# 加载 qgisprocess 包
library(qgisprocess)
algorithms <- qgis_algorithms()
wetness_algorithm <- algorithms[grep("wetness", algorithms$name, ignore.case = TRUE), ]
result <- qgis_algorithm_run(
  algorithm = wetness_algorithm$id,
  parameters = list(
    INPUT_DEM = "D://王红红学习文件//研究生课程//数据驱动的生态学研究方法//课堂练习//map.tif"
  )
)

# 搜索包含 "wetness" 关键词的算法，并转换结果为数据框类型，然后显示前两个结果
result <- qgis_search_algorithms("wetness")
result_df <- data.frame(result)
head(result_df, 2)
str(result)

topo_total = qgisprocess::qgis_run_algorithm(
  alg = "sagang:sagwetnessindex",
  DEM = doubs_dem_utm_masked,
  SLOPE_TYPE = 1,
  SLOPE = tempfile(fileext = ".sdat"),
  AREA = tempfile(fileext = ".sdat"),
  .quiet = TRUE)

topo_select <- topo_total[c("AREA","SLOPE")] |>
  unlist() |>
  rast()

names(topo_select) = c("carea","cslope")
origin(topo_select) = origin(doubs_dem_utm_masked)
topo_char = c(doubs_dem_utm_masked,topo_select)


# 将点数据转换为特定坐标系
doubs_points_utm <- sf::st_transform(doubs_points ,32631)
dim(doubs_points_utm)


# 增加环境数据
topo_env <- terra::extract(topo_char,doubs_points_utm,ID = FALSE)

# 载入数据
Doubs
water_env <- env

# 增加数据列
doubs_env = cbind(doubs_points_utm,topo_env,water_env)
