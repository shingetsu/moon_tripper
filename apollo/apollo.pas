unit apollo;
{
*********************************************************
新月&Crescent トリップ認証ルーチン
インタフェース
Delphi+gmp&longint動的選択版

  programmed by "replaceable anonymous"

/////////////////////////////////////////////////////////
内部で変換を行うのでBase64, MD5が必要です
*********************************************************

改版履歴
  ver 0.4 2004/08/14
    cyggmp-3.dllのロードが成功すればgmp版(高速)
    失敗すればlongint版を使用するように


/////////////////////////////////////////////////////////
delphi+gmp版改版履歴
  ver 0.3.1 2004/07/22
    longintからgmpに関数変更

  ver 0.3.2 2004/08/12
    gmp版実装が一応終了

/////////////////////////////////////////////////////////
改版履歴
  ver 0.0.0 2004/02/12
    試験実装完成

  ver 0.1.0 2004/02/15
    gcc+gmp版との互換をとった
    桁数が小さくなることがあるのを修正
    1024bit版で配分が偏りすぎなのを変更
    (トリップ仕様ver0.2)

  ver 0.2.0 2004/02/17
    関数形式に書き換えた

  ver 0.3.0 2004/03/20
    1024bit版を復活、細部修正(トリップ仕様ver0.3)
    署名、認証での無駄なコピーを廃止

  ver 0.3.1 2004/03/24
    暗号化ルーチンを確定(暗号化仕様ver0.0)

*********************************************************
トリップ仕様ver0.3 2004/03/20

  ##apollo512-2 2004/02/16
	1)文字列変換ルール(base64.c)

		多倍長整数<->文字列
			最下位6bitからbase64テーブルに準拠して変換
			文字列の先頭文字が整数の最下位6bit
			文字列の最後尾が最上位

			想定される字数に足りない時は0が補充される
			(文字変換時にAが足される)

		鍵文字圧縮
			与えられた鍵文字列のMD5ハッシュをとり、
			そのbase64エンコードの先頭11文字をとる

	2)鍵の生成ルール

		素数テストにはミラーテストを使用し、最初の10個の
		素数に対してパスした擬素数を素数とみなす。

		公開乗数eは65537

		トリップ生成文字列から素数p,qを生成
			生成文字列依存のランダムなp,qのとり方
				hash1:  トリップ生成文字列($key)のMD5ハッシュ
				hash2:  $key + 'pad1'  のMD5ハッシュ
				hash3:  $key + 'pad2'  のMD5ハッシュ
				hash4:  $key + 'pad3'  のMD5ハッシュ

				とし、hashsをその連結とする。

				pのnum[0]-num[6] := hashs[0-27] (28byte)
				qのnum[0]-num[8] := hashs[28-63](36byte)
				(little-endianで処理する。つまりhashsの最初の
				バイトがpの最下位バイトになるように)

				pが216bitより小さな因数になるのを防ぐため
				p.num[6]の下から24bit目(216bit目、第215bit)を1にする
				qが280bitより小さな因数になるのを防ぐため
				q.num[8]の下から24bit目(280bit目、第279bit)を1にする
				これにより、nが496bitを下回ることはない

			p,qをRSAに適する素数にする変換則
				qをq以上で最小の擬素数とする
				pをp以上で最小の擬素数とする

				(p-1)(q-1)とe=65537が互いに素 かつ
				t = 0x7743,de ≡ 1 mod(p-1)(q-1),n = pq なるt,d,nに対し
				t^ed ≡ t (mod n)が成立

				を満たすp,qが出るまでp+=2,q+=2して素数テストから繰り返す
				ただし生成失敗回数(300=RSACreateGiveup)を超えるとエラー

		こうして生成したnを公開鍵、dを秘密鍵と称する
		文字列に変換する際は上記変換則を用いて86文字とする

	3)署名ルール
		RSA暗号化 m^d ≡ c (mod n)
		に使用するmの変換ルール

		与えられた署名対象ハッシュ文字列をMes[0-63]とする
		64byteに満たない場合、空きには0が仮定され、
		超える場合は超えた部分は無視される

		m.num[0-15] := Mes[0-63](64byte)
		(little-endianで処理する。Mesの最初のバイトはmの最下位バイト)


  ##apollo1024-3 2004/03/20
	1)文字列変換ルール
    apollo512-2 と同じ

	2)鍵の生成ルール

		素数テストにはミラーテストを使用し、最初の10個の
		素数に対してパスした擬素数を素数とみなす。

		公開乗数eは65537

		トリップ生成文字列から素数p,qを生成
			生成文字列依存のランダムなp,qのとり方
				hash1:  トリップ生成文字列($key)のMD5ハッシュ
				hash2:  $key + 'pad1'  のMD5ハッシュ
				hash3:  $key + 'pad2'  のMD5ハッシュ
				hash4:  $key + 'pad3'  のMD5ハッシュ
				hash5:  $key + 'pad4'  のMD5ハッシュ
				hash6:  $key + 'pad5'  のMD5ハッシュ
				hash7:  $key + 'pad6'  のMD5ハッシュ
				hash8:  $key + 'pad7'  のMD5ハッシュ

				とし、hashsをその連結とする。

				pのnum[0]-num[12] := hashs[0-51] (52byte)
				qのnum[0]-num[18] := hashs[52-127](76byte)
				(little-endianで処理する。つまりhashsの最初の
				バイトがpの最下位バイトになるように)

				pが410bitより小さな因数になるのを防ぐため
				p.num[12]の下から26bit目(410bit目、第409bit)を1にする
				qが602bitより小さな因数になるのを防ぐため
				q.num[18]の下から26bit目(602bit目、第601bit)を1にする
				これにより、nが1012bitを下回ることはない

			p,qをRSAに適する素数にする変換則
				qをq以上で最小の擬素数とする
				pをp以上で最小の擬素数とする

				(p-1)(q-1)とe=65537が互いに素 かつ
				t = 0x7743,de ≡ 1 mod(p-1)(q-1),n = pq なるt,d,nに対し
				t^ed ≡ t (mod n)が成立

				を満たすp,qが出るまでp+=2,q+=2して素数テストから繰り返す
				ただし生成失敗回数(300=RSACreateGiveup)を超えるとエラー

		こうして生成したnを公開鍵、dを秘密鍵と称する
		文字列に変換する際は上記変換則を用いて171文字とする

	3)署名ルール
		apollo512-2 と同じ

