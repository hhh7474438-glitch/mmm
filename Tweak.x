#import <UIKit/UIKit.h>

// --- 1. تعريف الكلاسات ليعرف المترجم وظائفها ---
@interface IGHomeViewController : UIViewController
- (void)openSettings;
@end

@interface IGDirectVisualMessage : NSObject
- (BOOL)isExpired;
- (BOOL)canViewAgain;
@end

// --- 2. واجهة الإعدادات الاحترافية ---
@interface JokdSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JokdSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 40)];
    header.text = @"إعدادات JokdInstagram";
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:header];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 80, self.view.frame.size.width - 40, 50)];
    closeBtn.backgroundColor = [UIColor systemPurpleColor];
    closeBtn.layer.cornerRadius = 15;
    [closeBtn setTitle:@"إغلاق" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}
- (void)dismiss { [self dismissViewControllerAnimated:YES completion:nil]; }
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return 4; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.textColor = [UIColor whiteColor];
    NSArray *titles = @[@"رؤية الرسائل المؤقتة", @"إخفاء الإعلانات", @"تعطيل جاري الكتابة", @"تفعيل زر التحميل"];
    c.textLabel.text = titles[ip.row];
    UISwitch *sw = [[UISwitch alloc] init]; [sw setOn:YES];
    c.accessoryView = sw;
    return c;
}
@end

// --- 3. الهوكات الأساسية وحل مشكلة الكراش ---
static UIButton *jokdBtn;

%hook IGHomeViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if (!jokdBtn) {
        jokdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jokdBtn.frame = CGRectMake(30, 150, 60, 60);
        jokdBtn.backgroundColor = [UIColor systemPurpleColor];
        jokdBtn.layer.cornerRadius = 30;
        [jokdBtn setTitle:@"Jokd" forState:UIControlStateNormal];
        [jokdBtn addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [jokdBtn addGestureRecognizer:p];
    }
    
    // إضافة الزر للنافذة بأمان
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                win = s.windows.firstObject; break;
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
    // تم حل الخطأ هنا عبر تعريف IGHomeViewController كـ UIViewController في البداية
    [self presentViewController:svc animated:YES completion:nil];
}

%new
- (void)drag:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:g.view.superview];
    g.view.center = CGPointMake(g.view.center.x + t.x, g.view.center.y + t.y);
    [g setTranslation:CGPointZero inView:g.view.superview];
}
%end

// --- 4. ميزات الخصوصية ومنع الإعلانات ---
%hook IGDirectVisualMessage
- (BOOL)isExpired { return NO; }
- (BOOL)canViewAgain { return YES; }
%end

%hook IGFeedItem
- (BOOL)isSponsored { return NO; }
%end
