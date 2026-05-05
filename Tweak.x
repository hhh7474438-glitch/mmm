#import <UIKit/UIKit.h>

// --- تعريفات الواجهات لضمان عدم وجود أخطاء مترجم ---
@interface IGMedia : NSObject
@property (nonatomic, readonly) NSURL *videoConfig; // مثال لتبسيط الوصول للرابط
@end

@interface IGDirectVisualMessage : NSObject
@end

// --- واجهة الإعدادات ---
@interface JokdSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JokdSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    header.text = @"إعدادات JokdInstagram";
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:header];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 220)];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 80, self.view.frame.size.width - 40, 50)];
    exitBtn.backgroundColor = [UIColor systemRedColor];
    exitBtn.layer.cornerRadius = 12;
    [exitBtn setTitle:@"إغلاق" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
}
- (void)dismiss { [self dismissViewControllerAnimated:YES completion:nil]; }
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return 5; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.textColor = [UIColor whiteColor];
    NSArray *titles = @[@"حفظ الوسائط تلقائياً", @"مشاهدة الرسائل المؤقتة بلا حدود", @"إخفاء الإعلانات", @"حفظ الستوري", @"تعطيل جاري الكتابة"];
    c.textLabel.text = titles[ip.row];
    UISwitch *sith = [[UISwitch alloc] init];
    [sith setOn:YES];
    c.accessoryView = sith;
    return c;
}
@end

// --- الهوكات الأساسية ---

static UIButton *jokdBtn;

%hook IGHomeViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if (!jokdBtn) {
        jokdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jokdBtn.frame = CGRectMake(20, 120, 55, 55);
        jokdBtn.backgroundColor = [UIColor systemPurpleColor];
        jokdBtn.layer.cornerRadius = 27.5;
        [jokdBtn setTitle:@"Jokd" forState:UIControlStateNormal];
        [jokdBtn addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [jokdBtn addGestureRecognizer:p];
    }
    
    // إضافة الزر بأمان للـ Window الرئيسي
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                win = s.windows.firstObject;
                break;
            }
        }
        if (win && ![win.subviews containsObject:jokdBtn]) {
            [win addSubview:jokdBtn];
        }
    });
}

%new
- (void)openSettings {
    JokdSettingsViewController *svc = [[JokdSettingsViewController alloc] init];
    svc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:svc animated:YES completion:nil];
}

%new
- (void)drag:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:g.view.superview];
    g.view.center = CGPointMake(g.view.center.x + t.x, g.view.center.y + t.y);
    [g setTranslation:CGPointZero inView:g.view.superview];
}
%end

// --- ميزة رؤية الرسائل المؤقتة بلا حدود ---
%hook IGDirectVisualMessage
- (BOOL)isExpired {
    return NO; // الرسالة لن تنتهي أبداً وتستطيع رؤيتها دائماً
}
- (BOOL)canViewAgain {
    return YES; // السماح بإعادة الرؤية
}
%end

// --- ميزة منع الإعلانات ---
%hook IGFeedItem
- (BOOL)isSponsored { return NO; }
%end

// --- الترحيب الآمن ---
%hook IGAppDelegate
- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(id)opt {
    BOOL r = %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"JokdInstagram" 
            message:@"مرحباً بك حسين سعد\nالنسخة تعمل الآن بدون جيلبريك" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Start" style:UIAlertActionStyleCancel handler:nil]];
        
        UIWindow *keyWin = nil;
        for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                keyWin = s.windows.firstObject; break;
            }
        }
        [keyWin.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    return r;
}
%end
