#系统要安装java,配置好路径
#安装xlsx之前需要有两前提包，一个是rJava，一个是xlsxjars.
#C:\Users\Administrator\AppData\Local\Temp\RtmpMp8MwV\downloaded_packages
#如果之前不是安装2中那样的顺序安装，虽然rJava或者xlsxjars包都下载了，但是就是安装不上xlsx，这时候可以选择到R安装目录下的library中找到rJava或者xlsxjars删除掉，重新在R控制台进行安装。
#重启

# install.packages("rJava")
# install.packages("xlsxjars") 
# install.packages("xlsx")

library(xlsx)

write.xlsx(as.data.frame(table_dict),"F:/workspace_r/table_dict.xlsx",sheetName = "Sheet1",
           row.names = FALSE,col.names = FALSE,append = TRUE)

