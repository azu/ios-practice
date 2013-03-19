.. ios-conventions documentation master file, created by
   sphinx-quickstart on Fri Oct  5 10:51:48 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

iOS Practice
===========================================

iOSアプリ開発におけるプラクティス集

.. seealso::

	`Objective-Cによるプログラミング`_
		AppleによるObjective-Cでのベストプラクティスについてかかれた文章
	`github/objective-c-conventions`_
		GithubによるObjective-Cのコーディングルール

サンプルコード
--------------------------------------------

サンプルコードは `azu/ios-practice · GitHub <https://github.com/azu/ios-practice>`_ のCodeディレクトリにあります。

.. code-block:: bash
	
	git clone https://github.com/azu/ios-practice.git 
	cd ios-practice/Code && open ios-practice.xcodeproj

Contents:

.. toctree::
   :maxdepth: 3
   
   docs/ivar_property
   docs/code_structures
   docs/tableview
   docs/notification
   docs/save-data
   docs/coredata


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

.. _`github/objective-c-conventions`: https://github.com/github/objective-c-conventions
.. _`Objective-Cによるプログラミング`: https://developer.apple.com/jp/devcenter/ios/library/documentation/ProgrammingWithObjectiveC.pdf