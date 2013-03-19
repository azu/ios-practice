StoryBoardの使用
======================================

iOS5以降を対象とした場合に、StoryBoardを利用する事のデメリットはXibを直接使う場合に比べて少ないです。

StoryBoardを使うことで以下のようなメリットも得られるので、すべての画面において特殊なUIが求められない場合は
StoryBoardを使ったほうが効率がよくなると思います。

* Static Cell
* iOS6以降のContainer View
* Segueでの遷移

画面間で値を渡す場合にXibの時のようにインスタンスを作って設定する方法はStoryBoardでも運用的カバーできます。

* `StoryBoardで画面間で値を渡す方法論について(文字列を直接使わない方法) | Technology-Gym <http://tech-gym.com/2013/03/ios/1157.html>`_ 
