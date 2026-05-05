#import <UIKit/UIKit.h>

// دالة برمجية للحصول على "النافذة" النشطة في التطبيق (متوافقة مع iOS 13 وحتى iOS 18)
// الهدف منها تجنب خطأ keyWindow الذي ظهر في سجل البناء السابق
UIWindow *get_activeWindow() {
    UIWindow *foundWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) {
                    foundWindow = window;
                    break;
                }
            }
        }
        if (foundWindow) break;
    }
    return foundWindow ?: [UIApplication sharedApplication].keyWindow;
}

// دالة البداية (Constructor) - يتم تنفيذها بمجرد تحميل ملف dylib في اللعبة
%ctor {
    // ننتظر حتى ينتهي التطبيق من التحميل بالكامل قبل إظهار الرسالة
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
    object:nil 
    queue:[NSOperationQueue mainQueue] 
    usingBlock:^(NSNotification * _Nonnull note) {
        
        // إنشاء واجهة التنبيه (Alert Controller)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحبا بك في نسخة حسين سعد" 
                                                                       message:@"تمتع بل لعب" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // إنشاء زر البدء (Start Button)
        UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Start" 
                                                              style:UIAlertActionStyleDefault 
                                                            handler:nil];
        
        // إضافة الزر إلى التنبيه
        [alert addAction:startAction];
        
        // إظهار التنبيه على الشاشة بعد تأخير بسيط لضمان ظهور واجهة اللعبة
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = get_activeWindow();
            [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }];
}
