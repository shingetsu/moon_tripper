unit RSAbase_g;
{
*********************************************************

RSA公開鍵暗号ベースルーチン
Delphi+gmp版

Delphi版 RSAbase.pas
gcc+gmp版 RSAbase.h/RSAbase.c

  programmed by "replaceable anonymous"
*********************************************************

delphi+gmp版改版履歴
  ver 0.2.0 2004/07/22
    longintからgmpに関数変更

/////////////////////////////////////////////////////////
Delphi版改版履歴
  ver 0.0.0 2004/02/11
    とりあえずできた

  ver 0.1.0 2004/02/15
    q-1の因数にeが含まれていると無限ループになるバグを修正
    失敗時にp,q両方をインクリメントするように

  ver 0.2.0 2004/02/16
    関数実装に書き換え。
    gcc+gmp版とそろえた

/////////////////////////////////////////////////////////

}

interface

uses
  SysUtils,
  gmp2;

const
  RSAe = $10001; {RSAで公開用の指数}
  RSACreateGiveup = 300; {構成失敗までの試行回数}

type
  TRSAkeybase = class(TObject)
  public
    n: mpz_t;
    d: mpz_t;
    constructor Create;
    destructor Destroy; override;
  end;

  ERSAError = class(Exception);

  procedure RSAbase_generate(key: TRSAkeybase; const p_seed, q_seed: mpz_t);
  procedure RSAbase_encrypt(var m: mpz_t;key: TRSAkeybase);
  procedure RSAbase_decrypt(var m: mpz_t;const n: mpz_t);

implementation

uses factor_g;

constructor TRSAkeybase.Create;
begin
    inherited;
    mpz_init(n);
    mpz_init(d);
end;

destructor TRSAkeybase.Destroy;
begin
    mpz_clear(n);
    mpz_clear(d);
    inherited;
end;

//
//  与えられたランダムな2整数からRSAに適合するn,dを構成する
//
procedure RSAbase_generate(key: TRSAkeybase;const p_seed, q_seed: mpz_t);
var
  test: mpz_t;
  e: mpz_t;
  q1,phi: mpz_t;
  p,q: mpz_t;
  i: Integer;
begin
    mpz_init_set_ui(e,RSAe);
    mpz_init(phi);
    mpz_init(q1);
    mpz_init_set_ui(test,$7743);

    mpz_init_set(p,p_seed);
    mpz_init_set(q,q_seed);

    try
      for i := 0 to RSACreateGiveup do
      begin
        primize(q); {qから+方向に一番近い素数に}
        mpz_sub_ui(q1,q,1); {q1= q-1}
        primize(p); {pから+方向に一番近い素数に}
        mpz_sub_ui(phi,p,1);
        mpz_mul(phi,phi,q1); {phi = (p-1)(q-1)}

        if mpz_invert(key.d,e,phi) = 0 then  {dはeの法(p-1)(q-1)での逆元}
        begin
          mpz_add_ui(p,p,2);  {逆元は存在しないのでパス}
          mpz_add_ui(q,q,2);
          Continue;
        end;
        mpz_mul(key.n,p,q);   {完成、n=pq}

        mpz_powm(test,test,e,key.n);   {本当に戻ってくるか実験}
        mpz_powm(test,test,key.d,key.n);
        if mpz_cmp_ui(test,$7743) = 0 then {署名テストにパスしたら終了}
          Exit;

        mpz_add_ui(p,p,2);
        mpz_add_ui(q,q,2);
      end;

      raise ERSAError.Create('Fail to Create RSA-Keys: Retry-limit Over');
    finally
      mpz_clear(e);
      mpz_clear(phi);
      mpz_clear(q1);
      mpz_clear(test);
      mpz_clear(p);
      mpz_clear(q);
    end;
end;

procedure RSAbase_encrypt(var m: mpz_t;key: TRSAkeybase);
begin
    mpz_powm(m,m,key.d,key.n);
end;

procedure RSAbase_decrypt(var m: mpz_t;const n: mpz_t);
begin
    mpz_powm_ui(m,m,RSAe,n);
end;

end.
