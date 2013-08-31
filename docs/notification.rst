UILocalNotificationを使った通知の設定について
==============================================================

``UILocalNotification`` を使ったローカル通知の設定方法について

設定済みの通知をキャンセルしてから設定し直す
--------------------------------------------------------------

ローカル通知が重複して登録されてしまうことがあるため、基本的に設定済みのローカル通知をキャンセルしてから
通知を設定し直した方が管理が楽になります。(複数の通知がある場合はそれを設定し直す)

.. code-block:: objc

	[[UIApplication sharedApplication] cancelAllLocalNotifications];

通知を設定する期間の問題
--------------------------------------------------------------

アプリによって設定する通知は時間や繰り返しなど様々だと思いますが、
遠い未来や無限に繰り返す内容の通知をそのまま設定するのは無理がでてきます。

そのため、現在の情報をもとに1週間から1ヶ月程度の範囲に通知だけを設定する等の制限を設けたほうがいいと思います。
(これは上記の毎回キャンセルしてから設定するのと相性がいいです)

そして、アプリを起動 or 終了 した時などに、通知を設定し直すことで、
ずっと放置してる場合は通知がでなくなりますが、使っている人に対しては通知が継続されるような仕組みが自然とできると思います。


通知の発火時間をチェックしてから通知の設定を行う
--------------------------------------------------------------

ローカル通知を設定する際は、必ず通知の ``fireDate`` プロパティが、現在時間より後なのかを
確認してから設定するべきです。

現在時間より前に通知を設定すると、設定した瞬間に通知が発火してしまいます。

:file:`/Code/ios-practice/LocalNotification/LocalNotificationManager.m`

.. literalinclude:: /Code/ios-practice/LocalNotification/LocalNotificationManager.m
  :language: objc



通知を設定するのはいつ?
-----------------------------------------------------------------

ローカル通知は必ず、通知を管理するクラスを経由して設定すべきですが、
いつ設定するのがいいのかという問題もあります。
(毎回、UILocalNotificationを書くのはバッドプラクティスだと思います)

データを保存した際に通知を設定すると、保存するコードごとに通知について書かないといけなくなる事や、
"設定済みの通知をキャンセルしてから設定し直す" というパターンとも相性があまり良くありません。

比較的シンプルに書けるのが、アプリがバックグラウンドに行く時に設定するパターンです。

.. code-block:: objc

    - (void)applicationDidEnterBackground:(UIApplication *)application {
        // 通知の設定クラスを呼び出す
    }

メリットとしては、同期的に通知を設定してもUIスレッドに対しての影響が少ない事や、
アプリのライフサイクル的に、大体の場合はここを通るので、保存するごとに通知を設定しないで、
``applicationDidEnterBackground`` のみで設定すればよくなるためコードもシンプルになります。

デメリットとして、アプリ表示中にローカル通知を受け取って表示する( ``application:didReceiveRemoteNotification:`` )など、
保存した時にローカル通知を付けないといけないような条件があるときには利用できないパターンです。

別スレッドで通知を設定する場合
-----------------------------------------------------------------

ローカル通知の設定は同期的に行われるので大量に設定する場合は、dispatch_async等を使い、
UIが固まらないように設定すればいいです。

.. code-block:: objc

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 通知を設定する処理
        dispatch_async(dispatch_get_main_queue(), ^{
            /* メインスレッドでのみ実行可能な処理 */
        });
    });

しかし、別スレッドで設定する際、通知を設定する基準を決めるデータを取るために、
CoreData等スレッドセーフではないもの等を触る時に問題が起きやすいことがあります。

そのような場合は、同期的に設定できてUIスレッドを意識しないでシンプルに行える、アプリがバックグラウンドに移行する時がお手軽です。

通知登録の管理クラス
-----------------------------------------------------------------

実際に動かせるサンプルプロジェクトは以下にあります。
(通知登録のテストについても書いてあるので、ここにでてくるものとは少し違います)

