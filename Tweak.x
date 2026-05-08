#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// دالة الحقن الآمن في الذاكرة
void patchMemory(uint64_t offset, uint32_t hexCode) {
    uintptr_t targetAddress = _dyld_get_image_vmaddr_slide(0) + offset;
    kern_return_t err;
    mach_port_t task = mach_task_self();
    
    err = vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    if (err == KERN_SUCCESS) {
        *(uint32_t *)targetAddress = hexCode;
        vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
    }
}

%ctor {
    // ننتظر 15 ثانية حتى تستقر اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // العنوان الأول من ملفك: bpForceRecomputeTransform
        // هذا العنوان مسؤول عن "إعادة حساب المسارات"
        patchMemory(0x00028208, 0xD503201F); // استخدام NOP لتعطيل القيود

        // العنوان الثاني من ملفك: مرتبط بـ الدوال المجهولة fcn القريبة من الرسم
        patchMemory(0x000937cc, 0xD503201F); 

        // العنوان الثالث: دالة فك التشفير (لإجبار اللعبة على قبول القيم المعدلة)
        patchMemory(0x0001eda0, 0xD503201F);

        // إظهار تنبيه عند نجاح العملية
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad"
                                                                       message:@"تم تفعيل هاك الخطوط من ملف u.txt"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
        
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) { keyWindow = window; break; }
                    }
                }
            }
        }
        if(!keyWindow) keyWindow = [UIApplication sharedApplication].keyWindow;
        
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
