新月トリップルーチンサンプルプログラム

新月トリッパー「月の国のとりっぱー」


説明
	新月で使用されているトリップのトリッパーです。
	指定したファイルに、条件に一致するトリップキーとpubkey,seckeyを書き出します

	可変部に使用する文字で、すべてを選ぶと新月で多分化けます。
	固定部にいわゆる漢字を使うと、新月はUTF-8なので化けます。
	無難に記号を含む英数の範囲から選ぶ方がいいと思います。

	トリップが条件に一致すれば、ファイルに書き出されると共に、右下の
	リストボックスに表示されます。
	更新のタイミングに合わないと、リストボックスへ表示されない時がありますが、
	ファイルには書いています。

	トリップを生成する処理はとてもとても重いので、生成スレッドの優先度を
	指定できます。高くすると操作不能になるので注意してください。
	判定スレッド、メインスレッドは優先度は決め打ちです(重くない)。

	正規表現ルーチンBREGEXP.DLLがロードできると、正規表現による一致テストが
	可能となります。正規表現はルーチン付属のヘルプを参照してください。
	windows版gmpルーチン cyggmp-3.dllがロードできると、gmp版apolloを使用して
	高速にトリップを生成できます(当社比10倍)

	あとは気合で使ってください。
	鬼のように遅いので(こちらの環境では55keys/secが限界)覚悟を…


使用しているルーチンについて
	BREGEXP.DLL
		
		Baba Centerfolds http://www.hi-ho.ne.jp/~babaq/
			by Tatsuo Baba
		の以下のURLで公開されているDLLを使用しています。
		http://www.hi-ho.ne.jp/~babaq/bregexp.html
	
		>babaqフリーソフトのご使用上の注意
		>●プログラムを使って発生した損害に関しては、一切の責任を負いません。
		>●使用、配布に制限はありません。自由にお使いください。
		>●動作の保証はありません。
		>●動作を確認したＯＳは、Windows NT 4.0 とWindows 95/98のみです。
	
	
		内部的に
		Osamu's Square http://www2.big.or.jp/~osamu/
			by Osamu Takeuchi osamu@big.or.jp
		の以下のURLで公開されているユニットを変更して使用しています。
		http://www2.big.or.jp/~osamu/Delphi/MyLibrary.htm
		
		>ここでは Delphi 関連の自作ユニット・コンポーネント・ツールを
		>紹介しています。
		>どれだけ皆さんの役に立つか分かりませんが、興味があったら覗いて
		>みてください。
		>
		>お約束ですが、これらのファイルの使用は、各人の責任の下に
		>行ってください。
		>作者である 武内 修 (osamu@big.or.jp) は、その動作・不動作・その他
		>いかなる不具合・不利益にも責任を負いません。あしからず。
	
	cyggmp-3.dll
		The GNU MP Bignum Library
		http://www.swox.com/gmp/
		で公開されているgmp-4.1.3をDLLコンパイルしたものです。
		
		GMP is distributed under the GNU LGPL. This license makes the library 
		free to use, share, and improve, and allows you to pass on the result. 
		The license gives freedoms, but also sets firm restrictions on the use 
		with non-free programs. 
		GMPはGNU 劣等一般公衆利用許諾契約書で公開されています。
		詳細はこちらを参照してください
		http://www.gnu.org/copyleft/lesser.html
		
		cygwinはこちらで公開されています
		http://www.cygwin.com/
		
		MinGWを使用するとcygwinに依存しないwindows dllを構築できます。
		http://www.mingw.org/
		cygwin+gccのコンパイラオプション -mno-cygwinでも同様だそうです。
		が、付属のMinGWのバージョンは古いらしいです。

使用したコンパイラについて
	実行可能形態のファイルは
	http://www.borland.co.jp/delphi/personal/
	で公開されているBorland Delphi 6 Personalを使用してコンパイルされています。
	Personalの使用制限として、商用・業務用には使えないこととなっています。
	再々配布にも制限が効くかどうか調べていませんので、使う方は調べてください。
	ソースから再コンパイルすれば多分制限はなくなると思います。


どちらのDLLも、なくとも一応動きます。
使用しているライブラリに反しない限りにおいて、自由にしてください。
使用・配布は各自の責任においてお願いします。


ファイルの説明
	Tripper.dpr : プロジェクトファイル
	Unit1.pas   :
	Unit1.dfm   : フォーム、メイン管理部
	keygen.pas  : トリップキー生成ルーチン
	match.pas   : トリップ一致判定ルーチン
	
	bregexp\
		BRegExp2.pas  : BREGEXP.DLLの動的リンクインタフェース
		                BRegExp.pas(静的リンク by Osamu Takeuchi)を改造
		BREGEXP.DLL   : 正規表現DLL (by Tatsuo Baba)
		                <実行ファイルのパスの届くところに置いてください>
		BRegExp.hlp   : BRegExp.pasのヘルプ(by Osamu Takeuchi)
		org\以下      : 使用した正規表現関連のオリジナル。詳細はnote
	
	apollo\
		apollo.pas    : 新月トリップルーチンメインファイル
		                cyggmp-3.dllの有無でlongint/gmp版を呼び分ける
		RC4.pas       : (RC4共通鍵暗号ルーチン)おまけ
		MD5.pas       : MD5ルーチン(by 河邦 正/詳細はファイル末尾)
		Base64.pas    : Base64ルーチン(by 河邦 正/詳細はファイル末尾)
		
		longint\ (delphiネイティブ版)
			apollo_l.pas  : インタフェース
			factor_l.pas  : 素数関連ルーチン
			RSAbase_l.pas : RSA計算ルーチン
			longint.pas   : 多倍長整数演算ルーチン
		
		gmp\ (delphi+gmp版)
			apollo_g.pas  : インタフェース
			factor_g.pas  : 素数関連ルーチン
			RSAbase_g.pas : RSA計算ルーチン
			gmp2.pas      : cyggmp-3.dllインタフェースユニット(動的リンク)
			cyggmp-3.dll  : gmp-4.1.3のwindowsネイティブDLL
			                (cygwin+MinGW+gccによりWindows2000でコンパイル)
			                <実行ファイルのパスの届くところに置いてください>
			COPYING.LIB   : GNU LESSER GENERAL PUBLIC LICENSE
			                 Version 2.1, February 1999
			gmp.pas       : (cyggmp-3.dllインタフェースユニット(静的リンク))
			                 おまけ

