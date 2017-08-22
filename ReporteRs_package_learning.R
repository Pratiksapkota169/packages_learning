#learn from:https://www.rdocumentation.org/packages/ReporteRs/versions/0.8.8
library(ReporteRs)

#Functions in ReporteRs
#1.addFooter:Insert a footer into a document object
addFooter(doc,...)


#2.addDate:Insert a date
#addDate(doc,...)
#"addDate"(doc,value,str.format="%Y-%m-%d",...)

doc<-pptx()
doc<-addSlide(doc,slide.layout="Title and Content")
#add a date on the current slide
doc=addDate(doc)

doc<-addSlide(doc,slide.layout = "Title and Content")
#add a page number on the current slide but not
#the default text(slide number)
doc=addDate(doc,"Dummy date")


#3.addFooter.pptx:Insert a footer shape into a document pptx object
#"addFooter"(doc,value,...)
doc=pptx()
doc=addSlide(doc,slide.layout = "Title and Content")
doc=addFooter(doc,"Hi!")
writeDoc(doc,file = "ex_footer.pptx")

#4.addFlexTale:Insert a FlexTable into a document object
#addFlexTable(doc,flextable,...)
#"addFlexTable"(doc,flextable,par.properties=parProperties(text.align="left"))
#"addFlexTable"(doc,flextable,offx,offy,width,height,...)
options("ReporteRs-fontsize"=11)
ft_obj<-vanilla.table(mtcars)

#docx example----
doc=docx()
doc=addFlexTable(doc,flextable = ft_obj)
writeDoc(doc,file = "add_ft_ex.docx")

#pptx example----
doc=pptx()
doc=addSlide(doc,slide.layout="Title and Content")
doc=addFlexTable(doc,flextable = ft_obj)
writeDoc(doc,file = "add_ft_ex.pptx")


#5.add.pot:add a paragraph to an existing set of paragraphs of text
#add.pot(x,value)
pot1=pot("My tailor",textProperties(color = "red"))+" is "+
  pot("rich",textProperties(font.weight = "bold"))
my.pars=set_of_paragraphs(pot1)
pot2=pot("Cats",textProperties(color = "red"))+" and "+
  pot("Dogs",textProperties(color = "blue"))
my.pars=add.pot(my.pars,pot2)


#6.addDocument:Add an external document into a document object
#addDocument(doc,filename,...)
#ReporteRs does only copy the document as an external file.Headers and
#footers are also imported and displayed.This function is not to be used
#to merge documents.
doc.filename<-"addDocument_example.docx"
#set default font size to 10
options("ReporteRs-fontsize"=10)

doc2embed<-docx()
img.file<-file.path(Sys.getenv("R_HOME"),
                    "doc","html","logo.jpg")
if(file.exists(img.file) && requireNamespace("jpeg",quietly = TRUE)){
  dims<-attr(jpeg::readJPEG(img.file),"dim")
  
  doc2embed<-addImage(doc2embed,img.file,
                      width=dims[2]/72,height=dims[1]/72)
  writeDoc(doc2embed,file="external_file.docx")
  
  doc<-docx()
  doc<-addDocument(doc,filename="external_file.docx")
  writeDoc(doc,file=doc.filename)
}


#7.addHeaderRow:add header in a FlexTable
#addHeaderRow(x,value,colspan,text.properties,par.properties,cell.properties,first=TRUE)
#simple example----

#set header.columns to FALSE so that default header row is not added in
#the FlexTable object
#We do only want the 4 first columns of the dataset
MyFTable<-FlexTable(data=iris[46:55,],header.columns = FALSE)

#add an header row with 3 cells,the first one spans two columns,
#the second one spans two columns and the last one does not span
#multiple columns
MyFTable<-addHeaderRow(MyFTable,
                       value = c("Sepal","Fetal",""),
                       colspan = c(2,2,1))

#add an header row with modified table columns labels
MyFTable<-addHeaderRow(MyFTable,
                       value = c("Length","Width","Length","Width","Species"))

#how to change default formats----

