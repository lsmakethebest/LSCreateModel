# LSCreateModel
####mac app根据json字符串创建模型类 自动判断类型，只会创建NSString和Bool类型和MJExtension完美结合，如果不想用xcode编译可直接下载完把.app文件拖到finder->应用程序里直接运行

#使用方法:
##1.可以选择本地的文件拖动到弹窗里会自动获取文件的目录生成model或者粘贴字符串到输入框
##2.输入想要创建的类名
##3.点击生成



#可以多层嵌套使用，字典里嵌套字典
###比如：
` "curPagerNo": 1,
"pageSize": 10,
"totalPageNumber": 5,
"list": [
         {
             "createUserId": 33237,
             "goodsTypeName": "无烟煤",
             "takeAddressName": "近距离",
             "companyName": "王闯的公司"
         }
         ],
"last": false,
"first": true,
"rowsCount": 41
`
##当你输入LSModel
会创建LSModel.h LSModel.m LSModelList.h LSModelList.m四个文件


![image](https://github.com/lsmakethebest/LSCreateModel/blob/master/images/yanshi.gif)