*********************************************************
暗号化仕様(ver0.0 2004/03/24)

  暗号化にはRSA公開鍵暗号とRC4共通鍵暗号を併用する。
  RC4の鍵をランダムに生成し、公開鍵暗号で暗号化して付加する。

  a)暗号化手順
    トリップ(pubkey)=nの桁数と同じ長さの乱数を用意する。
    ただし、数値化したときにnを超えてはならない(RSAでの要請)
    これをmとする。
    mをnとeで暗号化する(c = m^e mod n)
    RC4の鍵としてmを使い、与えられた平文を暗号化する。
    c(公開鍵で暗号化したRC4の鍵)+RC4の暗号文をBase64エンコードする

  b)復号手順
    暗号文をBase64デコードし、暗号化されたRC4鍵(=c)を得る。
    秘密鍵(=d)と公開鍵(=n)でcを復号し、RC4鍵を得る(m = c ^ d mod n)
    RC4の鍵としてmを使い、デコード済みの暗号文を復号する

*********************************************************
*********************************************************
説明書き
  procedure RSAkeycreate512(var publickey: String;var secretkey: String;const keystr: String);
  procedure RSAkeycreate1024(var publickey: String;var secretkey: String;const keystr: String);
  トリップ鍵ペア作成を作成
    keystr: トリップ元文字列
    publickey: 公開鍵文字列(法n)
    secretkey: 秘密鍵文字列(秘密鍵乗数d)

  以下のルーチンはどちらの仕様のトリップ鍵ペアであっても動きます

  function RSAsign(const mes: String;const publickey: String;const secretkey: String): String;
  署名
    返り値: 署名文字列
    mes:  署名対象(nよりも短いことが必要)
      mesには署名したい対象のMD5などを与えてください

  function RSAverify(const mes: String;const testsignature: String;const publickey: String): Boolean;
  認証
    返り値: 通ればtrue
    mes:  署名対象(nよりも短いことが必要)
    testsignature: 署名文字列

  function triphash(const keystr: String): String;
  鍵文字圧縮 みやすいように11文字に圧縮します
  (keystrのMD5ハッシュのBase64エンコード先頭11文字)


  function RSAencrypt(const plainmes: String;const publickey: String): String;
  公開鍵による暗号化 トリップキーを知っている人だけが開錠できる暗号化を施します
    返り値: 暗号化文
    plainmes: 暗号化したい文

  function RSAdecrypt(const cryptmes: String;const publickey: String;const secretkey: String): String;
  秘密鍵による復号 RSAencryptされた暗号化文を復号します
  処理には鍵ペアが必要です
    返り値: 復号された文
    cryptmes: 暗号化文
}

interface

var
  RSAkeycreate512: procedure (var publickey: String;var secretkey: String;const keystr: String);
  RSAkeycreate1024: procedure (var publickey: String;var secretkey: String;const keystr: String);
  //トリップ鍵ペア作成

  RSAsign: function (const mes: String;const publickey: String;const secretkey: String): String;
  //署名

  RSAverify: function (const mes: String;const testsignature: String;const publickey: String): Boolean;
  //認証

  triphash: function (const keystr: String): String;
  //鍵文字圧縮 11文字に圧縮

  RSAencrypt: function (const plainmes: String;const publickey: String): String;
  //公開鍵による暗号化

  RSAdecrypt: function (const cryptmes: String;const publickey: String;const secretkey: String): String;
  //秘密鍵による復号(鍵ペアが必要)

  RSAdesign: function (const mes: String;const publickey: String;const secretkey: String): String;
  //デバッグ用

implementation

uses gmp2, apollo_g, apollo_l;

initialization

  if IsDLLLoaded then
  begin
    RSAkeycreate512 := apollo_g.RSAkeycreate512;
    RSAkeycreate1024 := apollo_g.RSAkeycreate1024;
    RSAsign := apollo_g.RSAsign;
    RSAverify := apollo_g.RSAverify;
    triphash := apollo_g.triphash;
    RSAencrypt := apollo_g.RSAencrypt;
    RSAdecrypt := apollo_g.RSAdecrypt;
    RSAdesign := apollo_g.RSAdesign;
  end else
  begin
    RSAkeycreate512 := apollo_l.RSAkeycreate512;
    RSAkeycreate1024 := apollo_l.RSAkeycreate1024;
    RSAsign := apollo_l.RSAsign;
    RSAverify := apollo_l.RSAverify;
    triphash := apollo_l.triphash;
    RSAencrypt := apollo_l.RSAencrypt;
    RSAdecrypt := apollo_l.RSAdecrypt;
    RSAdesign := apollo_l.RSAdesign;
  end;
end.
