#import <UIKit/UIKit.h>

%ctor {
    // رابط سيرفرك - يفضل تستخدم ID الجهاز مستقبلاً
    NSString *urlStr = @"http://185.239.236.110:5000/verify?key=HUSSEIN-2026";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10.0];

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    NSData *oData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    NSString *res = [[NSString alloc] initWithData:oData encoding:NSUTF8StringEncoding];

    if ([res containsString:@"OK_UNLOCKED"]) {
        NSLog(@"[Hussein Saad] Access Granted!");
    } else {
        // إظهار رسالة خطأ قبل الخروج
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Follwerk Protection" 
                message:@"Invalid Key! Please contact @znzmz to get access." 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                exit(0);
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}
