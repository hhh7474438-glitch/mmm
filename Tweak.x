#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

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
    // ننتظر 15 ثانية لضمان استقرار الذاكرة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // محاولة تفعيل الخطوط باستخدام قيمة العودة "True" (0x52800020 تعني mov w0, #1 ثم ret)
        // سنستخدم العناوين الأكثر احتمالاً من ملفك u.txt
        
        // 1. تجربة تفعيل دالة إعادة الحساب
        patchMemory(0x00028208, 0xD2800020); // MOV X0, #1
        patchMemory(0x0002820C, 0xD65F03C0); // RET
        
        // 2. تجربة دالة الرسم القريبة من الـ Canvas
        patchMemory(0x000937cc, 0xD2800020); // MOV X0, #1
        patchMemory(0x000937D0, 0xD65F03C0); // RET

        // تنبيه التأكيد
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad"
                                                                       message:@"تمت محاولة التفعيل المباشر للخطوط"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        
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
