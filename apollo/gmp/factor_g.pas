unit factor_g;
{
***************************************************************

�f���������A�f�����胋�[�`�� factor
Delphi+gmp��

  programmed & arranged by "replaceable anonymous"
***************************************************************

���삨��юQ�l����
    http://www.asahi-net.or.jp/~KC2H-MSM/
      (���w�҂̖��� by �O���v�T)
    http://idm.s9.xrea.com/
      (IDM by �䂤��)
    http://primes.utm.edu/
      (The Prime Pages by Chris Caldwell)

    �R���s���[�^�Ƒf���q����/�a�c�G�j��/�V����
    UBASIC�ɂ��R���s���[�^�����_/�ؓc�S�i�E�q�쌉�v��/���{�]�_��
    �Í��̐��w�I��b ���_��RSA�Í�����/S.C.�R�E�`�[�j�����E�ѕj��
      /�V���v�����K�[��t�F�A���[�N����

***************************************************************
delphi+gmp�ŉ��ŗ���
  ver 0.1.2 2004/07/20
    longint����gmp�Ɋ֐��ύX

//////////////////////////////////////////////////////////////
delphi�ŉ��ŗ���

  ver 0.0.0 2004/02/10
    �ڐA&�C��
    �~���[�e�X�gspsp�œ��̓`�F�b�N���Ȃ���
    �A���~���[�e�X�gspsptest�ŘA���񐔂������Ƃ���
    ���f�����e�X�glittletest��Boolean�ɂ���
    �σ��\�b�h�Ń`�F�b�N���Ȃ���
    �f�������[�`��primize�ŋ����ł܂��Ȃ��悤��
    2�f�����������[�`���̈����ُ�����O�ŏ���������

  ver 0.1.1 2004/02/15
    gcc+gmp�őf������ɏ����c���悤�Ǝv������
    �����g���Ă��̂Ŏ��O�ňڐA����

  ver 0.1.2 2004/03/24
    �f�������[�`��primize��6n+1,6n+5�ł܂킻���Ƃ�����
    �����Ȃ�Ȃ������̂ł�߁B
    ��ɂ���̂�or�ɂ��Ă݂�

//////////////////////////////////////////////////////////
c����ŉ��ŗ���(Winny�t�g���b�p�[��)
	ver 0.1 2003/06/30
		���o�[�W����longint��
	ver 0.2 2003/10/03
		longint ver0.2�łɕύX�B���̑��č\��

	ver 4.0 2003/11/13
		�ǂ����f�R�[�h���͂낭�Ƀ`�F�b�N���ĂȂ��݂�����
		ViSualBaSIc�ȂǂƂ����s���ȃg���b�v�����ʂ���
		���܂��炵�����Ƃ����o�B
		�o�Ȃ��̂����₵���̂ŁA�͈̓`�F�b�N���O���Ă݂��B
	ver 4.1 2003/11/13
		1��0�Ȃǂ������������悤�Ƃ����|�J���C��

***************************************************************

}

interface

uses
  gmp2;

const
  SPRPTestCount = 10;
  {���[�f���~���[�e�X�g���s���񐔁A�딻��̊m����1/(4^Count)}

function spsp(const n: mpz_t; a: Integer): Boolean;
function spsptest(const n: mpz_t): Boolean;
function littletest(const n: mpz_t): Boolean;
function rhomethod(var n: mpz_t; var p: mpz_t): Boolean;
procedure primize(var x: mpz_t);
procedure factorize2(const n: mpz_t; var p: mpz_t; var q: mpz_t);

implementation

uses
  SysUtils;

const
  little_prime: array[0..668] of Integer =
(2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,
107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,
211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,
317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,
439,443,449,457,461,463,467,479,487,491,499,503,509,521,523,541,547,557,563,
569,571,577,587,593,599,601,607,613,617,619,631,641,643,647,653,659,661,673,
677,683,691,701,709,719,727,733,739,743,751,757,761,769,773,787,797,809,811,
821,823,827,829,839,853,857,859,863,877,881,883,887,907,911,919,929,937,941,
947,953,967,971,977,983,991,997,1009,1013,1019,1021,1031,1033,1039,1049,1051,
1061,1063,1069,1087,1091,1093,1097,1103,1109,1117,1123,1129,1151,1153,1163,
1171,1181,1187,1193,1201,1213,1217,1223,1229,1231,1237,1249,1259,1277,1279,
1283,1289,1291,1297,1301,1303,1307,1319,1321,1327,1361,1367,1373,1381,1399,
1409,1423,1427,1429,1433,1439,1447,1451,1453,1459,1471,1481,1483,1487,1489,
1493,1499,1511,1523,1531,1543,1549,1553,1559,1567,1571,1579,1583,1597,1601,
1607,1609,1613,1619,1621,1627,1637,1657,1663,1667,1669,1693,1697,1699,1709,
1721,1723,1733,1741,1747,1753,1759,1777,1783,1787,1789,1801,1811,1823,1831,
1847,1861,1867,1871,1873,1877,1879,1889,1901,1907,1913,1931,1933,1949,1951,
1973,1979,1987,1993,1997,1999,2003,2011,2017,2027,2029,2039,2053,2063,2069,
2081,2083,2087,2089,2099,2111,2113,2129,2131,2137,2141,2143,2153,2161,2179,
2203,2207,2213,2221,2237,2239,2243,2251,2267,2269,2273,2281,2287,2293,2297,
2309,2311,2333,2339,2341,2347,2351,2357,2371,2377,2381,2383,2389,2393,2399,
2411,2417,2423,2437,2441,2447,2459,2467,2473,2477,2503,2521,2531,2539,2543,
2549,2551,2557,2579,2591,2593,2609,2617,2621,2633,2647,2657,2659,2663,2671,
2677,2683,2687,2689,2693,2699,2707,2711,2713,2719,2729,2731,2741,2749,2753,
2767,2777,2789,2791,2797,2801,2803,2819,2833,2837,2843,2851,2857,2861,2879,
2887,2897,2903,2909,2917,2927,2939,2953,2957,2963,2969,2971,2999,3001,3011,
3019,3023,3037,3041,3049,3061,3067,3079,3083,3089,3109,3119,3121,3137,3163,
3167,3169,3181,3187,3191,3203,3209,3217,3221,3229,3251,3253,3257,3259,3271,
3299,3301,3307,3313,3319,3323,3329,3331,3343,3347,3359,3361,3371,3373,3389,
3391,3407,3413,3433,3449,3457,3461,3463,3467,3469,3491,3499,3511,3517,3527,
3529,3533,3539,3541,3547,3557,3559,3571,3581,3583,3593,3607,3613,3617,3623,
3631,3637,3643,3659,3671,3673,3677,3691,3697,3701,3709,3719,3727,3733,3739,
3761,3767,3769,3779,3793,3797,3803,3821,3823,3833,3847,3851,3853,3863,3877,
3881,3889,3907,3911,3917,3919,3923,3929,3931,3943,3947,3967,3989,4001,4003,
4007,4013,4019,4021,4027,4049,4051,4057,4073,4079,4091,4093,4099,4111,4127,
4129,4133,4139,4153,4157,4159,4177,4201,4211,4217,4219,4229,4231,4241,4243,
4253,4259,4261,4271,4273,4283,4289,4297,4327,4337,4339,4349,4357,4363,4373,
4391,4397,4409,4421,4423,4441,4447,4451,4457,4463,4481,4483,4493,4507,4513,
4517,4519,4523,4547,4549,4561,4567,4583,4591,4597,4603,4621,4637,4639,4643,
4649,4651,4657,4663,4673,4679,4691,4703,4721,4723,4729,4733,4751,4759,4783,
4787,4789,4793,4799,4801,4813,4817,4831,4861,4871,4877,4889,4903,4909,4919,
4931,4933,4937,4943,4951,4957,4967,4969,4973,4987,4993,4999);

//
//  function spsp(const n: mpz_t; a: Integer): Boolean;
//    ��a�ł̃��r���E�~���[(Rabin-Miller)�e�X�g���s��
//      �f���܂��͋��[�f���ł����True
//      �������ł����False��Ԃ�
//
//    ������n�͊�A1<b<n-1�łȂ���΂Ȃ�܂���
//    �͈͊O�̓���͖���`�ł�(�������[�v�ɓ��邩��)
//
function spsp(const n: mpz_t; a: Integer): Boolean;
var
  n1,d: mpz_t;
  p: mpz_t;
  i,s: Integer;
begin
    if mpz_even_p(n) then
    begin
      Result := False;
      Exit;
    end;
    s := 0;
    mpz_init_set(n1,n);
    mpz_sub_ui(n1,n1,1);
    mpz_init_set(d,n1);
    repeat
      mpz_fdiv_q_2exp(d,d,1);
      Inc(s);
    until mpz_odd_p(d);
    {n-1=2^s*d d:� �ƂȂ�s,d��������}

    Result := True;
    mpz_init_set_ui(p,a);
    mpz_powm(p,p,d,n);
    {p = a^d (mod n)�Ƃ��ăX�^�[�g}

    repeat
      if mpz_cmp_ui(p,1) = 0 then
        Break;
      if mpz_cmp(p,n1) = 0 then
        Break;
      {i=0�� p=1 or p=n-1 �Ȃ�f�����[�f��}

      Result := False;
      for i := 1 to s-1 do
      begin
        mpz_powm_ui(p,p,2,n);
        {p��@n�̂��Ƃ�2��}
        if mpz_cmp(p,n1) = 0 then
        begin
          Result := True;
          Break;
        {p=n-1�Ȃ�f�����[�f��}
        end;
      end;
      {i<s��p=n-1�ɂȂ�Ȃ���΍�����}
    until True;

    mpz_clear(n1);
    mpz_clear(d);
    mpz_clear(p);
end;

//
//  function spsptest(const n: mpz_t; Count: Integer): Boolean;
//    ���r���E�~���[(Rabin-Miller)�e�X�g���ŏ���Count�̑f�����Ƃ��čs��
//      �f���܂��͂��ׂĂ̒�ŋ��[�f���ł����True
//      �������ł����False��Ԃ�
//
//  �Q�l�Fhttp://primes.utm.edu/prove/prove2_3.html
//    If n < 1,373,653 is a both 2 and 3-SPRP, then n is prime.
//    If n < 25,326,001 is a 2, 3 and 5-SPRP, then n is prime.
//    If n < 25,000,000,000 is a 2, 3, 5 and 7-SPRP, then either n = 3,215,031,751 or n is prime. (This is actually true for n < 118,670,087,467.)
//    If n < 2,152,302,898,747 is a 2, 3, 5, 7 and 11-SPRP, then n is prime.
//    If n < 3,474,749,660,383 is a 2, 3, 5, 7, 11 and 13-SPRP, then n is prime.
//    If n < 341,550,071,728,321 is a 2, 3, 5, 7, 11, 13 and 17-SPRP, then n is prime.
//
//    If n < 9,080,191 is a both 31 and 73-SPRP, then n is prime.
//    If n < 4,759,123,141 is a 2, 7 and 61-SPRP, then n is prime.
//    If n < 1,000,000,000,000 is a 2, 13, 23, and 1662803-SPRP, then n is prime.
//
function spsptest(const n: mpz_t): Boolean;
var
  i: Integer;
begin
    Result := False;
    for i := 0 to SPRPTestCount do
    begin
      if not spsp(n,little_prime[i]) then
        Exit;
    end;
    Result := True;
end;

//
//  function littletest(const n: mpz_t; index: Integer = 0): Boolean;
//    �����ȑf��(little_prime)�Ŋ����Ă݂āA���������m���߂�
//      ��������False�A�����ȑf�����ׂĂƌ݂��ɑf�Ȃ�True��Ԃ�
//
function littletest(const n: mpz_t): Boolean;
var
  i: Integer;
begin
    if mpz_cmp_ui(n,high(little_prime)) <= 0 then
    begin
      if mpz_cmp_ui(n,1) = 0 then
      begin
        Result := False;
        Exit;
      end;
      Result := True;
      for i := 0 to high(little_prime) do
        if mpz_cmp_ui(n,little_prime[i]) = 0 then
          Exit;
    end;
    Result := False;
    for i := 0 to high(little_prime) do
    begin
      if mpz_fdiv_ui(n,little_prime[i]) = 0 then
        Exit;
    end;
    Result := True;
end;

//
//  function rhomethod(var n: mpz_t; var p: mpz_t): Boolean;
//    �����e�J�����@(�σ��\�b�h)�ɂ��f������������
//      ���� n: ������
//
//      �Ԃ�l True   ���𐬌�:n,p�f���q
//             False  ���s
//
//    �������f���q���܂܂Ȃ������������肵�Ă܂�
//    �f����^����Ɩ߂��Ă��Ȃ��Ȃ邱�Ƃ�����̂�
//    ���O�Ƀe�X�g���Ă��������B(32bit���אs�����ƕԂ��Ă���͂�w)
//    ���������q���܂܂��ƕ����Ɏ��s���܂�
//    �m���I��@�ł��̂ŉ^�������ƂȂ��Ȃ��Ԃ��Ă��܂���B
//
function rhomethod(var n: mpz_t; var p: mpz_t): Boolean;
var
  a,b: mpz_t;
  w,g: mpz_t;
  tmp: mpz_t;
  i,j,k,d: Integer;
label
  ExitFree;
begin
    mpz_init_set_ui(a,2);
    mpz_init_set_ui(b,5);
    {b=a^2+1}

    mpz_init_set_ui(w,1);
    mpz_init_set_ui(g,1);
    mpz_init(tmp);

    Result := True;
    d := 0;
    for i := 0 to 31 do
    begin
      if mpz_cmp_ui(n,65535) <= 0 then {�������ƌ딽������̂ŃX�L�b�v}
        goto ExitFree;

      if mpz_cmp(b,n) > 0 then  {mod n}
        mpz_mod(b,b,n);

      mpz_set(a,b);

      j := 2 shl i;
      for k := 1 to j do
      begin
        mpz_mul(b,b,b);
        mpz_add_ui(b,b,1);
        {b = b^2 + 1}
        if mpz_cmp(b,n) > 0 then  {mod n}
          mpz_mod(b,b,n);

        mpz_sub(tmp,b,a);
        mpz_mul(w,w,tmp);
        if (mpz_sgn(w) < 0) or (mpz_cmp(tmp,n) > 0) then
          mpz_mod(tmp,tmp,n);
        {w = w*(b-a) (mod n)}

        if d>100 then {������x���߂Ă���gcd}
        begin
          if mpz_sgn(w) <> 0 then
          begin
            mpz_gcd(g,w,n);
            if mpz_cmp_ui(g,1) > 0 then
            begin
              mpz_set(p,g);
              mpz_fdiv_q(n,n,g);
              goto ExitFree;
            end;
          end;
          mpz_set_ui(w,1);
          d := 0;
        end else
          Inc(d);
      end;
    end;
    Result := False;

  ExitFree:
    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(w);
    mpz_clear(g);
    mpz_clear(tmp);
end;

//
//  procedure primize(var x: mpz_t);
//    x���f���ł��邩���ׁA�f���łȂ����+������
//    �f���ɂȂ�܂ŃC���N�������g����
//
//    �������A���[�f����f���Ɣ��f����B
//    �~�����[�e�X�g�̒�Ɏg���f���������������̂�
//    �f���Ƃ݂Ȃ��Ȃ��̂ŏ��������ɂ͎g�p���Ȃ����ƁB
//
procedure primize(var x: mpz_t);
begin
    if mpz_even_p(x) then
      mpz_add_ui(x,x,1);

    while True do
    begin
      if littletest(x) then
      begin
        if spsptest(x) then
          Exit;
      end;
      mpz_add_ui(x,x,2);
    end;
end;

//
//  procedure factorize2(const n: mpz_t; var p: mpz_t; var q: mpz_t);
//    2�̑傫�߂ȑf������Ȃ�n��f������������
//
procedure factorize2(const n: mpz_t; var p: mpz_t; var q: mpz_t);
begin
    mpz_set(p,n);

    if mpz_cmp_ui(n,1) <= 0 then
      raise Exception.Create('IllegalFunctionCall');

    if not littletest(p) then
      raise Exception.Create('IllegalFunctionCall');

    if spsptest(p) then
      raise Exception.Create('IllegalFunctionCall');

    if not rhomethod(p,q) then
      raise Exception.Create('IllegalFunctionCall');

    if not spsptest(p) then
      raise Exception.Create('IllegalFunctionCall');
end;

end.
