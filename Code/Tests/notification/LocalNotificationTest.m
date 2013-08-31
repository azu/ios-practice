#import <SenTestingKit/SenTestingKit.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "LocalNotificationManager.h"

@interface LocalNotificationTest : SenTestCase

@end

@implementation LocalNotificationTest

- (void)setUp {

}

- (void)tearDown {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)testSetOnce {
    NSDate *tommorowDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    [LocalNotificationManager setNotificationAtDate:tommorowDate];
    // セットしたNotificationを取り出す
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notification = [notifications objectAtIndex:0];
    NSDate *notificationDate = [notification fireDate];
    assertThat(notificationDate, equalTo(tommorowDate));
}

// 毎回リセットされてから設定されているか
- (void)testSetTwice {
    NSDate *tommorowDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    [LocalNotificationManager setNotificationAtDate:tommorowDate];
    [LocalNotificationManager setNotificationAtDate:tommorowDate];
    // セットしたNotificationを取り出す
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notification = [notifications objectAtIndex:0];
    NSDate *notificationDate = [notification fireDate];
    assertThat(notificationDate, equalTo(tommorowDate));
}

// 過去の日付には設定できない
- (void)testSetPastDate {
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24];
    [LocalNotificationManager setNotificationAtDate:yesterday];
    // セットしたNotificationを取り出す
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    assertThat(notifications, hasCountOf(0));
}
@end