MyFTable<-FlexTable(data = iris[46:55,],header.columns = FALSE,
                    body.cell.props = cellProperties(border.color = "#7895A2"))
#add an header row with table columns labels
MyFTable<-addHeaderRow(MyFTable,
    text.properties = textProperties(color = "#517281",font.weight = "bold"),
    cell.properties = cellProperties(border.color = "#7895A2"),
    value = c("Sepal Length","Sepal Width",
              "Sepal Length","Sepal Width",
              "Species"))


#8.addFooterRow:add footer in a FlexTable




#9.addColumnBreak:Add a column break into a section
#10.addCodeBlock:Add code block into a document object
#11.addPlot:Add a plot into a document object
#12.addImage:Add an external image into a document object
#13.addRScript:Add R script into a document object
#14.addPageNumber:Insert a page number into a document object
#15.addPageNumber.pptx:Insert a page number shape into a document pptx object
#16.addSection:Add a section into a document object
#17.addSlide:Add a slide into a document object
#18.addTOC:Add a table of contents into a document object
#19.addParagraph.Footnot:Insert a paragraph into a Footnote object
#20.as.FlexTable:R tables as FlexTables
#21.docx:Create Microsoft Word document object representation
#22.FlexCell:Cell object for FlexTable
#23.+.pot:pot concatenation
#24.parProperties:get FlexTable from a sessionInfo object
#25.office_web_viewer:Office Web Viewer
#26.map_title:map titles styles
#27.as.html.FlexTable:get HTML code from a FlexTable
#28.pot_img:Image to be concatenate with pot object
#29.set_of_paragraphs:Set of paragraphs of text
#30.pot:Piece of Text(formated text)
#31.addParagraph:Add a paragraph into a document object
#32.addTitle:Add a title
#33.addSubtitile:Add a subtitle shape into a document object
#34.chprop.FlexTable:format FlexTable
#35.chprop:Change a formatting propertiex object
#36.knit_printFlexTable:FlexTable custom printing function for knitr
#37.light.table:light FlexTable shortcut
#38.deleteBookmark:delete a bookmark into a docx object
#39.deleteBookmarkNextContent:delete first content after a bookmark into a docx object
#40.[<-.FlexTable:alter FlexTable content and format
#41.FlexTable:FlexTable creation
#42.setZebraStyle:FlexTable rows zebra striping
#43.textNormal:shortcuts for formatting properties
#44.spanFlexTableColumns:Span columns within rows
#45.print.Footnote:print a Footnote
#46.renderFlexTable:FlexTable output for shiny
#47.slide.layouts:Get layout names of a document object
#48.borderProperties:border properties object
#49.spanFlexTableRows:Span rows within columns
#50.[<-.FlexRow:modify FlexRow content
#51.cellProperties:Cell fromatting properties
#52.list_bookmarks:List Bookmarks from a Word Document
#53.list.settings:format ordered and unordered lists
#54.FlexRow:Row object for FlexTable
#55.CodeBlock:Code Block Object
#56.as.html.pot:get HTML code from a pot
#57.as.html:get HTML code
#58.colorProperties:color properties object
#59.Footnote:Create a Footnote
#60.is.color:color checking
#61.pptx:Create Microsoft PowerPoint document object representation
#62.print.FlexTable:Print FlexTables
#63.toc.options:set TOC options
#64.setFlexTableBorders:change grid lines of a FlexTable
#65.textProperties:Text formatting properties
#66.setFlexTableBackgroundColors:applies background colors to cells of a FlexTable
#67.ReporteRs-package:ReporteRs a package to create document from R
#68.RScript:RScript object
#69.setFlexTableWidths:set columns widths of a FlexTable
#70.setRowsColors:applies background colors to rows of a FlexTable
#71.styles:Get styles names of a  document object
#72.text_extract:Simple Text Extraction From a Word Doucment
#73.vanilla.table:vanilla FlexTable shortcut
#74.writeDoc:Write a document object
#75.setColumnsColors:applies background colors to columns of a FlexTable


































