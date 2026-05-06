#import <UIKit/UIKit.h>

// كود لزيادة عدد الحسابات
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Edition"
                                                                       message:@"مرحبا بك في نسخة حسين سعد 🇮🇶"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"تواصل معي عبر تليكرام"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
        }];

        UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Start"
                                                              style:UIAlertActionStyleDestructive
                                                            handler:nil];

        [alert addAction:telegramAction];
        [alert addAction:startAction];

        // الطريقة الحديثة للحصول على rootViewController في iOS 13+
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }

        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
%end
