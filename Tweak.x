#import <UIKit/UIKit.h>

// --- زيادة عدد الحسابات ---
%hook UserConfig
- (int)maxAccountCount {
    return 1000; // عدد ضخم واحترافي
}
%end

// --- التحكم في واجهة التطبيق ---
%hook AppDelegate

- (void)applicationDidBecomeActive:(id)application {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // تأخير بسيط لضمان استقرار التطبيق بعد التشغيل
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // إنشاء التنبيه
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Edition"
                                                                           message:@"مرحباً بك في نسخة حسين سعد - @qmyqq 🇮🇶\nتم تفعيل ميزة تعدد الحسابات بنجاح."
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"قناة التحديثات"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
            }];

            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"استمرار"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:nil];

            [alert addAction:telegramAction];
            [alert addAction:dismissAction];

            // الطريقة الاحترافية والأكثر أماناً للوصول للنافذة (تتجنب كراش الساند بوكس)
            UIWindow *keyWindow = nil;
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
            
            // إذا فشلت الطريقة الحديثة نستخدم الطريقة التقليدية كخيار احتياطي
            if (!keyWindow) {
                keyWindow = [UIApplication sharedApplication].keyWindow;
            }

            UIViewController *rootVC = keyWindow.rootViewController;
            
            // التأكد من عدم وجود تنبيه آخر معروض حالياً لتجنب التعارض
            if (rootVC) {
                while (rootVC.presentedViewController) {
                    rootVC = rootVC.presentedViewController;
                }
                [rootVC presentViewController:alert animated:YES completion:nil];
            }
        });
    });
}
%end
