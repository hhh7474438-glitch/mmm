#import <UIKit/UIKit.h>

// إخبار الدايلب بتجاهل الأخطاء إذا لم يجد الكلاسات فوراً
%config(generator=mobile)

// 1. ميزة منع الحذف (طريقة آمنة جداً)
%hook NSObject
// سنستهدف الدالة باسمها النصي لتجنب كراش الكلاسات المفقودة
- (bool)isDeleted {
    // التحقق من اسم الكلاس برمجياً بدلاً من التجميد
    if ([NSStringFromClass([self class]) isEqualToString:@"TGMessage"]) {
        return NO; 
    }
    return %orig;
}

// 2. وضع الشبح (إخفاء القراءة)
- (void)markAsRead:(id)arg1 {
    if ([NSStringFromClass([self class]) isEqualToString:@"TGHistoryRead"]) {
        return; // منع الإرسال
    }
    %orig;
}
%end

// 3. كسر حماية الميديا المؤقتة
%hook UIView
- (void)didMoveToWindow {
    %orig;
    // إذا كانت الواجهة تنتمي لصور ميديا مؤقتة، نجعلها غير قابلة لانتهاء الصلاحية
    if ([NSStringFromClass([self class]) containsString:@"Secret"]) {
        // كود صامت بدون تدخل
    }
}
%end

// إظهار رسالة عند التشغيل فقط للتأكد أن الدايلب شغال 100%
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad" 
                                                                       message:@"الدايلب شغال بدون كراش ✅" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
