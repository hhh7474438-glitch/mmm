#import <UIKit/UIKit.h>

// دالة تظهر التنبيه عند تشغيل اللعبة
%hook UnityAppController // أو AppDelegate حسب نوع اللعبة

- (void)applicationDidBecomeActive:(id)application {
    %orig; // تنفيذ أمر تشغيل اللعبة الأصلي أولاً

    // إنشاء رسالة تنبيه (Alert)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Hack"
                               message:@"Welcome, Hussein Saad"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Start Gaming"
                               style:UIAlertActionStyleDefault
                               handler:nil];

    [alert addAction:okAction];

    // إظهار الرسالة فوق واجهة اللعبة
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

%end
