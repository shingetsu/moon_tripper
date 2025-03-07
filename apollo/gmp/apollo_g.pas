unit apollo_g;
{
*********************************************************
�V��&Crescent �g���b�v�F�؃��[�`��
�C���^�t�F�[�X
Delphi+gmp��

  programmed by "replaceable anonymous"

/////////////////////////////////////////////////////////
�����ŕϊ����s���̂�Base64, MD5���K�v�ł�
*********************************************************

delphi+gmp�ŉ��ŗ���
  ver 0.3.1 2004/07/22
    longint����gmp�Ɋ֐��ύX

  ver 0.3.2 2004/08/12
    gmp�Ŏ������ꉞ�I��

/////////////////////////////////////////////////////////
���ŗ���
  ver 0.0.0 2004/02/12
    ������������

  ver 0.1.0 2004/02/15
    gcc+gmp�łƂ̌݊����Ƃ���
    �������������Ȃ邱�Ƃ�����̂��C��
    1024bit�łŔz�����΂肷���Ȃ̂�ύX
    (�g���b�v�d�lver0.2)

  ver 0.2.0 2004/02/17
    �֐��`���ɏ���������

  ver 0.3.0 2004/03/20
    1024bit�ł𕜊��A�ו��C��(�g���b�v�d�lver0.3)
    �����A�F�؂ł̖��ʂȃR�s�[��p�~

  ver 0.3.1 2004/03/24
    �Í������[�`�����m��(�Í����d�lver0.0)

}
interface

  procedure RSAkeycreate512(var publickey: String;var secretkey: String;const keystr: String);
  procedure RSAkeycreate1024(var publickey: String;var secretkey: String;const keystr: String);
  //�g���b�v���y�A�쐬

  function RSAsign(const mes: String;const publickey: String;const secretkey: String): String;
  //����

  function RSAverify(const mes: String;const testsignature: String;const publickey: String): Boolean;
  //�F��

  function triphash(const keystr: String): String;
  //���������k 11�����Ɉ��k

  function RSAencrypt(const plainmes: String;const publickey: String): String;
  //���J���ɂ��Í���

  function RSAdecrypt(const cryptmes: String;const publickey: String;const secretkey: String): String;
  //�閧���ɂ�镜��(���y�A���K�v)

  function RSAdesign(const mes: String;const publickey: String;const secretkey: String): String;
  //�f�o�b�O�p

implementation

uses SysUtils, Classes, RSAbase_g, Base64, MD5, RC4, gmp2;

procedure little_endian_copy(var dest;const s: PChar; count: Integer);
type
  TNum = array[0..MaxListSize+2] of Cardinal;
var
  i,j,max: Integer;
  tmp: Cardinal;
begin
    max := count shr 2;
    j := 0;
    for i := 0 to max-1 do
    begin
      j := i shl 2;
      TNum(dest)[i] := (((((Cardinal(s[j+3]) shl 8)+Cardinal(s[j+2])) shl 8)
                        +Cardinal(s[j+1])) shl 8) + Cardinal(s[j]);
    end;
    tmp := 0;
    for i := count-1 downto j+4 do
    begin
      tmp := tmp shl 8;
      tmp := tmp + Cardinal(s[i]);
    end;
    TNum(dest)[max] := tmp;
end;

function base64encodeLINT(const n: mpz_t; len: Integer): string;
const
  CTable: PChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  i,j: Integer;
  d: mpz_t;
begin
    Result := '';
    if mpz_sgn(n) = 0 then
    begin
      Exit;
    end;

    mpz_init_set(d,n);
    SetLength(Result,len);
    i := 0;
    repeat
      Inc(i);
      Result[i] := Char(mpz_fdiv_q_ui(d,d,64));
    until (mpz_sgn(d) = 0) or (i >= len);

    for j := i+1 to len do
      Result[j] := Char(0);

    for i := 1 to len do
    begin
      Result[i] := CTable[Byte(Result[i])];
    end;
end;

procedure base64decodeLINT(var n: mpz_t;const Str: string; len: Integer);

  // �e�������U�r�b�g�f�[�^�ɕϊ�����
  function decode(code: BYTE): BYTE;
  begin
    case Char(code) of
    'A'..'Z': Result := code - BYTE('A');
    'a'..'z': Result := code - BYTE('a') + 26;
    '0'..'9': Result := code - BYTE('0') + 52;
    '+': Result := 62;
    '/': Result := 63;
    else Result := 0; // �e=�f�̏ꍇ���e0�f��Ԃ�
    end;
  end;

var
  i: Integer;
  Data: String;
begin
    mpz_set_ui(n,0);
    Data := Str;

    SetLength(Data,len);
    for i := length(Data)+1 to len do
      Data[i] := 'A';

    for i := len downto 1 do
    begin
  		mpz_mul_ui(n,n,64);
  		mpz_add_ui(n,n,decode(Byte(Data[i])));
    end;
end;

function triphash(const keystr: String): String;
var
  ctx: MD5Context;
  digest: array[0..15]of char;
  mStream: TMemoryStream;
begin
    MD5Init(ctx);
    MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
    MD5Final(ctx, digest);
    mStream := TMemoryStream.Create;
    try
      mStream.Position := 0;
      mStream.Write(digest,16);
      mStream.Position := 0;
      Result := copy(base64encode(mStream,mStream.Size),1,11);
    finally
      mStream.Free;
    end;
end;

function RSAsign(const mes: String;const publickey: String;const secretkey: String): String;
var
  keypair: TRSAkeybase;
  len,keylen: Integer;
  m: mpz_t;
begin
    len := length(mes);
    keylen := length(publickey);
    if(len*4 > keylen*3) then
      len := keylen*3 div 4;
    if(len = 0) then
      raise ERSAError.Create('sign.HashToLINT: null input');
    mpz_init(m);
    keypair := TRSAkeybase.Create;
    try
    	mpz_import(m,len,-1,1,0,0,mes[1]);
      base64decodeLINT(keypair.n,publickey,keylen);
      base64decodeLINT(keypair.d,secretkey,keylen);
      RSAbase_encrypt(m,keypair);
      Result := base64encodeLINT(m,keylen);
    finally
      mpz_clear(m);
      keypair.Free;
    end;
end;

function RSAdesign(const mes: String;const publickey: String;const secretkey: String): String;
var
  keypair: TRSAkeybase;
  len,keylen: Integer;
  m: mpz_t;
begin
    len := length(mes);
    keylen := length(publickey);
    if(len*4 > keylen*3) then
      len := keylen*3 div 4;
    if(len = 0) then
      raise ERSAError.Create('sign.HashToLINT: null input');
    mpz_init(m);
    keypair := TRSAkeybase.Create;
    try
      base64decodeLINT(keypair.n,publickey,keylen);
      base64decodeLINT(keypair.d,secretkey,keylen);
      base64decodeLINT(m,mes,keylen);
      RSAbase_decrypt(m,keypair.n);
      SetLength(Result,(mpz_sizeinbase(m,2) + 8-1) div 8);
    	mpz_export(Result[1],len,-1,1,0,0,m);
      SetLength(Result,len);
    finally
      mpz_clear(m);
      keypair.Free;
    end;
end;

function RSAverify(const mes: String;const testsignature: String;const publickey: String): Boolean;
var
  len,keylen: Integer;
  m,c,n: mpz_t;
begin
    len := length(mes);
    keylen := length(publickey);
    if(len*4 > keylen*3) or (len = 0) then
    begin
      Result := False;
      Exit;
    end;
    mpz_init(m);
    mpz_init(c);
    mpz_init(n);
    try
      mpz_import(m,len,-1,1,0,0,mes[1]);
      base64decodeLINT(n,publickey,keylen);
      base64decodeLINT(c,testsignature,keylen);
      RSAbase_decrypt(c,n);
      Result := (mpz_cmp(c,m) = 0);
    finally
      mpz_clear(m);
      mpz_clear(c);
      mpz_clear(n);
    end;
end;

///////////////////////////////////////////////////////////////////////
// 512bit RSA (apollo512-2) 2004/02/16
///////////////////////////////////////////////////////////////////////
procedure Make512pq(var a1: mpz_t; var a2: mpz_t; const Seed: string);
var
  ctx: MD5Context;
  keystr: String;
  hashs: array[0..63] of Char;
begin
    keystr := Seed;
    MD5Init(ctx);
    MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
    MD5Final(ctx, @hashs[0]);
    keystr := Seed + 'pad1';
    MD5Init(ctx);
    MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
    MD5Final(ctx, @hashs[16]);
    keystr := Seed + 'pad2';
    MD5Init(ctx);
    MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
    MD5Final(ctx, @hashs[32]);
    keystr := Seed + 'pad3';
    MD5Init(ctx);
    MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
    MD5Final(ctx, @hashs[48]);

  	mpz_import(a1,28,-1,1,0,0,hashs[0]);
	  mpz_import(a2,36,-1,1,0,0,hashs[28]);
    mpz_setbit(a1,215);
    mpz_setbit(a2,279);
end;

procedure RSAkeycreate512(var publickey: String;var secretkey: String;const keystr: String);
var
  keypair: TRSAkeybase;
  p,q: mpz_t;
begin
    mpz_init(p);
    mpz_init(q);
    keypair := TRSAkeybase.Create;
    try
      Make512pq(p,q,keystr);
      RSAbase_generate(keypair,p,q);
      publickey := base64encodeLINT(keypair.n,86);
      secretkey := base64encodeLINT(keypair.d,86);
    finally
      mpz_clear(p);
      mpz_clear(q);
      keypair.Free;
    end;
end;

///////////////////////////////////////////////////////////////////////
// 1024bit RSA (apollo1024-3) 2004/03/30
///////////////////////////////////////////////////////////////////////
procedure Make1024pq(var a1: mpz_t; var a2: mpz_t; const Seed: string);
const
  pads: array[0..7] of PChar = ('','pad1','pad2','pad3','pad4','pad5','pad6','pad7');
var
  ctx: MD5Context;
  keystr: String;
  hashs: array[0..127] of Char;
  i: Integer;
begin
    for i := 0 to 7 do
    begin
      keystr := Seed + string(pads[i]);
      MD5Init(ctx);
      MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
      MD5Final(ctx, @hashs[i shl 4]);
    end;

  	mpz_import(a1,52,-1,1,0,0,hashs[0]);
	  mpz_import(a2,76,-1,1,0,0,hashs[52]);
    mpz_setbit(a1,409);
    mpz_setbit(a2,601);
end;

procedure RSAkeycreate1024(var publickey: String;var secretkey: String;const keystr: String);
var
  keypair: TRSAkeybase;
  p,q: mpz_t;
begin
    mpz_init(p);
    mpz_init(q);
    keypair := TRSAkeybase.Create;
    try
      Make1024pq(p,q,keystr);
      RSAbase_generate(keypair,p,q);
      publickey := base64encodeLINT(keypair.n,171);
      secretkey := base64encodeLINT(keypair.d,171);
    finally
      mpz_clear(p);
      mpz_clear(q);
      keypair.Free;
    end;
end;


function RSAencrypt(const plainmes: String;const publickey: String): String;
var
  keylen: Integer;
  m,c,n: mpz_t;
  RC4salt: String;
  RC4crypt: TRC4Crypt;
  i: Integer;
  mStream: TMemoryStream;
  intbuf: array of Cardinal;
  count: Integer;
begin
    keylen := length(publickey);
    mpz_init(m);
    mpz_init(c);
    mpz_init(n);
    base64decodeLINT(n,publickey,keylen);
    count := (mpz_sizeinbase(n,2) + 31) div 32;
    SetLength(intbuf,count);
    mpz_export(intbuf[0],count,-1,4,0,0,n);

    for i := 0 to count-2 do
    begin
      intbuf[i] := Random($ffffffff);
    end;
    intbuf[count-1] := Random(intbuf[count-1]);
    mpz_import(m,count,-1,4,0,0,intbuf);
    SetLength(RC4salt,count*4);
    Move(intbuf[0],RC4salt[1],count*4);
    RSAbase_decrypt(m,n);
    RC4crypt := TRC4Crypt.Create(RC4salt);
    mStream := TMemoryStream.Create;
    mStream.Position := 0;
    mStream.Write(intbuf[0],count*4);
    mStream.Write(RC4crypt.Encrypt(plainmes)[1],length(plainmes));
    mStream.Position := 0;
    Result := base64encode(mStream,mStream.Size);

    mpz_clear(m);
    mpz_clear(c);
    mpz_clear(n);
    mStream.Free;
    RC4crypt.Free;
end;


function RSAdecrypt(const cryptmes: String;const publickey: String;const secretkey: String): String;
var
  keylen: Integer;
  keypair: TRSAkeybase;
  c: mpz_t;
  RC4salt: String;
  RC4crypt: TRC4Crypt;
  mStream: TMemoryStream;
  intbuf: array of Cardinal;
  count: Integer;
begin
    keypair := TRSAkeybase.Create;
    mpz_init_set_ui(c,0);

    keylen := length(publickey);
    base64decodeLINT(keypair.n,publickey,keylen);
    base64decodeLINT(keypair.d,secretkey,keylen);
    count := (mpz_sizeinbase(keypair.n,2) + 31) div 32;
    SetLength(intbuf,count);

    mStream := TMemoryStream.Create;
    mStream.Position := 0;
    base64decode(mStream,cryptmes);
    mStream.Position := 0;
    mStream.Read(intbuf[0],count*4);
    mpz_import(c,count,-1,4,0,0,intbuf);
    RSAbase_encrypt(c,keypair);
    SetLength(RC4salt,count*4);
    Move(intbuf[0],RC4salt[1],count*4);
    RC4crypt := TRC4Crypt.Create(RC4salt);
    Result := RC4crypt.Encrypt(mStream);

    mpz_clear(c);
    mStream.Free;
    RC4crypt.Free;
    keypair.Free;
end;

initialization
    Randomize;

end.
