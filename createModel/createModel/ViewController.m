//
//  ViewController.m
//  生成model
//
//  Created by 刘松 on 16/12/1.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "ViewController.h"
#import "DragDropView.h"


@interface ViewController ()<DragDropViewDelegate>



@property (weak) IBOutlet NSTextField *tip;
@property (weak) IBOutlet NSTextField *createFileName;
@property (unsafe_unretained) IBOutlet NSTextView *text;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)create:(id)sender {
    
    
    NSString *path=self.tip.stringValue;
    if ([[[self.text.string stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""].length<=0&&[self.tip.stringValue isEqualToString:@"暂无目录"]) {
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert setMessageText:@"没有粘贴字符串到输入框或拖拽本地文件到弹窗中"];
        //[alert setInformativeText:@"副标题"];
        [alert addButtonWithTitle:@"取消"];
        //[alert addButtonWithTitle:@"取消"];
        
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
        return;
    }
    
    if (self.createFileName.stringValue.length<=0) {
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert setMessageText:@"请输入创建的类名"];
        //[alert setInformativeText:@"副标题"];
        [alert addButtonWithTitle:@"取消"];
        //[alert addButtonWithTitle:@"取消"];
        
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
        return;
    }
    
    
    
    if ([[[self.text.string stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""].length>0)
    {
        
        [self parse:self.text.string];
    }else{
        
        NSString *content = [NSString stringWithContentsOfFile:path    encoding:NSUTF8StringEncoding error:nil];
        [self parse:content];
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"创建成功"];
    //[alert setInformativeText:@"副标题"];
    [alert addButtonWithTitle:@"取消"];
    //[alert addButtonWithTitle:@"取消"];
    
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    
    
}



-(NSString*)replace1WithContent:(NSString*)content regexStr:(NSString*)regexStr{
    
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options: NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *array2 = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    
    
    NSMutableArray *replaceArray=[NSMutableArray array];
    for (NSTextCheckingResult *result in array2) {
        
        [replaceArray addObject:[content substringWithRange:result.range]];
    }
    for (NSString *str in replaceArray) {
        NSString *key =[str componentsSeparatedByString:@"\""].lastObject;
        content =  [content stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"\"%@",key]];
    }
    return content;
}
-(NSString*)replace2WithContent:(NSString*)content regexStr:(NSString*)regexStr{
    
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options: NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *array2 = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    
    NSMutableArray *replaceArray=[NSMutableArray array];
    for (NSTextCheckingResult *result in array2) {
        [replaceArray addObject:[content substringWithRange:result.range]];
    }
    
    for (NSString *str in replaceArray) {
        
        
        NSRegularExpression* regex2 = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options: NSRegularExpressionCaseInsensitive error:NULL];
        
        NSArray *array2 = [regex2 matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
        
        
        NSString *re=str;
        if (array2.count>0) {
            NSTextCheckingResult *result=array2.firstObject;
            re = [re substringWithRange:result.range];
        }
        re=[str stringByReplacingOccurrencesOfString:re withString:@""];
        content =  [content stringByReplacingOccurrencesOfString:str withString:re];
    }
    return content;
}

-(void)createFileWithDict:(NSDictionary*)dict fileName:(NSString*)fileName
{
    NSString *deskTopLocation=[NSHomeDirectoryForUser(NSUserName()) stringByAppendingPathComponent:@"Desktop"];
    
    //以下两行生成一个文件目录
    NSString *hFilePath=[deskTopLocation stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.h",fileName]];
    
    NSString *mFilePath=[deskTopLocation stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.m",fileName]];
    
    NSString *hContent=@"";
    if (dict==nil) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"创建失败"];
        //[alert setInformativeText:@"副标题"];
        [alert addButtonWithTitle:@"取消"];
        //[alert addButtonWithTitle:@"取消"];
        
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];

        return;
    
    }
    for (NSString *key in dict.allKeys) {
        
        
        id value=dict[ key];
        NSString *type=[[value class]description];
        NSLog(@"class======%@",type);
        NSString *content=@"";
        if ([type rangeOfString:@"NSCFBoolean"].length>0) {
            //Bool类型
            content =[NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@;\n",key];
        }else if ([type rangeOfString:@"NSArray"].length>0)
        {//数组

            content =[NSString stringWithFormat:@"@property(nonatomic,strong)  NSArray *%@;\n",key];
            
            NSArray *arr=value;
            if (arr.count>0) {
                if ([arr.firstObject isKindOfClass:[NSDictionary class]]) {
                
                    
                    [self createFileWithDict:arr.firstObject fileName:[NSString stringWithFormat:@"%@%@",fileName,[self getFirstLetterFromString:key]]];
                    
                }
            }
        }else{
            content =[NSString stringWithFormat:@"@property (nonatomic,copy)   NSString *%@;\n",key];
        }
        hContent=[hContent stringByAppendingString:content];
        
    }
    
    //如若不需要作者的友情链接替换成空即可
    NSString *fileHeader=@"\n\n//作者github链接  https://github.com/lsmakethebest\n//个人博客http://www.itiapp.cn\n\n";
    
    
    NSString *hFile1=@"\n#import <UIKit/UIKit.h>\n\n@i";
    NSString *hFile2=[NSString stringWithFormat:@"nterface %@ : NSObject\n\n\n",fileName];
    
    NSString *fileFooter1=@"\n\n@e";
    NSString *fileFooter2=@"nd\n\n\n";
    
    NSString *hFile=[NSString stringWithFormat:@"%@%@%@%@%@%@",fileHeader,hFile1,hFile2,hContent,fileFooter1,fileFooter2];
    [self runWriteWithContent:hFile path:hFilePath];
    
    
    NSString *mFile1=[NSString stringWithFormat:@"\n#import \"%@.h\"\n\n@i",fileName];
    NSString *mFile2=[NSString stringWithFormat:@"mplementation %@\n\n\n",fileName];
    NSString *mFile=[NSString stringWithFormat:@"%@%@%@%@%@",fileHeader,mFile1,mFile2,fileFooter1,fileFooter2];
    [self runWriteWithContent:mFile path:mFilePath];
    
    
}

-(void)parse:(NSString*)content{
    
    content=[content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    
    //过滤掉因为复制粘贴带来的行号
    NSString *regexStr1 = @"[0-9]+\"[a-zA-Z0-9]+";
    content=  [self replace1WithContent:content regexStr:regexStr1];
    
    NSString *regexStr2 = @"[^:][0-9]+[\]\{\}]";
    content=  [self replace2WithContent:content regexStr:regexStr2];
    
    content=[NSString stringWithFormat:@"{%@}",content];
    NSLog(@"%@",content);
    
    NSError*error;
    NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableContainers) error:&error];
    
    
    NSString *fileName=self.createFileName.stringValue;
    [self createFileWithDict:dict fileName:fileName];
    
    
    
    //
    //    NSArray *contentArray =
    //    [content componentsSeparatedByCharactersInSet:[NSCharacterSet  newlineCharacterSet]];
    //
    //
    //    content=[content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSArray *array =
    //    [content componentsSeparatedByString:@","];
    //    for (NSString *s in array) {
    //        NSLog(@"%@",s);
    //        NSLog(@"----------------");
    //    }
    //    NSLog(@"%@",array);
    //    return;
    //
    //    NSString *hContent=@"";
    //    for (NSString *line in array) {
    //
    //        NSArray *arr=[line componentsSeparatedByString:@":"];
    //
    //        NSString *key=arr.firstObject;
    //        NSString *value=arr.lastObject;
    //
    //        NSArray *keyArr=[key componentsSeparatedByString:@"\""];
    //        key=keyArr.lastObject;
    //        //此处是去除有的接口从网页上复制下来包含行号
    //        if ([key isEqualToString:@""]) {
    //            NSInteger count=keyArr.count;
    //            key=keyArr[count-2];
    //        }
    //        NSString *content;
    //
    //
    //        if ([value rangeOfString:@"true"].length>0||[value rangeOfString:@"false"].length>0) {
    //            content =[NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@;\n",key];
    //        }else{
    //            content =[NSString stringWithFormat:@"@property (nonatomic,copy) NSString *%@;\n",key];
    //        }
    //
    //        hContent=[hContent stringByAppendingString:content];
    //
    //    }
    //
    
    
}


