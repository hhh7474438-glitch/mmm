#import <UIKit/UIKit.h>

// --- واجهة الإعدادات ---
@interface JokdSettingsViewController : UIViewController
@end

@implementation JokdSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    titleLabel.text = @"إعدادات jokdinstagram";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    // ملاحظة: هنا يتم إضافة UISwitch لكل ميزة (Media, Privacy, UI)
    // زر الإغلاق في الأسفل
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height - 100, 100, 50);
    [closeButton setTitle:@"إغلاق" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)closeSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

// --- الأيقونة العائمة ---
static UIButton *floatingButton;

%hook IGHomeViewController
- (void)viewDidLoad {
    %orig;
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    floatingButton.backgroundColor = [UIColor purpleColor];
    floatingButton.layer.cornerRadius = 25;
    [floatingButton setTitle:@"Jokd" forState:UIControlStateNormal];
    [floatingButton addTarget:self action:@selector(openJokdSettings) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة خاصية التحريك (PanGesture) للزر
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [floatingButton addGestureRecognizer:pan];
    
    [[UIApplication sharedApplication].keyWindow addSubview:floatingButton];
}

%new
- (void)openJokdSettings {
    JokdSettingsViewController *settingsVC = [[JokdSettingsViewController alloc] init];
    settingsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingsVC animated:YES completion:nil];
}

%new
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:floatingButton.superview];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:floatingButton.superview];
}
%end

// --- الهوكات (The Hooks) ---

// 1. الترحيب
%hook IGAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)options {
    BOOL result = %orig;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحبا بك أيها المستخدم"
        message:@"في نسخة jokdinstagram\nالنسخة مطورة من hussein saad"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"TELEgram" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Start" style:UIAlertActionStyleDefault handler:nil]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    
    return result;
}
%end

// 2. إزالة الإعلانات
%hook IGFeedItem
- (BOOL)isSponsored { return NO; }
%end

// 3. إخفاء "جاري الكتابة"
%hook IGDirectTypingIndicatorService
- (void)sendTypingIndicatorForThreadId:(id)arg1 typingStatus:(id)arg2 {
    // إيقاف الإرسال
}
%end

// 4. قفل التطبيق (Passcode) - منطق بسيط
%hook IGSystemStatus
- (BOOL)isAppLocked { return YES; } 
%end
