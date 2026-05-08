#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <QuartzCore/QuartzCore.h>

// دالة الكتابة في الذاكرة (مع فحص الأمان)
void safePatch(uint64_t offset, uint32_t hexCode) {
    uintptr_t targetAddress = _dyld_get_image_vmaddr_slide(0) + offset;
    if (targetAddress < 0x100000000) return; // فحص بسيط لضمان العنوان
    
    mach_port_t task = mach_task_self();
    kern_return_t kr = vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    if (kr == KERN_SUCCESS) {
        *(uint32_t *)targetAddress = hexCode;
        vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
    }
}

// --- كود رسم الخطوط (هذا الجزء لا يسبب كراش أبداً) ---
%hook CAShapeLayer
- (void)setStrokeColor:(CGColorRef)color {
    // جعل الخط أحمر فاقع ليكون واضحاً
    CGFloat redColor[] = {1.0, 0.0, 0.0, 1.0}; 
    CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef red = CGColorCreate(rgbSpace, redColor);
    %orig(red);
    CGColorRelease(red);
    CGColorSpaceRelease(rgbSpace);
}

- (void)setLineWidth:(CGFloat)width {
    %orig(3.5); // زيادة السمك ليصبح واضحاً جداً
}

- (void)setLineDashPattern:(NSArray *)pattern {
    // إلغاء النقاط المقطعة (النقط) وجعل الخط مستمر (solid line)
    %orig(nil); 
}
%end

%ctor {
    // تأخير الحقن لضمان تشغيل اللعبة بالكامل (30 ثانية أضمن للكراش)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // سنكتفي حالياً بتفعيل ميزة الـ MaxLevel فقط لأنها هي الأضمن للطول
        // حذفنا العناوين القديمة التي سببت الكراش (323d18c و 323d214)
        safePatch(0x32c2d18, 0xD2800020); 
        safePatch(0x32c2d1C, 0xD65F03C0); 

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Fix"
                                                                       message:@"تم الحقن الآمن - جرب الخطوط الآن"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
