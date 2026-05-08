#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// دالة الكتابة في الذاكرة (مبسطة جداً ومنفصلة)
void applyHusseinPatch(uint64_t offset, uint32_t hexCode) {
    uintptr_t targetAddress = _dyld_get_image_vmaddr_slide(0) + offset;
    if (targetAddress < 0x100000000) return; 
    
    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(uint32_t *)targetAddress = hexCode;
    vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
}

%ctor {
    // فصلنا الكود تماماً داخل تايمر (Timer)
    // اللعبة ستفتح وتشتغل طبيعي، والدايلب سينتظر بالخلفية
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // تعديل طول الخط فقط (عبر ميزة الماكس ليفل)
        // هذا العنوان استخرجناه من سيرفرك وهو الأكثر أماناً
        applyHusseinPatch(0x32c2d18, 0xD2800020); // IsCueAtMaxLevel -> Return True
        applyHusseinPatch(0x32c2d1C, 0xD65F03C0); // RET
        
        // إظهار رسالة بسيطة للتأكد أن الدايلب "عاش" ولم يمت
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow && [[UIApplication sharedApplication] connectedScenes].count > 0) {
            for (UIWindowScene* scene in [[UIApplication sharedApplication] connectedScenes]) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = scene.windows.firstObject;
                    break;
                }
            }
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Server"
                                                                       message:@"الهاك اشتغل بدون كراش"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"أوكي" style:UIAlertActionStyleDefault handler:nil]];
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