-(void)runWriteWithContent:(NSString*)content path:(NSString*)path
{
    //用上面的目录创建这个文件
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL success=[fileManager createFileAtPath:path contents:nil attributes:nil];
    if (success) {
        NSLog(@"success");
    }
    //打开上面创建的那个文件
    NSFileHandle *fileHandle=[NSFileHandle fileHandleForWritingAtPath:path];
    [fileHandle seekToEndOfFile];//每次打开文件把光标定位在文末
    NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];//把这个字符串转换成数据格式用于写入文件里
    [fileHandle writeData:data];//写入文件
    [fileHandle closeFile];//关闭文件
    
}






- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


/***
 第四步：实现dragdropview的代理函数，如果有数据返回就会触发这个函数
 ***/
-(void)dragDropViewFileList:(NSArray *)fileList{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)return;
    //在这里我们将遍历这个数字，输出所有的链接，在后台你将会看到所有接受到的文件地址
    for (int n = 0 ; n < [fileList count] ; n++) {
        NSString *path=[fileList objectAtIndex:n];
        NSLog(@"目录:%@",path);
        self.tip.stringValue=path;
    }
}


//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)getFirstLetterFromString:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *strPinYin = [str capitalizedString];
    //获取并返回首字母
    return strPinYin ;
}

- (IBAction)look:(id)sender {
    
    [[NSWorkspace sharedWorkspace]openURL:[NSURL URLWithString:@"https://github.com/lsmakethebest/LSCreateModel"]];
    
    
}




@end
