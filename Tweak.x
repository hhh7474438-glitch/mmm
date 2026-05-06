#import <UIKit/UIKit.h>

// دالة لإظهار التنبيه بعد دقيقة
void showWelcomeMessage() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // إنشاء التنبيه
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحبا أيها المستخدم"
                                                                       message:@"في jokdpool\nالنسخة المعدلة من 8 Ball Pool"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        // زر التليجرام
        UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"قناة التليجرام" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.url/qmyqq"] options:@{} completionHandler:nil];
        }];

        // زر بدء اللعب
        UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"بدء اللعب" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:telegramAction];
        [alert addAction:playAction];

        // إظهار التنبيه على الشاشة الرئيسية للعبه
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// نقطة انطلاق التويك عند فتح اللعبة
%ctor {
    NSLog(@"JokdPool Loaded!");
    showWelcomeMessage();
}
