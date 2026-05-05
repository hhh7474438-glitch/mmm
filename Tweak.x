#import <UIKit/UIKit.h>

// تعريف الواجهات لتجنب خطأ الـ Forward Declaration
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

// زر عائم محسن
static UIButton *floatingButton;

%hook IGHomeViewController
- (void)viewDidLoad {
    %orig;
    
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 150, 60, 60);
    floatingButton.backgroundColor = [UIColor systemPurpleColor];
    floatingButton.layer.cornerRadius = 30;
    [floatingButton setTitle:@"Jokd" forState:UIControlStateNormal];
    floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [floatingButton addTarget:self action:@selector(openJokdSettings) forControlEvents:UIControlEventTouchUpInside];
    
    // التحريك
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleJokdPan:)];
    [floatingButton addGestureRecognizer:pan];
    
    // الحل البديل لـ keyWindow المتوقف
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    window = windowScene.windows.firstObject;
                    break;
                }
            }
        }
        if (!window) window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:floatingButton];
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

// هوك الترحيب المعدل
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
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Start" style:UIAlertActionStyleCancel handler:nil]];
        
        // عرض التنبيه بطريقة متوافقة مع iOS 13+
        UIViewController *rootVC = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    rootVC = windowScene.windows.firstObject.rootViewController;
                    break;
                }
            }
        }
        if (!rootVC) rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
    
    return result;
}
%end

// ميزات الخصوصية والحساب (تعمل في الخلفية)
%hook IGFeedItem
- (BOOL)isSponsored { return NO; }
%end
