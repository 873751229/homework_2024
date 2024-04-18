#----------------------------------------------------------------------------
#Script Name：r_database.R
#Purpose:This scribes how to how to upload the data of Doubs, a built-in dataset of ade4 package into a schema of PostgreSQL or the SQLite.
#Author:Honghong Wang
#Email:873751229@qq.com
#Date:2024-4-18
#---------------------------------------------------------------------------------------
#加载包
library(reticulate)#加载R包reticulate用于在R中调用Python代码

library(rdataretriever)#加载R包rdataretriever用于检索和管理数据集，这个包依赖于Python环境。

library(DBI)#在R中操作数据库

library(RSQLite)#在R中操作数据库

# 设置 Python 虚拟环境
virtualenv_create("myenv")#创建名为"myenv"的Python虚拟环境。
use_virtualenv("myenv")#在R中启用该虚拟环境，后续的Python代码在该虚拟环境中执行。

# 安装 rdataretriever 包
py_install("rdataretriever")#在当前的Python虚拟环境中安装rdataretriever包

# 加载 Python 模块
py <- import("rdataretriever")#将Python模块"rdataretriever"导入到R中，并将其赋值给变量py，以便后续在R中调用该模块的函数和方法。

# 将 Doubs 数据集下载到 R 中
py$fetch("Doubs")#调用Python模块中的fetch函数，从"Doubs"数据集下载数据，并将其加载到 R 中。

# 连接到 SQLite 数据库
con <- dbConnect(RSQLite::SQLite(), dbname = "my_database.sqlite")#使用RSQLite包中的dbConnect函数连接到SQLite数据库，并指定数据库文件的名称为"my_database.sqlite"，并将连接对象赋值给变量con

# 将 Doubs 数据集上传到数据库的模式中
dbWriteTable(con, "doubs", Doubs, overwrite = TRUE)#使用dbWriteTable函数将R中的数据集Doubs写入到已连接的SQLite数据库中的名为"doubs"的表格中。参数overwrite = TRUE表示如果表格已存在，则覆盖原有的表格。

# 关闭数据库连接
dbDisconnect(con)

#------------------------------------------------------------------------------