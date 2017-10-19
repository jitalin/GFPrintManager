//
//  PrintManager.m
//  AirPrintDemo
//
//  Created by zhoubaoyang on 15/11/3.
//  Copyright © 2015年 zhoubaoyang. All rights reserved.
//

#import "PrintManager.h"

@interface PrintManager ()


@end
@implementation PrintManager
#pragma mark-----单例模式
static PrintManager* _manager = nil;
+ (PrintManager *)sharedPrintManager{
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[PrintManager alloc]init];
            
        });
    }return _manager;
}
#pragma mark------------打印多张图片
+(void)printImageWithArr:(NSArray*)imageArr ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect{
    
    NSMutableArray* printItems = [NSMutableArray arrayWithCapacity:0];
    for (UIImage* image in imageArr) {
        NSData* imageData = UIImagePNGRepresentation(image);
        // 得到打印数据
        [printItems addObject:imageData];
    }
    UIPrintInteractionController *printVC = [UIPrintInteractionController sharedPrintController];
    
    if(printVC && [UIPrintInteractionController canPrintData: printItems[0]] ) {
        printVC.delegate = viewController;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"LGH";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printVC.printInfo = printInfo;
        printVC.printingItems = printItems;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (completed)
            {
                // 执行成功后的处理
                
            }
            else if (!completed && error)
            {
                // 执行失败后的处理
            }
        };
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [printVC presentAnimated:YES completionHandler:completionHandler];
            // iPhone使用这个方法
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
           
            [printVC presentFromRect:showRect inView:viewController.view animated:YES completionHandler:completionHandler];
            // iPad使用这个方法
        }
        
    }
    
}



// 打印LocalDocument,such as pdf
-(void)printWithFilePath:(NSString*)filePath ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect{
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.showsNumberOfCopies = YES;
    printC.showsPaperSelectionForLoadedPapers = YES;
    printC.delegate = viewController;
    if (!printC) {
        NSLog(@"打印机不存在");
    }
    NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
    if (printC && [UIPrintInteractionController canPrintData:pdfData]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        printInfo.jobName = @"my.job";
        printC.printInfo = printInfo;
        //设置打印源文件
        printC.printingItem = pdfData;//single NSData, NSURL, UIImage, ALAsset
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (completed)
            {
                // 执行成功后的处理
                
            }
            else if (!completed && error)
            {
                // 执行失败后的处理
            }
        };
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [printC presentAnimated:YES completionHandler:completionHandler];
            // iPhone使用这个方法
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [printC presentFromRect:showRect inView:viewController.view animated:YES completionHandler:completionHandler];
            // iPad使用这个方法
        }

        
        
    }
}

#pragma mark---------------打印网页
-(void)printWithWebView:(UIWebView*)myWebView ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect{
    
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = viewController;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
    printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
    //    打印网
    printC.printFormatter = [myWebView viewPrintFormatter];//布局打印视图绘制的内容。
    UIViewPrintFormatter *form = [[UIViewPrintFormatter alloc] init];
    form.maximumContentHeight = 40;
    [myWebView drawRect:CGRectMake(0, 0, 300, 300) forViewPrintFormatter:form];

    /*
     //    打印文本
     UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
     initWithText:@"ここの　ういえい　子に　うぃっl willingseal  20655322　　你好么？ ＃@¥％……&＊"];
     textFormatter.startPage = 0;
     textFormatter.contentInsets = UIEdgeInsetsMake(200, 300, 0, 72.0); // 插入内容页的边缘 1 inch margins
     textFormatter.maximumContentWidth = 16 * 72.0;//最大范围的宽
     printC.printFormatter = textFormatter;
     */
    
    //    等待完成
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"可能无法完成，因为印刷错误: %@", error);
        }
    };
    [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
   
    
    
}
#pragma mark----------- 打印图片
-(void)printWithImage:(UIImage* )printImage ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect{
    //剪切原图（824 * 2235）  这里需要说明下 因为A4 纸的72像素的 大小是（595，824） 为了打印出A4 纸 之类把原图转化成A4 的宽度，高度可适当调高 以适应页面内容的需求 ，调这个很简单地，打开你目前截取的图片，点击工具，然后点击调整大小，把宽度设置成595 就可以了，看高度是多少 除以 824 就是 几页 ，不用再解释了吧。。。ios打印功能实现（ScrollerView打印）
    //原图未处理，直接打印如下：
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = viewController;
    if (!printC) {
        NSLog(@"打印机不存在");
    }
    printC.showsNumberOfCopies = YES;
    NSData *imgDate = UIImagePNGRepresentation(printImage);
    NSData *data = [NSData dataWithData:imgDate];
    if (printC && [UIPrintInteractionController canPrintData:data]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
       // printC.showsPageRange = YES;//显示的页面范围
        
        //printInfo.jobName = @"my.job";
        printC.printInfo = printInfo;
        printC.printingItem = data;//single NSData, NSURL, UIImage, ALAsset
        
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (completed)
            {
                // 执行成功后的处理
                
            }
            else if (!completed && error)
            {
                // 执行失败后的处理
            }
        };
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [printC presentAnimated:YES completionHandler:completionHandler];
            // iPhone使用这个方法
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [printC presentFromRect:showRect inView:viewController.view animated:YES completionHandler:completionHandler];
            // iPad使用这个方法
        }

    }
}

@end
