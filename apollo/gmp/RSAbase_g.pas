unit RSAbase_g;
{
*********************************************************

RSA���J���Í��x�[�X���[�`��
Delphi+gmp��

Delphi�� RSAbase.pas
gcc+gmp�� RSAbase.h/RSAbase.c

  programmed by "replaceable anonymous"
*********************************************************

delphi+gmp�ŉ��ŗ���
  ver 0.2.0 2004/07/22
    longint����gmp�Ɋ֐��ύX

/////////////////////////////////////////////////////////
Delphi�ŉ��ŗ���
  ver 0.0.0 2004/02/11
    �Ƃ肠�����ł���

  ver 0.1.0 2004/02/15
    q-1�̈�����e���܂܂�Ă���Ɩ������[�v�ɂȂ�o�O���C��
    ���s����p,q�������C���N�������g����悤��

  ver 0.2.0 2004/02/16
    �֐������ɏ��������B
    gcc+gmp�łƂ��낦��

/////////////////////////////////////////////////////////

}

interface

uses
  SysUtils,
  gmp2;

const
  RSAe = $10001; {RSA�Ō��J�p�̎w��}
  RSACreateGiveup = 300; {�\�����s�܂ł̎��s��}

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
//  �^����ꂽ�����_����2��������RSA�ɓK������n,d���\������
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
        primize(q); {q����+�����Ɉ�ԋ߂��f����}
        mpz_sub_ui(q1,q,1); {q1= q-1}
        primize(p); {p����+�����Ɉ�ԋ߂��f����}
        mpz_sub_ui(phi,p,1);
        mpz_mul(phi,phi,q1); {phi = (p-1)(q-1)}

        if mpz_invert(key.d,e,phi) = 0 then  {d��e�̖@(p-1)(q-1)�ł̋t��}
        begin
          mpz_add_ui(p,p,2);  {�t���͑��݂��Ȃ��̂Ńp�X}
          mpz_add_ui(q,q,2);
          Continue;
        end;
        mpz_mul(key.n,p,q);   {�����An=pq}

        mpz_powm(test,test,e,key.n);   {�{���ɖ߂��Ă��邩����}
        mpz_powm(test,test,key.d,key.n);
        if mpz_cmp_ui(test,$7743) = 0 then {�����e�X�g�Ƀp�X������I��}
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
