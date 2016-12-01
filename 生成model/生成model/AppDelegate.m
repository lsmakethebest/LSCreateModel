//
//  AppDelegate.m
//  生成model
//
//  Created by 刘松 on 16/12/1.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
/***
 第五步：实现dragdropview的代理函数，如果有数据返回就会触发这个函数
 ***/
-(void)dragDropViewFileList:(NSArray *)fileList{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)return;
    //在这里我们将遍历这个数字，输出所有的链接，在后台你将会看到所有接受到的文件地址
    for (int n = 0 ; n < [fileList count] ; n++) {
        NSLog(@">>> %@",[fileList objectAtIndex:n]);
    }
    
}

/***
 第六步：在MainMenu.xib中添加一个CustomView，将类型改为DragDropView，并将DragDropView的delegate指定到AppDelegate中
 ***/


@end
