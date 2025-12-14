#let normal(tsize:20pt,doc) = [
  
  //普通文本
  #set text(size:tsize )
  //段落缩进
  #set par(first-line-indent: (amount: 2em, all: true))
  //标题居中
  #show heading: set align(center) 
  #doc
]
