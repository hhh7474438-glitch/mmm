#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <QuartzCore/QuartzCore.h>

// دالة تعديل الذاكرة الآمنة
void patchMemory(uint64_t offset, uint32_t hexCode) {
    uintptr_t targetAddress = _dyld_get_image_vmaddr_slide(0) + offset;
    kern_return_t err;
    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(uint32_t *)targetAddress = hexCode;
    vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
}

// --- كود تلوين وتوضيح الخط ---
%hook CAShapeLayer
- (void)setStrokeColor:(CGColorRef)color {
    // جعل الخط بلون أحمر فاقع (تقدر تغيره لـ الأخضر أو أي لون)
    CGFloat redColor[] = {1.0, 0.0, 0.0, 1.0}; 
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef red = CGColorCreate(rgbSpace, redColor);
    %orig(red);
}

- (void)setLineWidth:(CGFloat)width {
    // جعل الخط سميك (3.0) بدلاً من النحيف ليكون واضحاً جداً
    %orig(3.0);
}
%end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 1. تفعيل حسابات الاصطدام (من نتائج السيرفر الأولى)
        patchMemory(0x323d18c, 0xD2800020); // BallLineCollision -> Return True
        patchMemory(0x323d214, 0xD2800020); // BallBallCollision -> Return True

        // 2. تفعيل "أقصى مستوى للعصا" (من نتائج السيرفر الثانية)
        // هذا العنوان يجعل اللعبة تعتقد أن العصا ليفل ماكس ليعطيك أطول خط مسموح به
        patchMemory(0x32c2d18, 0xD2800020); // IsCueAtMaxLevel -> Return True
        patchMemory(0x32c2d1C, 0xD65F03C0); // RET

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad VIP"
                                                                       message:@"تم تفعيل الخطوط الحمراء الطويلة بنجاح"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"استمتع" style:UIAlertActionStyleDefault handler:nil]];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
