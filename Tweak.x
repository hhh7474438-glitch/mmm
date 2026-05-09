#import <UIKit/UIKit.h>

// تعريف مفاتيح الحفظ
#define kAntiDelete @"hussein_anti_delete"
#define kGhostMode @"hussein_ghost_mode"
#define kViewOnce @"hussein_view_once"

// --- القسم الأول: واجهة الإعدادات (UI) ---

%hook ItemListSettingsController

- (void)viewDidLoad {
    %orig;
    
    // إضافة زر "أدوات حسين سعد" في أعلى القائمة لتجنب الكراش مع الأقسام المعقدة
    UIBarButtonItem *husseinBtn = [[UIBarButtonItem alloc] initWithTitle:@"⚙️ أدوات حسين" 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:self 
                                                                  action:@selector(openHusseinSettings)];
    self.navigationItem.rightBarButtonItem = husseinBtn;
}

%new
- (void)openHusseinSettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🚀 أدوات حسين سعد" 
                                                                   message:@"تحكم بميزات التيليجرام المعدلة" 
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    // دالة مساعدة لتبديل الحالة
    auto addToggle = ^(NSString *title, NSString *key) {
        BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        NSString *label = [NSString stringWithFormat:@"%@: %@", title, status ? @"✅ مشغل" : @"❌ مطفأ"];
        [alert addAction:[UIAlertAction actionWithTitle:label style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setBool:!status forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // تنبيه بضرورة إعادة التشغيل
            exit(0); 
        }]];
    };

    addToggle(@"قراءة الرسائل المحذوفة", kAntiDelete);
    addToggle(@"وضع الشبح (إخفاء القراءة)", kGhostMode);
    addToggle(@"مشاهدة الميديا المؤقتة", kViewOnce);

    [alert addAction:[UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
%end

// --- القسم الثاني: تفعيل الميزات (Logic) ---

// 1. منع حذف الرسائل
%hook TGMessage
- (BOOL)isDeleted {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kAntiDelete]) {
        return NO; 
    }
    return %orig;
}
%end

// 2. وضع الشبح (منع إرسال "تمت القراءة")
%hook TGHistoryRead
- (void)markAsRead:(id)arg1 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kGhostMode]) {
        return; // تجاهل أمر القراءة
    }
    %orig;
}
%end

// 3. كسر حماية الميديا لمرة واحدة (View Once)
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
