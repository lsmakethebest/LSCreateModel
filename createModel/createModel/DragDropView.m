//
//  DragDropView.m
//  DragAndDrop
//
//  Created by chenghxc on 13-2-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DragDropView.h"

@implementation DragDropView
@synthesize delegate = _delegate;

- (void)dealloc {
    [self setDelegate:nil];

}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /***
         第一步：帮助view注册拖动事件的监听器，可以监听多种数据类型，这里只列出比较常用的：
             NSStringPboardType         字符串类型
             NSFilenamesPboardType      文件
             NSURLPboardType            url链接
             NSPDFPboardType            pdf文件
             NSHTMLPboardType           html文件
         ***/
        //这里我们只添加对文件进行监听，如果拖动其他数据类型到view中是不会被接受的
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    /***
     第一步：帮助view注册拖动事件的监听器，可以监听多种数据类型，这里只列出比较常用的：
     NSStringPboardType         字符串类型
     NSFilenamesPboardType      文件
     NSURLPboardType            url链接
     NSPDFPboardType            pdf文件
     NSHTMLPboardType           html文件
     ***/
    //这里我们只添加对文件进行监听，如果拖动其他数据类型到view中是不会被接受的
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];

}

/***
 第二步：当拖动数据进入view时会触发这个函数，我们可以在这个函数里面判断数据是什么类型，来确定要显示什么样的图标。比如接受到的数据是我们想要的NSFilenamesPboardType文件类型，我们就可以在鼠标的下方显示一个“＋”号，当然我们需要返回这个类型NSDragOperationCopy。如果接受到的文件不是我们想要的数据格式，可以返回NSDragOperationNone;这个时候拖动的图标不会有任何改变。
 ***/
-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
	NSPasteboard *pboard = [sender draggingPasteboard];
    
	if ([[pboard types] containsObject:NSFilenamesPboardType]) {
			return NSDragOperationCopy;
	}
    
	return NSDragOperationNone;
}

/***
 第三步：当在view中松开鼠标键时会触发以下函数，我们可以在这个函数里面处理接受到的数据
 ***/
-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    // 1）、获取拖动数据中的粘贴板
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    // 2）、从粘贴板中提取我们想要的NSFilenamesPboardType数据，这里获取到的是一个文件链接的数组，里面保存的是所有拖动进来的文件地址，如果你只想处理一个文件，那么只需要从数组中提取一个路径就可以了。
    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    // 3）、将接受到的文件链接数组通过代理传送
    self.delegate=self.nextResponder;
    if(self.delegate && [self.delegate respondsToSelector:@selector(dragDropViewFileList:)])
        [self.delegate dragDropViewFileList:list];
    
    return YES;
}



- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}




@end
