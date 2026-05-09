#import <UIKit/UIKit.h>

// تعريف المفاتيح
#define kAntiDelete @"hussein_anti_delete"
#define kGhostMode @"hussein_ghost_mode"
#define kViewOnce @"hussein_view_once"

// إخبار المترجم أن هذا الكلاس هو ViewController
@interface ItemListSettingsController : UIViewController
- (void)openHusseinSettings;
@end

// --- القسم الأول: واجهة الإعدادات ---

%hook ItemListSettingsController

- (void)viewDidLoad {
    %orig;
    
    // إضافة الزر في اليمين
    UIBarButtonItem *husseinBtn = [[UIBarButtonItem alloc] initWithTitle:@"⚙️ أدوات حسين" 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:self 
                                                                  action:@selector(openHusseinSettings)];
    self.navigationItem.rightBarButtonItem = husseinBtn;
}

%new
- (void)openHusseinSettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🚀 أدوات حسين سعد" 
                                                                   message:@"تحكم بميزات التيليجرام" 
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    // ميزة 1: منع الحذف
    BOOL status1 = [[NSUserDefaults standardUserDefaults] boolForKey:kAntiDelete];
    [alert addAction:[UIAlertAction actionWithTitle:(status1 ? @"✅ منع الحذف: مشغل" : @"❌ منع الحذف: مطفأ") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setBool:!status1 forKey:kAntiDelete];
        exit(0);
    }]];

    // ميزة 2: وضع الشبح
    BOOL status2 = [[NSUserDefaults standardUserDefaults] boolForKey:kGhostMode];
    [alert addAction:[UIAlertAction actionWithTitle:(status2 ? @"✅ وضع الشبح: مشغل" : @"❌ وضع الشبح: مطفأ") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setBool:!status2 forKey:kGhostMode];
        exit(0);
    }]];

    // ميزة 3: ميديا مؤقتة
    BOOL status3 = [[NSUserDefaults standardUserDefaults] boolForKey:kViewOnce];
    [alert addAction:[UIAlertAction actionWithTitle:(status3 ? @"✅ ميديا مؤقتة: مشغل" : @"❌ ميديا مؤقتة: مطفأ") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setBool:!status3 forKey:kViewOnce];
        exit(0);
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
%end

// --- القسم الثاني: المنطق البرمجي (Logic) ---

%hook TGMessage
- (BOOL)isDeleted {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kAntiDelete]) {
        return NO; 
    }
    return %orig;
}
%end

%hook TGHistoryRead
- (void)markAsRead:(id)arg1 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kGhostMode]) {
        return;
    }
    %orig;
}
%end

%hook TGVideoMessageAction
- (BOOL)isExpired {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kViewOnce]) {
        return NO;
    }
    return %orig;
}
%end

%hook TGPhotoMessageAction
- (BOOL)isExpired {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kViewOnce]) {
        return NO;
    }
    return %orig;
}
%end
