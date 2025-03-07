unit apollo_l;
{
*********************************************************
�V��&Crescent �g���b�v�F�؃��[�`��
�C���^�t�F�[�X
Delphi(longint)��

  programmed by "replaceable anonymous"

/////////////////////////////////////////////////////////
�����ŕϊ����s���̂�Base64, MD5���K�v�ł�
*********************************************************

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

uses SysUtils, Classes, longint, RSAbase_l, Base64, MD5, RC4;

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

function base64encodeLINT(n: TLINT; len: Integer): string;
const
  CTable: PChar =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  i,j: Integer;
begin
    Result := '';
    if n.Len = 0 then
    begin
      Exit;
    end;

    SetLength(Result,len);
    i := 0;
    repeat
      Inc(i);
      Result[i] := Char(n.Num[0] and $3f);
    until lshr1(@n,6).Len = 0;

    for j := i+1 to len do
      Result[j] := Char(0);

    for i := 1 to len do
    begin
      Result[i] := CTable[Byte(Result[i])];
    end;
end;

function base64decodeLINT(var n: TLINT;const Str: string; len: Integer): PLINT;

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
    Result := @n;
    lset(@n,0);
    Data := Str;

    SetLength(Data,len);
    for i := length(Data)+1 to len do
      Data[i] := 'A';

    for i := len downto 1 do
    begin
      lshl1(@n,6);
      if n.Len > LINTMaxLen then
        raise ELINTOverflow.Create('overflow');
      alinc(@n,decode(Byte(Data[i])));
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
    mStream.Position := 0;
    mStream.Write(digest,16);
    mStream.Position := 0;
    Result := copy(base64encode(mStream,mStream.Size),1,11);
    mStream.Free;
end;

function RSAsign(const mes: String;const publickey: String;const secretkey: String): String;
var
  keypair: TRSAkeybase;
  len,keylen: Integer;
  m: TLINT;
begin
    len := length(mes);
    keylen := length(publickey);
    if(len*4 > keylen*3) then
      len := keylen*3 div 4;
    if(len > LINTMaxLen*4) then
      raise ERSAError.Create('overflow: too long publickey');
    if(len = 0) then
      raise ERSAError.Create('sign.HashToLINT: null input');
    lset(@m,0);
    Move(mes[1],m.num[0],len);
    m.Len := ((len-1) shr 2) + 1;
    base64decodeLINT(keypair.n,publickey,keylen);
    base64decodeLINT(keypair.d,secretkey,keylen);
    RSAbase_encrypt(m,keypair);
    Result := base64encodeLINT(m,keylen);
end;

function RSAdesign(const mes: String;const publickey: String;const secretkey: String): String;
var
  keypair: TRSAkeybase;
  len,keylen: Integer;
  m: TLINT;
begin
    len := length(mes);
    keylen := length(publickey);
    if(len*4 > keylen*3) then
      len := keylen*3 div 4;
    if(len > LINTMaxLen*4) then
      raise ERSAError.Create('overflow: too long publickey');
    if(len = 0) then
      raise ERSAError.Create('sign.HashToLINT: null input');
    base64decodeLINT(keypair.n,publickey,keylen);
    base64decodeLINT(keypair.d,secretkey,keylen);
    base64decodeLINT(m,mes,keylen);
    RSAbase_decrypt(m,keypair.n);
    SetLength(Result,m.Len*4);
    Move(m.num[0],Result[1],m.Len*4);
end;

function RSAverify(const mes: String;const testsignature: String;const publickey: String): Boolean;
var
  len,keylen: Integer;
  m,c,n: TLINT;
begin
    len := length(mes);
    keylen := length(publickey);
    if(len*4 > keylen*3) then
      len := keylen*3 div 4;
    if(len > LINTMaxLen*4) then
      raise ERSAError.Create('overflow: too long publickey');
    if(len = 0) then
      raise ERSAError.Create('sign.HashToLINT: null input');
    lset(@m,0);
    Move(mes[1],m.num[0],len);
    m.Len := ((len-1) shr 2) + 1;
    base64decodeLINT(n,publickey,keylen);
    base64decodeLINT(c,testsignature,keylen);
    RSAbase_decrypt(c,n);
    Result := (lcmp(@c,@m) = 0);
end;

///////////////////////////////////////////////////////////////////////
// 512bit RSA (apollo512-2) 2004/02/16
///////////////////////////////////////////////////////////////////////
procedure Make512pq(out a1: TLINT; out a2: TLINT; const Seed: string);
var
  ctx: MD5Context;
  keystr: String;
  hashs: array[0..63] of Char;
begin
    if LINTMaxLen < 16 then
      raise ERSAError.Create('overflow: need 512bit(len:16)');
    lset(@a1,0);
    lset(@a2,0);
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

    Move(hashs[0],a1.num[0],28);
    Move(hashs[28],a2.num[0],36);
    a1.Num[6] := a1.Num[6] or $800000;
    a2.Num[8] := a2.Num[8] or $800000;
    a1.Len := 7;
    a2.Len := 9;
end;

procedure RSAkeycreate512(var publickey: String;var secretkey: String;const keystr: String);
var
  keypair: TRSAkeybase;
  p,q: TLINT;
begin
    Make512pq(p,q,keystr);
    RSAbase_generate(keypair,p,q);
    publickey := base64encodeLINT(keypair.n,86);
    secretkey := base64encodeLINT(keypair.d,86);
end;

///////////////////////////////////////////////////////////////////////
// 1024bit RSA (apollo1024-3) 2004/03/30
///////////////////////////////////////////////////////////////////////
procedure Make1024pq(out a1: TLINT; out a2: TLINT; const Seed: string);
const
  pads: array[0..7] of PChar = ('','pad1','pad2','pad3','pad4','pad5','pad6','pad7');
var
  ctx: MD5Context;
  keystr: String;
  hashs: array[0..127] of Char;
  i: Integer;
begin
    if LINTMaxLen < 32 then
      raise ERSAError.Create('overflow: need 1024bit(len:32)');
    lset(@a1,0);
    lset(@a2,0);
    for i := 0 to 7 do
    begin
      keystr := Seed + string(pads[i]);
      MD5Init(ctx);
      MD5Update(ctx, PBYTE(PChar(keystr)), Length(keystr));
      MD5Final(ctx, @hashs[i shl 4]);
    end;

    Move(hashs[0],a1.num[0],52);
    Move(hashs[52],a2.num[0],76);
    a1.Num[12] := a1.Num[12] or $2000000;
    a2.Num[18] := a2.Num[18] or $2000000;
    a1.Len := 13;
    a2.Len := 19;
end;

procedure RSAkeycreate1024(var publickey: String;var secretkey: String;const keystr: String);
var
  keypair: TRSAkeybase;
  p,q: TLINT;
begin
    Make1024pq(p,q,keystr);
    RSAbase_generate(keypair,p,q);
    publickey := base64encodeLINT(keypair.n,171);
    secretkey := base64encodeLINT(keypair.d,171);
end;


function RSAencrypt(const plainmes: String;const publickey: String): String;
var
  keylen: Integer;
  m,c,n: TLINT;
  RC4salt: String;
  RC4crypt: TRC4Crypt;
  i: Integer;
  mStream: TMemoryStream;
begin
    keylen := length(publickey);
    base64decodeLINT(n,publickey,keylen);
    lset(@m,0);
    lset(@c,0);
    m.Len := n.Len;
    for i := 0 to n.Len-2 do
    begin
      m.Num[i] := Random($ffffffff);
    end;
    m.Num[n.Len-1] := Random(n.Num[n.Len-1]);
    if m.Num[n.Len-1] = 0 then
      m.Num[n.Len-1] := 1;
    SetLength(RC4salt,m.Len*4);
    Move(m.Num[0],RC4salt[1],m.Len*4);
    RSAbase_decrypt(m,n);
    RC4crypt := TRC4Crypt.Create(RC4salt);
    mStream := TMemoryStream.Create;
    mStream.Position := 0;
    mStream.Write(m.num[0],m.Len*4);
    mStream.Write(RC4crypt.Encrypt(plainmes)[1],length(plainmes));
    mStream.Position := 0;
    Result := base64encode(mStream,mStream.Size);
    mStream.Free;
    RC4crypt.Free;
end;

function RSAdecrypt(const cryptmes: String;const publickey: String;const secretkey: String): String;
var
  keylen: Integer;
  keypair: TRSAkeybase;
  c: TLINT;
  RC4salt: String;
  RC4crypt: TRC4Crypt;
  mStream: TMemoryStream;
begin
    keylen := length(publickey);
    base64decodeLINT(keypair.n,publickey,keylen);
    base64decodeLINT(keypair.d,secretkey,keylen);
    lset(@c,0);
    c.Len := keypair.n.Len;
    mStream := TMemoryStream.Create;
    mStream.Position := 0;
    base64decode(mStream,cryptmes);
    mStream.Position := 0;
    mStream.Read(c.num[0],c.Len*4);
    RSAbase_encrypt(c,keypair);
    SetLength(RC4salt,c.Len*4);
    Move(c.Num[0],RC4salt[1],c.Len*4);
    RC4crypt := TRC4Crypt.Create(RC4salt);
    Result := RC4crypt.Encrypt(mStream);
    mStream.Free;
    RC4crypt.Free;
end;

initialization
    Randomize;

end.
