#import <UIKit/UIKit.h>

%ctor {
    // الانتظار لمدة 40 ثانية قبل تنفيذ الكود
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = nil;
        
        // الطريقة الحديثة للحصول على النافذة الأساسية في iOS 13+
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) {
                            keyWindow = window;
                            break;
                        }
                    }
                }
            }
        }
        
        // إذا لم يجد نافذة بالطريقة الحديثة أو كان الإصدار قديماً
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }

        if (keyWindow) {
            UIViewController *rootViewController = keyWindow.rootViewController;
            
            // التأكد من وجود RootViewController قبل إظهار الرسالة
            if (rootViewController) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad"
                                                                               message:@"مرحبا بك في نسختنا المطوره"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"شكراً"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                
                [alert addAction:okAction];
                
                [rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    });
}
