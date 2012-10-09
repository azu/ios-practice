#import "LocalNotificationClass.h"

@implementation LocalNotificationClass

+ (void)setNotificationAtDate:(NSDate *)fireDate {
    // 通知時間 < 現在時 なら設定しない
    if (([fireDate compare:[NSDate date]] == NSOrderedAscending)){
        return;
    }
    // 設定する前に、設定済みの通知をキャンセルする
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // 設定し直す
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = @"Fire!";
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = @"OPEN";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
@end