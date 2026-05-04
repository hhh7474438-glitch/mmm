#import <UIKit/UIKit.h>

// نقوم بعمل Hook على المتحكم الرئيسي للعبة لضمان تشغيل الكود عند البدء
%hook UnityAppController

- (void)applicationDidBecomeActive:(id)application {
    %orig; // استدعاء الوظيفة الأصلية للعبة لضمان عدم حدوث تعليق

    // إضافة تأخير بسيط (ثانية واحدة) لضمان ظهور واجهة اللعبة أولاً
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // إنشاء التنبيه (Alert)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Hack"
                                   message:@"Welcome, Hussein Saad"
                                   preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Start Gaming"
                                   style:UIAlertActionStyleDefault
                                   handler:nil];

        [alert addAction:okAction];

        // البحث عن النافذة النشطة (Window) بالطريقة الحديثة المتوافقة مع iOS 13-18
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    window = windowScene.windows.firstObject;
                    break;
                }
            }
        } else {
            // للطريقة القديمة إذا كان الإصدار أقل من iOS 13
            window = [UIApplication sharedApplication].keyWindow;
        }
        
        // إظهار الرسالة فوق واجهة اللعبة
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

%end
