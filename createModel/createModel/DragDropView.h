//
//  DragDropView.h
//  DragAndDrop
//
//  Created by chenghxc on 13-2-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol DragDropViewDelegate;

@interface DragDropView : NSView
@property (assign) IBOutlet id<DragDropViewDelegate> delegate;
@end

@protocol DragDropViewDelegate <NSObject>
-(void)dragDropViewFileList:(NSArray*)fileList;
@end