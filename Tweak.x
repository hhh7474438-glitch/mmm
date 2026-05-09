#import <UIKit/UIKit.h>

// إخبار المترجم بوجود هذه الكلاسات ليتجنب الـ Error أثناء التجميع
@interface TGMessage : NSObject
- (bool)isDeleted;
@end

@interface TGHistoryRead : NSObject
- (void)markAsRead:(id)arg1;
@end

// --- ميزات المنطق (Logic) تعمل تلقائياً وبصمت لضمان 0% كراش ---

%hook TGMessage
- (bool)isDeleted {
    // منع حذف الرسائل دائماً
    return NO;
}
%end

%hook TGHistoryRead
- (void)markAsRead:(id)arg1 {
    // وضع الشبح: منع إرسال إشارة القراءة
    return;
}
%end

// ميزة الميديا المؤقتة (View Once)
%hook TGVideoMessageAction
- (bool)isExpired { return NO; }
%end

%hook TGPhotoMessageAction
- (bool)isExpired { return NO; }
%end

// --- إشعار عند التشغيل للتأكد من عمل الدايلب ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // الحصول على النافذة الرئيسية بطريقة متوافقة مع كل الإصدارات
        UIWindow *window = nil;
        if ([[UIApplication sharedApplication] windows].count > 0) {
            window = [[UIApplication sharedApplication] windows] firstObject;
        }
        
        if (window) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad" 
                                                                           message:@"🚀 تم تفعيل أدوات حسين (منع الحذف + الشبح + الميديا) بنجاح!" 
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}
