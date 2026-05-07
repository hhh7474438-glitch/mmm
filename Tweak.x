#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// تعريف الدالة لتعديل القوة باستخدام العناوين
void patch_force() {
    // استخدمنا (void) لمنع خطأ "المتغير غير مستخدم"
    uint64_t address = 0x28208; 
    uint32_t patch = 0xD65F03C0; 
    (void)address;
    (void)patch;

    // هنا يتم تطبيق التعديل فعلياً إذا كانت مكتبة KittyMemory مضافة
    // حالياً الكود سيمر بدون أخطاء في بناء الـ dylib
}

%ctor {
    // تنفيذ التعديل فور تشغيل اللعبة
    patch_force();

    // إظهار رسالة ترحيبية بعد 30 ثانية
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // طريقة حديثة للحصول على النافذة (Window) لتجنب خطأ keyWindow
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in scene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }

        if (window) {
            UIViewController *rootViewController = window.rootViewController;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Team"
                                                                           message:@"مرحبا بك في تطبيق المعدل"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"شكراً" 
                                                               style:UIAlertActionStyleDefault 
                                                             handler:nil];
            
            [alert addAction:okAction];
            [rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}
