#import <UIKit/UIKit.h>

%ctor {
    // الانتظار لمدة 40 ثانية قبل تنفيذ الكود
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // الحصول على واجهة العرض الأساسية للعبة
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        // إنشاء رسالة التنبيه
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad"
                                                                       message:@"مرحبا بك في نسختنا المطوره"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"شكراً"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        [alert addAction:okAction];
        
        // إظهار الرسالة فوق اللعبة
        [rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
