#import <UIKit/UIKit.h>

%ctor {
    // رابط سيرفرك الـ Ubuntu (تأكد إنه شغال)
    NSString *urlStr = @"http://185.239.236.110:5000/verify?key=HUSSEIN-2026";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:15.0]; // مهلة 15 ثانية للرد

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    NSData *oData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if (error) {
        // إذا السيرفر طافي أو ماكو إنترنت
        exit(0);
    }

    NSString *res = [[NSString alloc] initWithData:oData encoding:NSUTF8StringEncoding];

    if ([res containsString:@"OK_UNLOCKED"]) {
        NSLog(@"[Follwerk] Access Granted!");
    } else {
        // إذا الكود غلط أو السيرفر رد بالرفض
        exit(0);
    }
}
