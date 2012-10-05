プロパティとインスタンス変数(ivar)
=============================================

`github/objective-c-conventions <https://github.com/github/objective-c-conventions>`_ をベースとして書かれています。

getter/setter, ``-init`` , ``-dealloc`` 以外でivarにアクセスしない
---------------------------------------------------------------------

インスタンス変数にアクセスする時は、基本的にgetter/setter(アクセッサメソッド、プロパティ)を経由してアクセスすべきです。

インスタンス変数を直接使わない理由としては、
インスタンス変数を直接使う場合は不必要なretain等、参照カウントを操作するコードが必要になり見通しが悪くなる事や、
KVO(Key-Value Observing)が使えない事や、アクセッサメソッドを経由しないため変更に弱い部分があることなどがあげられます。

以下の条件を満たしているならインスタンス変数を直接使っても問題は無いですが、統一性という観点から
インスタンス変数を直接参照するのは ``-init`` と ``-dealloc`` 以外では避けるべきです:: 

    1.Is declared in a class using ARC.
    2.Is used solely for class implementation (not exposed as part of the class interface).
    3.Does not require any KVO.
    4.Does not require any custom getter/setter.
    http://stackoverflow.com/questions/7836182/property-vs-ivar-in-times-of-arc

逆に ``-init`` と ``-dealloc`` ではインスタンス変数を参照するべき理由は、
下記の記事に詳細に書かれています。

* `Don't Message self in Objective-C init (or dealloc) - Quality Coding <http://qualitycoding.org/objective-c-init/>`_

単純にまとめると、プロパティでアクセスすためには ``self`` が存在していないといけないため、
その ``self`` が初期化(init)、破棄(dealloc)されているかを ``-init`` と ``-dealloc`` 内では気をつけないといけません。

そのため、``-init`` と ``-dealloc`` 内では **プロパティを使わない** とすることで単純化できるため、そういう習慣としています。

``-init`` での初期化一回しか代入を行わないプロパティはreadonly属性にする
------------------------------------------------------------------------

Objective-C のプロパティにはreadonly属性が指定できます。
そのプロパティのスコープを小さくするために、外から書き込みが必要のないプロパティにはreadonly属性を指定しましょう。

:file:`/Code/ios-practice/ReadOnly.h`

.. literalinclude:: /Code/ios-practice/ReadOnly.h
  :language: objc


:file:`/Code/ios-practice/ReadOnly.m`

.. literalinclude:: /Code/ios-practice/ReadOnly.m
  :language: objc

また、readonly属性を指定すると、そのクラス内部からも ``self.array = @[];`` のような代入はできなくなりますが、
クラスエクステンションを使いプライベートカテゴリ内で、プロパティに ``readwrite`` を付けることで、
外からはreadonlyだけど、中からはreadwriteのプロパティを作ることができます。

* `Objective-C 2.0 のプロパティ隠蔽 | ishwt::tracking <http://ishwt.net/blog/2010/05/21/objc20-property/>`_
* `privateなpropertyを作りたい時は無名カテゴリ（クラスエクステンション）を使う — Gist <https://gist.github.com/1267428>`_

インスタンス変数には接頭辞に_を付ける
------------------------------------------------------------------------------

インスタンス変数とプロパティの名前が被らないようにするため、頭か末尾に_(アンダーバー)を付けると思いますが、
基本的には統一されていることが大事なのでどちらでも構いませんが、
最近のAppleのドキュメントでは接頭辞に_を付けることを推奨しているため、新規に書くコード等はこの作法に則った方が良いでしょう。

* `Cocoa向け コーディング ガイドライン - CodingGuidelines.pdf <https://developer.apple.com/jp/devcenter/ios/library/documentation/CodingGuidelines.pdf>`_
* `プロパティに対応するインスタンス変数の命名規則について - Awaresoft <http://www.awaresoft.jp/ios-dev/item/115-ivar-naming-convention.html>`_
* `[iOS] Objective-C @propertyについて « きんくまデザイン <http://www.kuma-de.com/blog/2012-06-25/3617>`_

インスタンス変数とプロパティのまとめ
------------------------------------------------
ここまでをまとめるてみると

:file:`/Code/ios-practice/Property.h`

.. literalinclude:: /Code/ios-practice/Property.h
  :language: objc


:file:`/Code/ios-practice/Property.m`

.. literalinclude:: /Code/ios-practice/Property.m
  :language: objc

Xcodeのバージョン(Clang)が上がるに連れて省略出来る箇所が増えてきているので、
一般に理解できるであろう最低限の記述を考えながら書いていくとよい。

* `Xcode 4.5のテンプレートに@synthesizeがなくなった・・ | J7LG <http://www.j7lg.com/archives/1270>`_

.. note:: 

	|today| 現在では、@interface の @property 宣言だけでもコンパイルは問題なく通る。
	どこまで省略するかは周りのチームの人に合わせて行うのがよいと思われる。

不必要なivarは宣言しない
---------------------------------------------

そのインスタンス変数が本当に必要なのか、ローカル変数で間に合わないかを検討しましょう。


.. _`github/objective-c-conventions` https://github.com/github/objective-c-conventions