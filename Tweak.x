#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// دالة كتابة البيانات في الذاكرة بأمان
void patchMemory(uint64_t offset, uint32_t hexCode) {
    // حساب العنوان الحقيقي (العنوان الافتراضي + السلايد الخاص بالرام)
    uintptr_t targetAddress = _dyld_get_image_vmaddr_slide(0) + offset;
    
    kern_return_t err;
    mach_port_t task = mach_task_self();
    
    // 1. السماح بالكتابة على هذا العنوان (فك القفل)
    err = vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    
    if (err == KERN_SUCCESS) {
        // 2. كتابة القيمة الجديدة (الهاك)
        *(uint32_t *)targetAddress = hexCode;
        
        // 3. إعادة الحماية لوضعها الأصلي (قفل) لضمان عدم حدوث كراش
        vm_protect(task, (vm_address_t)targetAddress, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
    }
}

%ctor {
    // الانتظار 15 ثانية (مهم جداً) حتى تتجاوز اللعبة مرحلة التشغيل وفك التشفير
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /* تنبيه: العناوين أدناه (0x100XXXXXX) هي أمثلة. 
           يجب استبدالها بالعناوين الحقيقية من ملف u.txt أو من مواقع الأوفست.
        */

        // 1. هاك الخطوط الطويلة لكل الكرات
        // القيمة 0xD503201F في ARM تعني "NOP" (تعطيل التحقق من طول الخط)
        // patchMemory(0xالعنوان_هنا, 0xD503201F); 

        // 2. هاك الدقة القصوى (تحريك الخطوط مع القوة)
        // القيمة 0x52800000 تعني "جعل المسار دائماً True"
        // patchMemory(0xالعنوان_هنا, 0x52800000);

        // إظهار رسالة بسيطة للتأكد أن الهاك اشتغل في الذاكرة
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Hack"
                                                                       message:@"تم حقن الذاكرة بنجاح!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
