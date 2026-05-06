#import <UIKit/UIKit.h>

// كود لزيادة عدد الحسابات (منطقي برمجياً لبعض التطبيقات)
%hook UserConfig
- (int)maxAccountCount {
    return 999; // عدد لا نهائي نظرياً
}
%end

%hook AppDelegate
- (void)applicationDidBecomeActive:(id)application {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Edition"
                                                                       message:@"مرحبا بك في نسخة حسين سعد 🇮🇶"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        // زر التواصل عبر تليجرام
        UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"تواصل معي عبر تليكرام"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
        }];

        // زر البدء (Start)
        UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Start"
                                                              style:UIAlertActionStyleDestructive
                                                            handler:nil];

        [alert addAction:telegramAction];
        [alert addAction:startAction];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
%end
