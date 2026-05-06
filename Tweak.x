#import <UIKit/UIKit.h>

void showWelcomeMessage() {
    // التأخير لمدة 60 ثانية (دقيقة) كما طلبت
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *window = nil;
        // البحث عن النافذة النشطة في الإصدارات الحديثة
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in scene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
            }
        }
        
        // إذا لم يجد نافذة بالطريقة الحديثة يستخدم الطريقة القديمة
        if (!window) {
            window = [UIApplication sharedApplication].keyWindow;
        }

        if (window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحبا أيها المستخدم"
                                                                           message:@"في jokdpool\nالنسخة المعدلة من 8 Ball Pool"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"قناة التليجرام" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // رابط التليجرام الخاص بك
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
            }];

            UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"بدء اللعب" style:UIAlertActionStyleCancel handler:nil];

            [alert addAction:telegramAction];
            [alert addAction:playAction];

            // إظهار الرسالة
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

%ctor {
    NSLog(@"JokdPool Loaded Successfully!");
    showWelcomeMessage();
}
