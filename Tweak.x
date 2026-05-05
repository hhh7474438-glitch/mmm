#import <UIKit/UIKit.h>

// --- تعريف الواجهات (Interfaces) ---
@interface IGHomeViewController : UIViewController
- (void)openJokdSettings;
@end

@interface JokdSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *features;
@end

// --- تنفيذ واجهة الإعدادات ---
@implementation JokdSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
    
    self.features = @[
        @"تحميل الفيديوهات والصور", @"حفظ فيديوهات الـ Direct", 
        @"مشاهدة الستوري بالخفاء", @"إخفاء جاري الكتابة", 
        @"تعطيل إيصالات القراءة", @"إزالة الإعلانات", 
        @"نسخ البايو والتعليقات", @"إظهار حالة المتابعة"
    ];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 40)];
    title.text = @"إعدادات JokdInstagram";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:title];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(20, self.view.frame.size.height - 80, self.view.frame.size.width - 40, 50);
    closeBtn.backgroundColor = [UIColor systemRedColor];
    [closeBtn setTitle:@"إغلاق الإعدادات" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius = 15;
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.features.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.features[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc] init];
    cell.accessoryView = sw;
    return cell;
}

- (void)close { [self dismissViewControllerAnimated:YES completion:nil]; }
@end

// --- الهوكات (Hooks) ---

static UIButton *jokdButton;

%hook IGHomeViewController
- (void)viewDidLoad {
    %orig;
    jokdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jokdButton.frame = CGRectMake(20, 100, 60, 60);
    jokdButton.backgroundColor = [UIColor systemPurpleColor];
    jokdButton.layer.cornerRadius = 30;
    [jokdButton setTitle:@"Jokd" forState:UIControlStateNormal];
    [jokdButton addTarget:self action:@selector(openJokdSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleJPan:)];
    [jokdButton addGestureRecognizer:pan];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                [scene.windows.firstObject addSubview:jokdButton];
            }
        }
    });
}

%new
- (void)openJokdSettings {
    JokdSettingsViewController *vc = [[JokdSettingsViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

%new
- (void)handleJPan:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:p.view.superview];
    p.view.center = CGPointMake(p.view.center.x + t.x, p.view.center.y + t.y);
    [p setTranslation:CGPointZero inView:p.view.superview];
}
%end

// إخفاء الإعلانات
%hook IGFeedItem
- (BOOL)isSponsored { return NO; }
%end

// رسالة الترحيب
%hook IGAppDelegate
- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(id)opt {
    BOOL r = %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"مرحباً بك" 
            message:@"نسخة jokdinstagram\nمطورة بواسطة Hussein Saad" preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:@"TELEgram" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/qmyqq"] options:@{} completionHandler:nil];
        }]];
        [a addAction:[UIAlertAction actionWithTitle:@"Start" style:UIAlertActionStyleCancel handler:nil]];
        
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                [scene.windows.firstObject.rootViewController presentViewController:a animated:YES completion:nil];
            }
        }
    });
    return r;
}
%end
