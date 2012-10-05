=============================================
Objective-C 
=============================================


プロパティとインスタンス変数(ivar)
=============================================

不必要なivarは宣言しない
---------------------------------------------

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

readonly属性のプロパティは ``-init`` で一度だけivarを設定する
------------------------------------------------------------------------

Objective-C のプロパティにはreadonly属性が指定できます。


.. code-block:: objc

    @interface ios_practiceTests : NSObject
    @property(nonatomic, strong, readonly) NSArray *array;    
    @end
    
    @implementation ios_practiceTests {
        NSArray *_array;
    }
    
    @synthesize array = _array;
   
    - (id)init {
        self = [super init];
        if (!self){
            return nil;
        }
        // readonlyの初期化はここで一回のみ
        _array = [NSArray arrayWithObjects:@"readonly", @"first", @"init", nil];
        
        return self;
    }


.. _`プロパティに対応するインスタンス変数の命名規則について - Awaresoft` http://www.awaresoft.jp/ios-dev/item/115-ivar-naming-convention.html