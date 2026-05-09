#import <UIKit/UIKit.h>

// تعريف المفاتيح
#define kAntiDelete @"hussein_anti_delete"
#define kGhostMode @"hussein_ghost_mode"
#define kViewOnce @"hussein_view_once"

// --- كود الحصول على الشاشة الحالية لضمان عدم الكراش ---
@interface UIWindow (Hussein)
- (UIViewController *)hussein_topViewController;
@end

@implementation UIWindow (Hussein)
- (UIViewController *)hussein_topViewController {
    UIViewController *top = self.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}
@end

// --- حقن القائمة عن طريق "هز الهاتف" ---
%hook UIWindow
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🚀 أدوات حسين سعد" 
                                                                       message:@"اختر الميزة (سيتم الخروج لحفظ التغيير)" 
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        // ميزة 1
        BOOL s1 = [[NSUserDefaults standardUserDefaults] boolForKey:kAntiDelete];
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"منع الحذف: %@", s1?@"✅":@"❌"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[NSUserDefaults standardUserDefaults] setBool:!s1 forKey:kAntiDelete];
            exit(0);
        }]];

        // ميزة 2
        BOOL s2 = [[NSUserDefaults standardUserDefaults] boolForKey:kGhostMode];
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"وضع الشبح: %@", s2?@"✅":@"❌"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[NSUserDefaults standardUserDefaults] setBool:!s2 forKey:kGhostMode];
            exit(0);
        }]];

        // ميزة 3
        BOOL s3 = [[NSUserDefaults standardUserDefaults] boolForKey:kViewOnce];
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"الميديا المؤقتة: %@", s3?@"✅":@"❌"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[NSUserDefaults standardUserDefaults] setBool:!s3 forKey:kViewOnce];
            exit(0);
        }]];

        [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
        
        // استخدام الطريقة الآمنة للعرض
        [[self hussein_topViewController] presentViewController:alert animated:YES completion:nil];
    }
    %orig;
}
%end

// --- ميزات المنطق (Logic) ---
// ملاحظة: جعلناها BOOL لضمان التوافق مع دوال التيليجرام الأصلية
%hook TGMessage
- (bool)isDeleted { 
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kAntiDelete]) return NO;
    return %orig;
}
%end

%hook TGHistoryRead
- (void)markAsRead:(id)arg1 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kGhostMode]) return;
    %orig;
}
%end
