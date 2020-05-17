<<<<<<< HEAD
setwd("D:/GitHub/Rcode1")#why????
library(magrittr) # need to run every time you start R and want to use %>%
library(dplyr)    # alternative, this also loads %>%
map = read.table('map.txt', row.names = 1, header = T)
taxa = read.table('taxa_L2.txt', row.names = 1, header = T,sep = '\t')
taxa = t(taxa) %>% as.data.frame() #转置（行列调换）并设定数据格式为数据框
taxa = taxa[rownames(map),]#将两文件的行顺序调为一致，方便后续合并
dat = cbind(taxa,map)#按列合并两文件
dat = dat[,-8]#去除无效部分
library(reshape2)
dat = aggregate(. ~ Week*Site, data = dat, mean) %>% #同时依据Week和Site两个条件求组内均值，这里我们定义Site为大组，Week为小组
  melt() %>% #数据格式调整，各个变量分别成列
  dcast(variable + Site ~ Week)#数据格式调整，variable和Site为行，Week为列
dat = dat[order(dat$Site, dat$variable,decreasing = F),c('variable','Site','W1','W2','W4','W8','W16')]
library(dplyr)
link_dat <- dat %>% 
  group_by(Site) %>% #按大组Site进行分组，后续作图以Site进行分页展示
  mutate_if(is.numeric, cumsum) %>% #判断是否为数值型变量，才执行本操作
  as.data.frame()
bar.width <- 0.7
link_dat <- link_dat[, c(1,2,3,rep(4:(ncol(link_dat)-1),each=2),ncol(link_dat))] #对数值型变量部分，掐头去尾，对中间的变量各复制一遍
link_dat <- data.frame(y=t(matrix(t(link_dat[,-c(1,2)]), nrow=2)))#除去非数值型变量后，转换为两列的数据框，分别作为连接线的两个端点的纵坐标
link_dat$x.1 <- 1:4 + bar.width/2 #设定连接线的两个端点的横坐标，1:n，n = 小组数-1，类似于砍木头，4刀5段
link_dat$x.2 <- 1:4 + (1-bar.width/2)#同上
link_dat$Site = rep(levels(dat$Site),each = 28)#这里就呼应了上文的组与组之间数据不要串行
library(reshape2)
dat = melt(dat)
names(dat) = c('taxa','Site','Week','value')
dat$taxa = factor(dat$taxa,levels = c('Carbonyl','Aromatic_C-O','Aromatic_C','O-C-O_anomeric_C', 'O-alkyl_C','O-CH3/NCH','Alkyl_C'))

dat$Week = factor(dat$Week,levels = c('W1',"W2","W4","W8","W16"))

levels(dat$Week) = c('1','2','4','8','16')#将变量重命名，必须和上面`dat$Week`设定的顺序保持一致
library(ggplot2)
library(scales)#用来设定百分比形式的纵坐标

p <- ggplot(data = dat, aes(x = Week, y = value, fill = taxa)) + 
  
  theme_bw()+
  
  facet_grid(~ Site,scales = 'free') + #出图以Site为组进行分页展示
  
  labs(x= '',y ='',fill = '') +#设定坐标轴和填充色属性的名称
  
  geom_bar(stat = "identity", width=bar.width, col='black')  + #stat = 'identity'为堆积图
  
  #是否显示对应的具体数据标签
  # geom_text(aes(label = paste0(sprintf("%1.1f", value*100),"%")), #数据显示为保留一个小数点的百分数
  #           size = 4,fontface='bold',position =position_stack(vjust=0.5)) +
  
  geom_segment(data=link_dat, aes(x=x.1, xend=x.2, y=y.1, yend=y.2), inherit.aes = F) +#加载小组间的连接线
  
  #scale_y_continuous(labels = percent) +  # 百分比坐标轴（需加载scales包）
  #自定义颜色，注意顺序
  scale_fill_manual(values = c('gold4','chocolate4','coral1',
                               'cornflowerblue','darkgoldenrod1',
                               'darkmagenta','firebrick1','violetred',
                               'forestgreen','gold4','darkviolet','orange1',
                               'deeppink','salmon1','steelblue','darkred','grey')) + 
  #自定义属性
  theme(strip.text = element_text(face = 'bold',color = 'black',size = 14),#设定分页图的标题属性
        axis.title.y = element_text(face = 'bold',color = 'black',size = 14),
        axis.title.x = element_text(face = 'bold',color = 'black',size = 14,vjust = -1.2),
        axis.text.y = element_text(face = 'bold',color = 'black',size = 10),
        axis.text.x = element_text(face = 'bold',color = 'black',size = 10),
        legend.text = element_text(face = 'bold',color = 'black',size = 10))
p
=======
this is a test
It is very successful
>>>>>>> 2ddca7ff4369a1b5bafac70753f3e22fecc1f705
