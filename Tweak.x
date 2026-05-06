#import <UIKit/UIKit.h>

// كود لزيادة عدد الحسابات - سليم جداً
%hook UserConfig
- (int)maxAccountCount {
    return 999;
}
%end

%hook AppDelegate
- (void)applicationDidBecomeActive:(id)application {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // تأخير لمدة ثانية واحدة لضمان استقرار الواجهة ومنع كراش الساند بوكس
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Edition"
                                                                           message:@"مرحبا بك في نسخة حسين سعد 🇮🇶"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"تواصل معي"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
            }];

            UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"ابدأ"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:nil];

            [alert addAction:telegramAction];
            [alert addAction:startAction];

            // طريقة أكثر أماناً للوصول للنافذة بدون استهلاك صلاحيات Sandbox عالية
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (!rootVC) {
                rootVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
            }

            [rootVC presentViewController:alert animated:YES completion:nil];
        });
    });
}
%end
