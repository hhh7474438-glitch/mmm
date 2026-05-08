#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <QuartzCore/QuartzCore.h>

// دالة تعديل الذاكرة الآمنة
void patchMemory(uint64_t offset, uint32_t hexCode) {
    uintptr_t targetAddress = _dyld_get_image_vmaddr_slide(0) + offset;
    mach_port_t task = mach_task_self();
    
    // فك حماية الذاكرة للكتابة
    vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    
    // كتابة الكود الجديد
    *(uint32_t *)targetAddress = hexCode;
    
    // إعادة حماية الذاكرة للأصل
    vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
}

// --- كود تلوين وتوضيح الخط ---
%hook CAShapeLayer
- (void)setStrokeColor:(CGColorRef)color {
    CGFloat redColor[] = {1.0, 0.0, 0.0, 1.0}; // لون أحمر
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef red = CGColorCreate(rgbSpace, redColor);
    %orig(red);
    CGColorRelease(red);
    CGColorSpaceRelease(rgbSpace);
}

- (void)setLineWidth:(CGFloat)width {
    %orig(3.0); // سمك الخط
}
%end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 1. تفعيل حسابات الاصطدام (عناوين السيرفر)
        patchMemory(0x323d18c, 0xD2800020); 
        patchMemory(0x323d214, 0xD2800020); 

        // 2. تفعيل أقصى مستوى للعصا لزيادة الطول
        patchMemory(0x32c2d18, 0xD2800020); 
        patchMemory(0x32c2d1C, 0xD65F03C0); 

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad VIP"
                                                                       message:@"تم الحقن بنجاح - استمتع بالخطوط"
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
