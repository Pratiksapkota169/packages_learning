#learning from:https://mp.weixin.qq.com/s?__biz=MzA3MTM3NTA5Ng==&mid=2651056894&idx=1&sn=e50ee593525b5514343487aceec4fca7&chksm=84d9cb69b3ae427f5a088ceba3e1784377fae27db84d6295a82b191f1e92e518f3d49c07c5e2&mpshare=1&scene=1&srcid=10309ox5pRr5rlZu4JmqKQEP#rd

install.packages("magick")
library(magick)
str(magick::magick_config())

tiger<-image_read("http://jeroen.github.io/images/tiger.svg")
image_info(tiger)

image_write(tiger,path="tiger.png",format="png")

#裁剪与编辑
#magick提供了一些形如AxB+C+D一类的转换函数来实现对图片的裁剪与编辑处理
#image_crop(image,"100x150+50")
#image_scale(image,"x200")
#image_scale(image,"200")
#image_fill(iamge,"blue","+100+200")
#image_border(frink,"red","20x10")

install.packages("rimage")
library(rimage)
celtics<-image_read("E:/workspace_r/packages_learning/celtics.jpg")
print(celtics)


#加个20x10的绿框：
image_border(celtics,"green","20x10")#"x"

#从右边裁掉5个尺寸：
image_crop(celtics,"100x150+5")

#放大：
image_scale(celtics,"300")

#换个边看看：
image_flop(celtics)

#加上个背景色
image_background(celtics,"pink",flatten = TRUE)

#虚化：
image_blur(celtics,10,5)

#添加文本
image_annotate(celtics,"Beat LA!",size = 35,
               gravity = "southwest",color = "green")


#管道操作进行链接
library(magrittr)
image_read("E:/workspace_r/packages_learning/celtics.jpg") %>% 
  image_rotate(270) %>% 
  image_background("pink",flatten=TRUE) %>% 
  image_border("green","10x10") %>% 
  image_annotate("Beat LA!",color="black",size=30)


#图片向量
earth<-image_read("https://jeroen.github.io/images/earth.gif")
print(earth)
earth<-image_scale(earth,"100")
length(earth)


#叠加
bigdata<-image_read("https://jeroen.github.io/images/bigdata.jpg")
print(bigdata)
frink<-image_read("https://jeroen.github.io/images/frink.png")
print(frink)
logo<-image_read("https://www.r-project.org/logo/Rlogo.png")
print(logo)

img<-c(bigdata,logo,frink)
img<-image_scale(img,"300x300")
image_info(img)
print(img)#逐个循环放映

image_mosaic(img)


#组合
left_to_right<-image_append(image_scale(img,"x200"))
print(left_to_right)

image_background(left_to_right,"white",flatten=TRUE)


#扫描文档为图片：将指定PDF文档扫描为png等图片格式的形式
library(pdftools)
bitmap<-pdf_render_page("https://cran.r-project.org/web/packages/magick/magick.pdf",
                        page=1,dpi=72,numeric = FALSE)
image_read(bitmap)


#动图：GIF
image_animate(image_scale(img,"200x200"),fps=1,
              dispose = "previous")


newlogo<-image_scale(image_read("https://www.r-project.org/logo/Rlogo.png"), "x150")
print(newlogo)
oldlogo<-image_scale(image_read("https://developer.r-project.org/Logo/Rlogo-3.png"), "x150")
print(oldlogo)

frames<-image_morph(c(oldlogo,newlogo),frames=10)
image_animate(frames)

