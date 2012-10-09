ローカル通知の設定について
==============================================================

``UILocalNotification`` を使ったローカル通知の設定方法について

設定済みの通知をキャンセルしてから設定し直す
--------------------------------------------------------------

ローカル通知が重複して登録されてしまうことがあるため、基本的に設定済みのローカル通知をキャンセルしてから
通知を設定し直した方が管理が楽になります。(複数の通知がある場合はそれを設定し直す)

.. code-block:: objc

	[[UIApplication sharedApplication] cancelAllLocalNotifications];

ローカル通知の設定は同期的に行われるので大量に設定する場合は、dispatch_async等を使い、
UIが固まらないように設定するといいです。

.. code-block:: objc

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 通知を設定する処理
        // [self setManyNotifitions];
        dispatch_async(dispatch_get_main_queue(), ^{
            /* メインスレッドでのみ実行可能な処理 */
        });
    });

通知の発火時間をチェックしてから通知の設定を行う
--------------------------------------------------------------

ローカル通知を設定する際は、必ず通知の ``fireData`` プロパティが、現在時間より後なのかを
確認してから設定するべきです。

現在時間より前に通知を設定すると、設定した瞬間に通知が発火してしまいます。

:file:`/Code/ios-practice/notification/LocalNotificationClass.m`

.. literalinclude:: /Code/ios-practice/notification/LocalNotificationClass.m
  :language: objc

