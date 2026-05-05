#import <UIKit/UIKit.h>

// تعريف الواجهات لتجنب أخطاء التعريف المسبق
@interface IGHomeViewController : UIViewController
- (void)openJokdSettings;
@end

@interface JokdSettingsViewController : UIViewController
@end

@implementation JokdSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 40)];
    titleLabel.text = @"إعدادات jokdinstagram";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake((self.view.frame.size.width - 120) / 2, self.view.frame.size.height - 100, 120, 50);
    [closeButton setTitle:@"إغلاق القائمة" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)closeSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

static UIButton *floatingButton;

%hook IGHomeViewController
- (void)viewDidLoad {
    %orig;
    
    // إنشاء الزر العائم
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 150, 60, 60);
    floatingButton.backgroundColor = [UIColor systemPurpleColor];
    floatingButton.layer.cornerRadius = 30;
    [floatingButton setTitle:@"Jokd" forState:UIControlStateNormal];
    floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [floatingButton addTarget:self action:@selector(openJokdSettings) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة ميزة السحب (Pan Gesture)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleJokdPan:)];
    [floatingButton addGestureRecognizer:pan];
    
    // الطريقة الحديثة لإضافة الزر على الشاشة بدون keyWindow
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                [windowScene.windows.firstObject addSubview:floatingButton];
                break;
            }
        }
    });
}

%new
- (void)openJokdSettings {
    JokdSettingsViewController *settingsVC = [[JokdSettingsViewController alloc] init];
    settingsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingsVC animated:YES completion:nil];
}

%new
- (void)handleJokdPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:sender.view.superview];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:sender.view.superview];
}
%end

// هوك الترحيب عند تشغيل التطبيق
%hook IGAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)options {
    BOOL result = %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"مرحبا بك"
            message:@"نسخة jokdinstagram\nبواسطة حسين سعد"
            preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"TELEgram" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleCancel handler:nil]];
        
        // عرض التنبيه باستخدام الـ Scene النشط
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                [windowScene.windows.firstObject.rootViewController presentViewController:alert animated:YES completion:nil];
                break;
            }
        }
    });
    
    return result;
}
%end

// ميزة إخفاء الإعلانات
%hook IGFeedItem
- (BOOL)isSponsored { return NO; }
%end