.. seealso::

    `azu/LocalNotificationPattern`_
        これまででてきたパターンを使った通知登録管理クラスのサンプルプロジェクト


ローカル通知は一箇所にまとめておくと見通しがよく管理がしやすくなります。
これまで、でてきたパターンをまとめたようなクラス ``LocalNotificationManager`` というものを見てみます。

.. code-block:: objc

    @interface LocalNotificationManager : NSObject
    // ローカル通知を登録する
    - (void)scheduleLocalNotifications;
    @end

    @implementation LocalNotificationManager
    #pragma mark - Scheduler
    - (void)scheduleLocalNotifications {
        // 一度通知を全てキャンセルする
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        // 通知を設定していく...
        [self scheduleWeeklyWork];
    }

    // 例: weeklyWorkSchedule の時間を通知登録する
    - (void)scheduleWeeklyWork {
        // ...
        // makeNotification: を呼び出して通知を登録する
    }

    #pragma mark - helper
    - (void)makeNotification:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo {
        // 現在より前の通知は設定しない
        if (fireDate == nil || [fireDate timeIntervalSinceNow] <= 0) {
            return;
        }
        [self schedule:fireDate alertBody:alertBody userInfo:userInfo];
    }

    - (void)schedule:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo {
        // ローカル通知を作成する
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        [notification setFireDate:fireDate];
        [notification setTimeZone:[NSTimeZone systemTimeZone]];
        [notification setAlertBody:alertBody];
        [notification setUserInfo:userInfo];
        [notification setSoundName:UILocalNotificationDefaultSoundName];
        [notification setAlertAction:@"Open"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    @end

``AppDelegate`` から以下のようにバックグラウンドへ移行する際に呼び出して使います。

.. code-block:: objc

    - (void)applicationDidEnterBackground:(UIApplication *) application {
        // バックグラウンドに移行際に通知を設定する
        LocalNotificationManager *notificationManager = [[LocalNotificationManager alloc] init];
        [notificationManager scheduleLocalNotifications];
    }


``- (void)scheduleLocalNotifications;`` を呼び出すと、まず全ての通知をキャンセルしてから通知を登録していくようになっています。

それぞれの通知は、種類ごとなどでメソッドにまとめておくとテストがしやすくなると思います。
また、実際に通知を登録するときは ``- (void)makeNotification:(NSDate *) fireDate`` を経由して、
通知の登録時間が過去になってないかをチェックしてから登録するようにしています。

ローカル通知登録のテストについて
============================================================================

``UILocalNotification`` は名前に ``UI`` とついてるように、ロジックテストだと通知が登録出来ないためテストがしにくくなっています。

アプリケーションテストの場合は動作します。
(現在のXcodeはアプリケーションテストがデフォルトなので、あまり問題ないのかもしれませんが)

.. seealso::

    `iOS Unit Test <http://azu.github.io/slide/OCStudy/ios_unit_test.html#slide1>`_
        ロジックテストとアプリケーションテストの違いについて

それでも、ここはモックなりで潰してコントロールできたほうが嬉しいので、
以下のような通知を登録したふりをするspyとなるクラスを作ります。

実際のサンプルは `azu/LocalNotificationPattern`_ を見て下さい。

.. code-block:: objc

    // テスト用にLocalNotificationManagerを継承したモッククラスを作る
    @interface LocationNotificationManagerSpy : LocalNotificationManager
    @property(nonatomic) NSMutableArray *schedules;
    // helper
    - (UILocalNotification *)notificationAtIndex:(NSUInteger) index;
    // overwrite
    - (void)schedule:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo;
    @end

    @implementation LocationNotificationManagerSpy
    - (NSMutableArray *)schedules {
        if (_schedules == nil) {
            _schedules = [NSMutableArray array];
        }
        return _schedules;
    }

    - (UILocalNotification *)notificationAtIndex:(NSUInteger) index {
        if (index < [self.schedules count]) {
            return self.schedules[index];
        }
        return nil;
    }

    // 通知を登録するメソッドを乗っ取り、呼ばれたことを記録する(いわゆるspy)
    - (void)schedule:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = fireDate;
        notification.alertBody = alertBody;
        notification.userInfo = userInfo;
        [self.schedules addObject:notification];
    }
    @end

実際にテストを行う際には、 ``LocalNotificationManager`` ではなく、
それを継承した ``LocationNotificationManagerSpy`` を使うことで、通知登録が呼ばれたことを記録できるようになります。


ローカル通知のテストケース
-----------------------------------------------------------------

先ほどの、 `LocalNotificationManager.m <https://github.com/azu/LocalNotificationPattern/blob/master/LocalNotificationPattern/LocalNotificationManager/LocalNotificationManager.m>`_ では、
実装されていなかった実際の登録内容を決める ``- (void)scheduleWeeklyWork`` を以下のように実装します。

``[self.scheduleDataSource weeklyWorkSchedule];`` を呼び出す事で、 NSDateの配列を返してくれるようにして、
それをスケジュールを登録するという感じになっています。

.. code-block:: objc

    // 例: weeklyWorkSchedule の時間を通知登録する
    - (void)scheduleWeeklyWork {
        // NSDateの配列が返ってくる
        NSArray *schedules = [self.scheduleDataSource weeklyWorkSchedule];
        for (NSDate *date in schedules) {
            [self makeNotification:date alertBody:@"Work Schedule" userInfo:@{
                @"key" : LocalNotification.weeklyWork
            }];
        }
    }

テストする際には、 ``[self.scheduleDataSource weeklyWorkSchedule]`` をテストコード内で、
モックにすり替えればいいので、以下のようにOCMockObjectを使って、 ``self.scheduleDataSource`` をモックに変更しています。

.. note::

    userInfo に 通知の種類毎のkeyを指定する事で、どの通知から起動したのかを判別することができる

こうすることで、テスト時に任意の NSDate を通知登録させられるのでテスト側から制御しやすくなります。


.. code-block:: objc

    @implementation LocalNotificationManagerTest {
    }
    - (void)setUp {
        [super setUp];
        self.managerSpy = [[LocationNotificationManagerSpy alloc] init];
    }

    - (void)tearDown {
        self.managerSpy = nil;
        [super tearDown];
    }

    - (void)testWeeklyWorkSchedule {
        // 通知に登録される日付オブジェクト
        NSDate *expectedDate = [[NSDate date] dateByAddingDays:5];
        NSArray *expectedScheduleDates = @[
            expectedDate
        ];
        // データソースをモックに差し替える
        id dataSourceMock = [OCMockObject mockForClass:[ExampleScheduleDataSource class]];
        [[[dataSourceMock stub] andReturn:expectedScheduleDates] weeklyWorkSchedule];
        self.managerSpy.scheduleDataSource = dataSourceMock;
        // 通知を登録
        [self.managerSpy scheduleLocalNotifications];
        // 期待するもの
        // self.managerSpy.schedules には登録されるUILocalNotificationが入る
        for (UILocalNotification *localNotification in self.managerSpy.schedules) {
            STAssertEquals(localNotification.fireDate, expectedDate,
            @"通知に登録されたものはexpectedDateである");
        }
    }
    @end

LocationNotificationManagerSpy には ``self.managerSpy.schedules`` というように、
通知登録した内容を記録するプロパティがあるので、これの中身を検証すれば、ロジックテストからも ``UILocalNotification`` のテストが行えます。

.. seealso::

    `Intro to Objective-C TDD [Screencast] - Quality Coding <http://qualitycoding.org/objective-c-tdd/>`_
        今回のようなプロパティで依存するDataSourceを注入してモックですり替える方法について詳しく解説した動画

.. _`azu/LocalNotificationPattern`: https://github.com/azu/LocalNotificationPattern