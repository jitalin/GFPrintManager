//
//  ViewController.m
//  iOS-AirPrint打印功能
//
//  Created by 高飞 on 17/3/3.
//  Copyright © 2017年 高飞. All rights reserved.
//

#import "DemoViewController.h"
#import "PrintManager.h"
@interface DemoViewController ()<UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSArray *imageArray;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    NSString* url = @"http://www.baidu.com";
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webView.scalesPageToFit = YES;
    self.webView = webView;
    [self.view addSubview: webView];
    self.imageArray = @[self.imageView.image,self.imageView.image];
    
    
}
- (IBAction)printWithWebView:(id)sender {

    //打印网页
    [[PrintManager sharedPrintManager]printWithWebView:self.webView ViewController:self ShowRect:CGRectMake(0, 0, 1300, 200)];
    
}
- (IBAction)printWithImage:(id)sender {
    [[PrintManager sharedPrintManager]printWithImage:self.imageView.image ViewController:self ShowRect:CGRectMake(0, 0, 1300, 200)];
    
}
- (IBAction)printWithFilePath:(id)sender {
     NSString* path = [[NSBundle mainBundle]pathForResource:@"PDF使用指南.pdf" ofType:nil];
    [[PrintManager sharedPrintManager]printWithFilePath:path ViewController:self ShowRect:CGRectMake(0, 0, 1300, 200)];
    
}
- (IBAction)printWithImageArray:(id)sender {
 [PrintManager printImageWithArr:self.imageArray ViewController:self ShowRect:CGRectMake(0, 0, 1300, 200)];
    
}
#pragma mark----------UIPrintInteractionControllerDelegate
- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController{
    
    NSLog(@"%@",printInteractionController.printInfo.jobName);
    
    
}
- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"printInteractionController WillStartJob");
}



- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"printInteractionController WillPresentPrinterOptions");
}


- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"printInteractionController DidDismissPrinterOptions");
}

//暂时无用   paperList据说是分页的，但是没找到具体信息，回头再找
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList {
    //设置纸张大小
    CGSize paperSize = CGSizeMake(595, 880);
    return [UIPrintPaper bestPaperForPageSize:paperSize withPapersFromArray:paperList];
}



@end
