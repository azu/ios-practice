コードの構造について
=============================================

if/for文は常に波括弧 ``{}`` をつける
---------------------------------------------

ifやfor等、波括弧 ``{}`` を省略できるものがありますが、基本的に省略せずにかきましょう

.. code-block:: objc

	// Bad!
	if (something)
		// do something
	
	// Good!
	if (something) {
		// do something
	}

.. note:: 

	``if (something) return;`` というようにスグにreturnするだけの場合は省略しても悪くは無いが、
	出来れば付けていたほうがよい。
	
比較は常に厳密に行う
-----------------------------------------------

NSStringを比較する場合 ``==`` で文字列を比較するのは避けるべきです。
``==`` による比較は文字列としての比較ではなく、同じポインタの値かどうかの比較になります。

文字列の比較を行う場合は ``isEqualToString:`` メソッドを使い比較します。

:file:`/Code/Tests/CompareTests.m`

.. literalinclude:: /Code/Tests/CompareTests.m
  :language: objc

* `objective c - Why does NSString sometimes work with the equal sign? - Stack Overflow <http://stackoverflow.com/questions/9154288/why-does-nsstring-sometimes-work-with-the-equal-sign>`_
* `文字列比較のお作法 - memory*Leak <http://d.hatena.ne.jp/manmarina/20100630/1277913379>`_

.. note:: 

	定義済みの文字列定数同士を ``==`` で比較した場合は問題無いですが、
	それを考えて行うのは難しい所もあるので、基本的に文字列の比較はメソッドを使って行う方がよい。
	
	* `プログラミング雑記: NSString定数の定義 <http://ken-plus.blogspot.jp/2012/03/nsstring.html>`_

一般にオブジェクト同士の値を比較する場合は適当な ``isEqual*:`` や ``compare:`` といったメソッドが用意されているはずなので、
それを利用し比較するべきです。(intやNSUInteger等のプリミティブな値はC言語と同様に ``==`` で比較して問題ありません)

.. seealso:: 

	`Objective-Cによるプログラミング - ProgrammingWithObjectiveC.pdf <https://developer.apple.com/jp/devcenter/ios/library/documentation/ProgrammingWithObjectiveC.pdf#page=40>`_
	"オブジェクトの等価性を判断する" に ``==`` , ``isEqual:`` , ``compare:`` について書かれている。

真偽値の比較は省略する
------------------------------------------------

BOOL型等の真偽値をif文等において比較するのは、あまり意味がなく冗長になるだけなので、
避けるべきです。

.. code-block:: objc

	BOOL hasYES = YES;
	// Bad!
	if(hasYES == YES){ /* somthing */ }
	// Good!
	if(hasYES){ /* somthing */ }


