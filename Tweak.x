#import <UIKit/UIKit.h>

// تعريف المفاتيح
#define kAntiDelete @"hussein_anti_delete"
#define kGhostMode @"hussein_ghost_mode"
#define kViewOnce @"hussein_view_once"

// حقن القائمة عن طريق "هز الهاتف" لضمان عدم حدوث كراش في الواجهة
%hook UIWindow
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🚀 أدوات حسين سعد" 
                                                                       message:@"تحكم بالميزات (سيتم إغلاق التطبيق لحفظ التغييرات)" 
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        auto addAction = ^(NSString *title, NSString *key) {
            BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:key];
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@: %@", title, status ? @"✅" : @"❌"] 
                                                      style:UIAlertActionStyleDefault 
                                                    handler:^(UIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] setBool:!status forKey:key];
                [[NSUserDefaults standardUserDefaults] synchronize];
                exit(0); 
            }]];
        };

        addAction(@"منع حذف الرسائل", kAntiDelete);
        addAction(@"وضع الشبح", kGhostMode);
        addAction(@"الميديا المؤقتة", kViewOnce);

        [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
        
        [[ViewUtils TopViewController] presentViewController:alert animated:YES completion:nil];
    }
    %orig;
}
%end

// --- ميزات المنطق (Logic) - تم تبسيطها لتجنب الكراش ---
%hook TGMessage
- (id)isDeleted { 
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kAntiDelete]) return nil;
    return %orig;
}
%end
