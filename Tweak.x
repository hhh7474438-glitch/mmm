#import <UIKit/UIKit.h>

%ctor {
    // رابط سيرفرك الـ Ubuntu
    NSString *urlStr = @"http://185.239.236.110:5000/verify?key=HUSSEIN-2026";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:15.0];

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    // استخدام الدالة نفسها مع تجاهل التحذير عبر Makefile
    NSData *oData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if (error || !oData) {
        // في حال فشل الاتصال بالسيرفر، تغلق اللعبة حمايةً لها
        exit(0);
    }

    NSString *res = [[NSString alloc] initWithData:oData encoding:NSUTF8StringEncoding];

    // يجب أن يرسل السيرفر نص يحتوي على "OK_UNLOCKED"
    if ([res containsString:@"OK_UNLOCKED"]) {
        NSLog(@"[Follwerk] Access Granted!");
    } else {
        exit(0);
    }
}
