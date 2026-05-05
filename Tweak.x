#import <UIKit/UIKit.h>

// يتم استدعاء هذا الجزء عند تشغيل التطبيق (اللعبة)
%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
    object:nil 
    queue:[NSOperationQueue mainQueue] 
    usingBlock:^(NSNotification * _Nonnull note) {
        
        // إنشاء واجهة التنبيه
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحبا بك في نسخة حسين سعد" 
                                                                       message:@"تمتع بل لعب" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // إضافة زر Start
        UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Start" 
                                                              style:UIAlertActionStyleDefault 
                                                            handler:nil];
        
        [alert addAction:startAction];
        
        // إظهار التنبيه فوق واجهة اللعبة الأساسية
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}
