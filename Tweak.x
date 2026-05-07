#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// لتعديل الهيكس برمجياً
void patch_force() {
    uint64_t address = 0x28208; // العنوان اللي استخرجته
    // كود RET لتعطيل القوة القصوى
    uint32_t patch = 0xD65F03C0; 
    
    // ملاحظة: كتابة الكود هنا تعتمد على مكتبة KittyMemory 
    // إذا كنت تستخدم Acinoir فهي مدمجة تلقائياً
}

%ctor {
    // تشغيل تعديل القوة فور تشغيل اللعبة
    patch_force();

    // إظهار رسالة ترحيبية بعد 30 ثانية
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Team"
                                                                       message:@"مرحبا بك في تطبيق المعدل"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"شكراً" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:nil];
        
        [alert addAction:okAction];
        [rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
