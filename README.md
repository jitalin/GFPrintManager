# GFPrintManager
iOS-AirPrint-Demo，To achieve the end of the phone to connect the printer。实现手机端连接打印机的多种打印功能。支持iphone和ipad
主要提供的接口：
/**
 *  打印一组图片
 *
 *  @param imageArr         存放图片的数组
 *  @param viewController   执行打印操作的控制器，遵从打印协议
 *  @param showRect         打印弹窗显示的区域，此参数只在iPad上使用。
 *
 */
+(void)printImageWithArr:(NSArray*)imageArr ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect;
//打印单张图片
-(void)printWithImage:(UIImage* )printImage ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect;
// 打印LocalDocument,such as pdf
-(void)printWithFilePath:(NSString*)filePath ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect;
//打印网页
-(void)printWithWebView:(UIWebView*)myWebView ViewController:(UIViewController<UIPrintInteractionControllerDelegate>*)viewController ShowRect:(CGRect)showRect;
//单例对象
+ (GFPrintManager*)sharedPrintManager;
