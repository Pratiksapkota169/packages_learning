#install.packages("mailR")
library(mailR)
#body正文  
body = "this is a test"  
#收件人  
recipients <- "uraboer@qq.com" 
#发件人  
sender = "18810600277@163.com"  
#主题  
title = "this is title"  
#填上邮箱密码code，如body是html，设置body=html参数，那么发出来的正文就是html格式的了  
send.mail(  
  from = sender,  
  to = recipients,  
  subject = title,  
  body = "My Program is finished",  
  encoding = "utf-8",  
  html = TRUE,
  attach.files = "test.csv",
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
