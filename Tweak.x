#import <UIKit/UIKit.h>

// تعريف الكلاسات لتجنب أخطاء التجميع
@interface TGMessage : NSObject
- (bool)isDeleted;
@end

@interface TGHistoryRead : NSObject
- (void)markAsRead:(id)arg1;
@end

// --- ميزات المنطق (Logic) ---

%hook TGMessage
- (bool)isDeleted {
    return NO; // منع الحذف
}
%end

%hook TGHistoryRead
- (void)markAsRead:(id)arg1 {
    return; // وضع الشبح
}
%end

%hook TGVideoMessageAction
- (bool)isExpired { return NO; }
%end

%hook TGPhotoMessageAction
- (bool)isExpired { return NO; }
%end

// --- إشعار التشغيل الآمن ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // الطريقة الصحيحة والمصلحة لجلب النافذة (بدون أخطاء)
        UIWindow *window = nil;
        NSArray *windows = [[UIApplication sharedApplication] windows];
        if (windows.count > 0) {
            window = [windows firstObject];
        }
        
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hussein Saad" 
                                                                           message:@"🚀 تم تفعيل أدوات حسين بنجاح!\n(منع حذف + شبح + ميديا)" 
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
            
            // العرض فوق أعلى ViewController متاح
            UIViewController *topController = window.rootViewController;
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            [topController presentViewController:alert animated:YES completion:nil];
        }
    });
}
