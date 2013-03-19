CoreDataについて
=============================================

.. todo:: 

	全体的にもう少し詳しく書くべき

`mogenerator`_ でモデルクラスを作成
----------------------------------------------

`mogenerator`_ はCoreData定義を書くの ``.xcdatamodel`` ファイルから自動的にモデルクラスを作成するツールである。

Xcodeも :menuselection:`Editor --> Create NSManagedObject SubClass` で類似の機能が存在するが、
mogeneratorを使い生成した方が、拡張性等が優れているためこちらを利用する。

.. todo::

    mogeneratorの親クラスを利用したサブクラスの作り方について

`MagicalRecord`_ のススメ
----------------------------------------------

CoreDataをもっと使いやすく、ハマりどころを減らすために `MagicalRecord`_ ライブラリの使用を推奨。

* `MagicalRecordのREADMEを意訳 - Object for cutie <http://d.hatena.ne.jp/tanaponchikidun/20121202/1354468112>`_


少なくともCoreDataを扱う際にはManagerとなるクラスを経由するようにして利用しないと、
不必要にmanagedObjectContextが複数作成されてしまうことなどが発生してしまう可能性があるため、統一的な利用方法を定めておくべきである。

* `CoreDataプロジェクト作成時にやっておきたいこと | iPhoneアプリ開発で稼げるのか <http://iphone.longearth.net/2011/02/14/coredata%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E4%BD%9C%E6%88%90%E6%99%82%E3%81%AB%E3%82%84%E3%81%A3%E3%81%A6%E3%81%8A%E3%81%8D%E3%81%9F%E3%81%84%E3%81%93%E3%81%A8/>`_

Entityにidentifier属性を作成する
----------------------------------------------

Entityには任意の属性を作成できるが、どのEntityにも必ず ``identifier`` 属性を作成する。
また、そのidentifierにはUUIDを代入するようにしておく。

UUIDの代入を自動的に行えるようにするにはmogeneratorを利用し作成した拡張用のサブクラスで
``-awakeFromInsert`` をoverwriteし代入するようにしておくといい。

.. seealso:: 

	`mogeneratorと識別子を使ったCoreDataのModelクラス作成パターン | Technology-Gym <http://tech-gym.com/2012/10/ios/890.html>`_
		mogeneratorを使ったモデル作成について

CoreDataではObjectIDという識別子が振られているがこれは内部的に使われるもののため、
外部から一意に特定するためにidentifier属性を付けることで、検索時にUUIDを使い探索が簡単に行えるようになる。

.. _`mogenerator`: https://github.com/rentzsch/mogenerator
.. _`MagicalRecord`: https://github.com/magicalpanda/MagicalRecord