#install.packages("mailR")

library(rmarkdown)
render("daily_report.Rmd","html_document", encoding = "utf-8")

library(mailR)
#body正文  
body = "E:/workspace_r/packages_learning/daily_report.html"  
#收件人  
recipients <- "uraboer@qq.com" 
#发件人  
sender = "18810600277@163.com"  
#主题  
title = "Daily Report"  
#填上邮箱密码code，如body是html，设置body=html参数，那么发出来的正文就是html格式的了  
send.mail(  
  from = sender,  
  to = recipients,  
  subject = title,  
  body = "E:/workspace_r/packages_learning/daily_report.html",  
  encoding = "utf-8",  
  html = TRUE,
# attach.files = "test.csv",
  smtp = list(  
    host.name = "smtp.163.com",  
    port = 587,  
    user.name = sender,  
    passwd = "root123456",  #授权码，不是密码
    ssl = TRUE  
  ),  
  authenticate = TRUE,  
  send = TRUE  
) 
