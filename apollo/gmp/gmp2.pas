unit gmp2;
{
///////////////////////////////////////////////////////////////////////
GMP (GNU Multiple Precision Arithmetic Library)
Windows DLL用 Delphiユニット (based on gmp-4.1.3)
静的ロード版

  Delphiからcyggmp-3.dllを使用するためのユニットです。
  Windows環境以外での動作は考えられていません。
  整数演算を中心に移植中です。宣言していない関数､マクロがあります。

  ライセンスはオリジナルのままです(GNU LGPL)
  移植に伴うバグがある可能性があるので使う際は注意してください。

programed by 名無しが氏んでも代わりはいるもの

2004/07/22 4.1.3-0.0 : 整数演算と入出力をだいたい
2004/08/12 4.1.3-0.1 : overloadでラッパをかけている関数の微調整
2004/08/13 4.1.3-0.2 : 動的ロードに対応

///////////////////////////////////////////////////////////////////////

/* Definitions for GNU multiple precision functions.   -*- mode: c -*-

Copyright 1991, 1993, 1994, 1995, 1996, 1997, 1999, 2000, 2001, 2002, 2003,
2004 Free Software Foundation, Inc.

This file is part of the GNU MP Library.

The GNU MP Library is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or (at your
option) any later version.

The GNU MP Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with the GNU MP Library; see the file COPYING.LIB.  If not, write to
the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
MA 02111-1307, USA. */
}

interface

function IsDLLLoaded: Boolean;
//  DLLがロードされていればTrueを返す
//  ただし、バージョン違いのDLLが与えられたときは
// すべての関数が使用可能である保障はない

{
#define __GMP_BITS_PER_MP_LIMB             32
#define __GMP_HAVE_HOST_CPU_FAMILY_power   0
#define __GMP_HAVE_HOST_CPU_FAMILY_powerpc 0
#define GMP_LIMB_BITS                      32
#define GMP_NAIL_BITS                      0
}
const
  __GMP_BITS_PER_MP_LIMB = 32;
  __GMP_HAVE_HOST_CPU_FAMILY_power = 0;
  __GMP_HAVE_HOST_CPU_FAMILY_powerpc = 0;
  GMP_LIMB_BITS = 32;
  GMP_NAIL_BITS = 0;

{
#ifdef __GMP_SHORT_LIMB
typedef unsigned int		mp_limb_t;
typedef int			mp_limb_signed_t;
#else
#ifdef _LONG_LONG_LIMB
typedef unsigned long long int	mp_limb_t;
typedef long long int		mp_limb_signed_t;
#else
typedef unsigned long int	mp_limb_t;
typedef long int		mp_limb_signed_t;
#endif
#endif
}
type
  mp_limb_t = Cardinal;
  mp_limb_signed_t = Integer;

{
typedef mp_limb_t *		mp_ptr;
typedef __gmp_const mp_limb_t *	mp_srcptr;
#if defined (_CRAY) && ! defined (_CRAYMPP)
/* plain `int' is much faster (48 bits) */
#define __GMP_MP_SIZE_T_INT     1
typedef int			mp_size_t;
typedef int			mp_exp_t;
#else
#define __GMP_MP_SIZE_T_INT     0
typedef long int		mp_size_t;
typedef long int		mp_exp_t;
#endif
}
type
  mp_ptr = ^mp_limb_t;
//mp_srcptr は呼び出し宣言でconst扱いにする
  mp_size_t = Integer;
  mp_exp_t = Integer;

(*
typedef struct
{
  int _mp_alloc;		/* Number of *limbs* allocated and pointed
				   to by the _mp_d field.  */
  int _mp_size;			/* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
  mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
} __mpz_struct;

typedef __mpz_struct MP_INT;
typedef __mpz_struct mpz_t[1];

*)

type
  mpz_t = record
    _mp_alloc: Integer;
    _mp_size: Integer;
    _mp_d: mp_ptr;
  end;

  MP_INT = mpz_t;

(*
typedef struct
{
  __mpz_struct _mp_num;
  __mpz_struct _mp_den;
} __mpq_struct;

typedef __mpq_struct MP_RAT;
typedef __mpq_struct mpq_t[1];

*)

  mpq_t = record
    _mp_num: mpz_t;
    _mp_den: mpz_t;
  end;

  MP_RAT = mpq_t;

(*
typedef struct
{
  int _mp_prec;			/* Max precision, in number of `mp_limb_t's.
				   Set by mpf_init and modified by
				   mpf_set_prec.  The area pointed to by the
				   _mp_d field contains `prec' + 1 limbs.  */
  int _mp_size;			/* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
  mp_exp_t _mp_exp;		/* Exponent, in the base of `mp_limb_t'.  */
  mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
} __mpf_struct;

/* typedef __mpf_struct MP_FLOAT; */
typedef __mpf_struct mpf_t[1];
*)

  mpf_t = record
    _mp_prec: Integer;
    _mp_size: Integer;
    _mp_exp: mp_exp_t;
    _mp_d: ^mp_limb_t;
  end;


(*
/* Available random number generation algorithms.  */
typedef enum
{
  GMP_RAND_ALG_DEFAULT = 0,
  GMP_RAND_ALG_LC = GMP_RAND_ALG_DEFAULT /* Linear congruential.  */
} gmp_randalg_t;
*)
  gmp_randalg_t = (GMP_RAND_ALG_DEFAULT = 0,GMP_RAND_ALG_LC = 0);

(*
/* Linear congruential data struct.  */
typedef struct {
  mpz_t _mp_a;			/* Multiplier. */
  unsigned long int _mp_c;	/* Adder. */
  mpz_t _mp_m;			/* Modulus (valid only if m2exp == 0).  */
  unsigned long int _mp_m2exp;	/* If != 0, modulus is 2 ^ m2exp.  */
} __gmp_randata_lc;
*)
  __gmp_randata_lc = record
    _mp_a: mpz_t;
    _mp_c: Cardinal;
    _mp_m: mpz_t;
    _mp_m2exp: Cardinal;
  end;

(*
/* Random state struct.  */
typedef struct
{
  mpz_t _mp_seed;		/* Current seed.  */
  gmp_randalg_t _mp_alg;	/* Algorithm used.  */
  union {			/* Algorithm specific data.  */
    __gmp_randata_lc *_mp_lc;	/* Linear congruential.  */
  } _mp_algdata;
} __gmp_randstate_struct;
typedef __gmp_randstate_struct gmp_randstate_t[1];
*)
  __gmp_randstate_alg_union = record
    _mp_lc: ^__gmp_randata_lc;
  end;

  gmp_randstate_t = record
    _mp_seed: mpz_t;
    _mp_alg: gmp_randalg_t;
    _mp_algdata: __gmp_randstate_alg_union;
  end;


(*
/* Types for function declarations in gmp files.  */
/* ??? Should not pollute user name space with these ??? */
typedef __gmp_const __mpz_struct *mpz_srcptr;
typedef __mpz_struct *mpz_ptr;
typedef __gmp_const __mpf_struct *mpf_srcptr;
typedef __mpf_struct *mpf_ptr;
typedef __gmp_const __mpq_struct *mpq_srcptr;
typedef __mpq_struct *mpq_ptr;
*)
  mpz_ptr = ^mpz_t;
  mpf_ptr = ^mpf_t;
  mpq_ptr = ^mpq_t;

{
5. Integer Functions
  整数演算をおこなう関数群。prefix: mpz_



  5.1 Initialization Functions
    整数演算をおこなう関数群はオペランドが初期化されていることを仮定している。
    関数を使用する際はmpz_initを用いて初期化しておかなければならない。
    一度初期化すれば、何度でもどんな値でもストアすることができる。
}
TFmpz_init = procedure (var int: mpz_t); cdecl; 
//procedure mpz_init(var int: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_init';
// intを初期化し、値を0にセットする

TFmpz_init2 = procedure (var int: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_init2(var int: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_init2';
// intをn bitの領域を持って初期化し、値を0にセットする
// nは領域の初期の値で、その後の演算結果を格納するのに必要であれば、
// intは自動的に拡張される。
// この関数を使用することにより、事前に最大サイズがわかっているときに、
// そのような再配置を防ぐことができる。

TFmpz_clear = procedure (var int: mpz_t); cdecl; 
//procedure mpz_clear(var int: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_clear';
// intの使用していた領域を開放する。
// mpz_t 変数は不要になればこの関数を呼び出して解放しなくてはならない。

TFmpz_realloc2 = procedure (var int: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_realloc2(var int: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_realloc2';
// intの確保領域をn bitに変更する。
// 変更後、入りきればintの値は保持され、そうでなければ0にセットされる。
// この関数は、自動再配置が繰り返されるのを防ぐために変数領域を大きくしたり、
// 領域を縮小してヒープにメモリを返却するのに使用できる。

TF_mpz_array_init = procedure (int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); cdecl; 
//procedure _mpz_array_init(int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_array_init';
procedure mpz_array_init(int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); overload;
procedure mpz_array_init(var int_array: array of mpz_t; fixed_num_bits: mp_size_t); overload;
// この関数は特殊な初期化を行う。
// fixed_num_bits bitの「固定長」の領域を、int_arrayのそれぞれの要素に確保する。
// この関数で確保した領域は、通常のmpz_initで確保した領域とは違い、
// 自動拡張されない。プログラムは、使用するどんな値も確保するのに十分である
// ということを保証しなくてはならない。
// （必要な領域の量に関してはヘルプ本文を参照）
// この関数は、小さな領域を大量に確保したり再配置したりするのを避けることにより、
// 巨大な配列が必要なアルゴリズムで、メモリの使用量を抑えることができる。
// この関数により、確保された領域を開放する手段はない。
// mpz_clearを呼び出してはならない。
//
// overload版はオープン配列パラメータによるラッパーである。

type
TF_mpz_realloc = procedure (var int: mpz_t; n: Cardinal); cdecl;
//procedure _mpz_realloc(var int: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_realloc';
// mpz_realloc2と同じだが、返り値は処理に適さないので、破棄すべきである。
// 再配置にはmpz_realloc2の方が適当である。
// 新しいサイズがlimb内である時以外はmpz_realloc2と同じ。

{


  5.2 Assignment Functions
    この関数群は、初期化済みの領域に新しい値をセットする
}
TFmpz_set = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_set(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_set';
TFmpz_set_ui = procedure (var rop: mpz_t; op: Cardinal); cdecl; 
//procedure mpz_set_ui(var rop: mpz_t; op: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_set_ui';
TFmpz_set_si = procedure (var rop: mpz_t; op: Integer); cdecl; 
//procedure mpz_set_si(var rop: mpz_t; op: Integer); cdecl; external 'cyggmp-3.dll' name '__gmpz_set_si';
TFmpz_set_d = procedure (var rop: mpz_t; op: Double); cdecl; 
//procedure mpz_set_d(var rop: mpz_t; op: Double); cdecl; external 'cyggmp-3.dll' name '__gmpz_set_d';
TFmpz_set_q = procedure (var rop: mpz_t; const op: mpq_t); cdecl; 
//procedure mpz_set_q(var rop: mpz_t; const op: mpq_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_set_q';
TFmpz_set_f = procedure (var rop: mpz_t; const op: mpf_t); cdecl; 
//procedure mpz_set_f(var rop: mpz_t; const op: mpf_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_set_f';
// ropにopの値をセットする。
// mpz_set_d,mpz_set_q,mpz_set_fはopを整数に切り捨てる。

TFmpz_set_str = function (var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; 
//function mpz_set_str(var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_set_str';
// ropに、base進数のnull-terminated文字列の示す値を代入する。
// white spaceがstr中に現れても、すべて純粋に無視される。
// baseは2-36が有効である。0である時は、以下の規則で基数が決められる:
// '0x'or'0X'で始まれば16進数、それ以外で'0'で始まれば8進数、
// それ以外は10進数が仮定される。
// この関数は、すべての文字列がbase進数として有効な数字であれば0を、
// そうでなければ-1を返す。

TFmpz_swap = procedure (var rop1: mpz_t; var rop2: mpz_t); cdecl; 
//procedure mpz_swap(var rop1: mpz_t; var rop2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_swap';
// rop1とrop2を効率よく交換する。

{


  5.3 Combined Initialization and Assignment Functions
    GMPは別系統の初期化セット関数群を用意している。
    この関数群は、初期化と同時に値をセットするもので、mpz_init_set...
    という名前である。
    いったんmpz_init_set...関数群で初期化すれば、整数演算関数のsouceとしても
    destinationとしても使用できる。
    既に初期化済みの変数に対して、この関数群を使ってはならない。
}
TFmpz_init_set = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_init_set(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set';
TFmpz_init_set_ui = procedure (var rop: mpz_t; op: Cardinal); cdecl; 
//procedure mpz_init_set_ui(var rop: mpz_t; op: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_ui';
TFmpz_init_set_si = procedure (var rop: mpz_t; op: Integer); cdecl; 
//procedure mpz_init_set_si(var rop: mpz_t; op: Integer); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_si';
TFmpz_init_set_d = procedure (var rop: mpz_t; op: Double); cdecl; 
//procedure mpz_init_set_d(var rop: mpz_t; op: Double); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_d';
// ropを1 limbで初期化し、opの整数値をセットする

TFmpz_init_set_str = function (var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; 
//function mpz_init_set_str(var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_str';
// 領域が初期化される以外はmpz_set_strと同じ
// エラーが起こって-1を返した場合でもropは初期化されているので
// mpz_clearを呼ぶ必要がある

{


  5.4 Conversion Functions
    GMP整数型から、Cの標準型への変換関数群である。
    GMP整数型への変換についてはSection 5.2[Assigning Integers],
    Section 5.12[I/O of Integers]を参照
}
TFmpz_get_ui = function (const op: mpz_t): Cardinal; cdecl; 
//function mpz_get_ui(const op: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_ui';
// opの値をunsigned longで返す
// opがそれよりも大きい時は、収まりきる最下位bitが返される。
// 符号は無視され、絶対値が使われる。

TFmpz_get_si = function (const op: mpz_t): Integer; cdecl; 
//function mpz_get_si(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_si';
// opの値をsigned longで返す
// opが大きい場合は、opと同符号で、収まりきる最下位bitが返される。
// opがsigned longに収まらない時は、返り値はあまり意味を持たない。
// 収まるかどうかはmpz_fits_slong_p関数で調べられる。

TFmpz_get_d = function (const op: mpz_t): Double; cdecl; 
//function mpz_get_d(const op: mpz_t): Double; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_d';
// opをdoubleに変換する

TFmpz_get_d_2exp = function (var exp: Integer; const op: mpz_t): Double; cdecl; 
//function mpz_get_d_2exp(var exp: Integer; const op: mpz_t): Double; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_d_2exp';
// d*2^exp (0.5<|d|<1) なるopのよい近似値d,expを求める

TF_mpz_get_str = function (str: PChar; base: Integer; const op: mpz_t): PChar; cdecl; 
//function _mpz_get_str(str: PChar; base: Integer; const op: mpz_t): PChar; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_str'; overload;
function mpz_get_str(str: PChar; base: Integer; const op: mpz_t): PChar; overload;
function mpz_get_str(const op: mpz_t; base: Integer): String; overload;
// opをbase進数の数値文字列に変換する。baseは2-36が有効である。
// strがNULLであれば現在のallocation関数で文字列領域が確保される。
// その量はstrlen(str)+1であり、ちょうど文字列とヌルターミネータの分である。
// strがNULLでなければ、mpz_sizeinbase(op,base)+2より十分の領域を指して
// いなければならない。+2は符号とターミネータの分である。
// 返り値は、関数で確保したか与えたかによらず、結果文字列へのポインタである。
//
// 初期アロケート関数のままでstrにnilをいれて向こうで確保すると、
// Delphiからは解放できず、MSVCRT.dllからでないと解放できないので注意
//
// overload版は、stringによるラッパーである。

type
TFmpz_getlimbn = function (const op: mpz_t; n: mp_size_t): mp_limb_t; cdecl;
//function mpz_getlimbn(const op: mpz_t; n: mp_size_t): mp_limb_t; cdecl; external 'cyggmp-3.dll' name '__gmpz_getlimbn';
// opのn番目のlimbを返す。符号は無視され、絶対値のみが使われる。
// mpz_size関数を使用すると、opにいくつのlimbがあるかを調べられる。
// nが0からmpz_size(op)-1の範囲にないと、この関数は0を返す。

{


  5.5 Arithmetic Functions
}
TFmpz_add = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_add(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_add';
TFmpz_add_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_add_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_add_ui';
// ropにop1+op2をセットする

TFmpz_sub = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_sub(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_sub';
TFmpz_sub_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_sub_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_sub_ui';
TFmpz_ui_sub = procedure (var rop: mpz_t; op1: Cardinal; const op2: mpz_t); cdecl; 
//procedure mpz_ui_sub(var rop: mpz_t; op1: Cardinal; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_ui_sub';
// ropにop1-op2をセットする

TFmpz_mul = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_mul(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul';
TFmpz_mul_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_mul_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul_ui';
TFmpz_mul_si = procedure (var rop: mpz_t; const op1: mpz_t; op2: Integer); cdecl; 
//procedure mpz_mul_si(var rop: mpz_t; const op1: mpz_t; op2: Integer); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul_si';
// ropにop1*op2をセットする

TFmpz_addmul = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_addmul(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_addmul';
TFmpz_addmul_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_addmul_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_addmul_ui';
// ropにrop+op1*op2をセットする

TFmpz_submul = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_submul(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_submul';
TFmpz_submul_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_submul_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_submul_ui';
// ropにrop-op1*op2をセットする

TFmpz_mul_2exp = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_mul_2exp(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul_2exp';
// ropにop1*2^op2をセットする
// この操作は、左にop2 bitシフトするのと同じである。

TFmpz_neg = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_neg(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_neg';
// ropに-opをセットする

TFmpz_abs = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_abs(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_abs';
// ropにopの絶対値をセットする

{


  5.6 Division Functions
    divisionは除数が0である時については未定義である。
    division,modulo関数(累乗剰余関数mpz_pown,mpz_pown_uiを含む)に除数0が
    与えられると、0による除算を意図的に発生させる。
    これにより、プログラムは通常のCの整数計算と同じように、算術例外を受け取る
    ことができる。
}
TFmpz_cdiv_q = procedure (var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_cdiv_q(var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_q';
TFmpz_cdiv_r = procedure (var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_cdiv_r(var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_r';
TFmpz_cdiv_qr = procedure (var q: mpz_t; var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_cdiv_qr(var q: mpz_t; var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_qr';
TFmpz_cdiv_q_ui = function (var q: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_cdiv_q_ui(var q: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_q_ui';
TFmpz_cdiv_r_ui = function (var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_cdiv_r_ui(var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_r_ui';
TFmpz_cdiv_qr_ui = function (var q: mpz_t; var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_cdiv_qr_ui(var q: mpz_t; var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_qr_ui';
TFmpz_cdiv_ui = function (const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_cdiv_ui(const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_ui';
TFmpz_cdiv_q_2exp = procedure (var q: mpz_t; const n: mpz_t; b: Cardinal); cdecl; 
//procedure mpz_cdiv_q_2exp(var q: mpz_t; const n: mpz_t; b: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_q_2exp';
TFmpz_cdiv_r_2exp = procedure (var r: mpz_t; const n: mpz_t; b: Cardinal); cdecl; 
//procedure mpz_cdiv_r_2exp(var r: mpz_t; const n: mpz_t; b: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_cdiv_r_2exp';
  //cdiv系は、qを＋∞方向へ丸め、rの符号をdと反対に取る。"ceil"
TFmpz_fdiv_q = procedure (var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_fdiv_q(var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_q';
TFmpz_fdiv_r = procedure (var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_fdiv_r(var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_r';
TFmpz_fdiv_qr = procedure (var q: mpz_t; var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_fdiv_qr(var q: mpz_t; var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_qr';
TFmpz_fdiv_q_ui = function (var q: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_fdiv_q_ui(var q: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_q_ui';
TFmpz_fdiv_r_ui = function (var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_fdiv_r_ui(var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_r_ui';
TFmpz_fdiv_qr_ui = function (var q: mpz_t; var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_fdiv_qr_ui(var q: mpz_t; var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_qr_ui';
TFmpz_fdiv_ui = function (const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_fdiv_ui(const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_ui';
TFmpz_fdiv_q_2exp = procedure (var q: mpz_t; const n: mpz_t; b: Cardinal); cdecl; 
//procedure mpz_fdiv_q_2exp(var q: mpz_t; const n: mpz_t; b: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_q_2exp';
TFmpz_fdiv_r_2exp = procedure (var r: mpz_t; const n: mpz_t; b: Cardinal); cdecl; 
//procedure mpz_fdiv_r_2exp(var r: mpz_t; const n: mpz_t; b: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_r_2exp';
  //fdiv系は、qを－∞方向へ丸め、rの符号をdと同じに取る。"floor"
TFmpz_tdiv_q = procedure (var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_tdiv_q(var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_q';
TFmpz_tdiv_r = procedure (var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_tdiv_r(var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_r';
TFmpz_tdiv_qr = procedure (var q: mpz_t; var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_tdiv_qr(var q: mpz_t; var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_qr';
TFmpz_tdiv_q_ui = function (var q: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_tdiv_q_ui(var q: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_q_ui';
TFmpz_tdiv_r_ui = function (var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_tdiv_r_ui(var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_r_ui';
TFmpz_tdiv_qr_ui = function (var q: mpz_t; var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_tdiv_qr_ui(var q: mpz_t; var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_qr_ui';
TFmpz_tdiv_ui = function (const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_tdiv_ui(const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_ui';
TFmpz_tdiv_q_2exp = procedure (var q: mpz_t; const n: mpz_t; b: Cardinal); cdecl; 
//procedure mpz_tdiv_q_2exp(var q: mpz_t; const n: mpz_t; b: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_q_2exp';
TFmpz_tdiv_r_2exp = procedure (var r: mpz_t; const n: mpz_t; b: Cardinal); cdecl; 
//procedure mpz_tdiv_r_2exp(var r: mpz_t; const n: mpz_t; b: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_tdiv_r_2exp';
  //tdiv系は、qを0に向かって丸め、rの符号をnと同じに取る。"truncate"

//  これらの関数群はすべて、nをdで割り、商q(and/or)余りrを得る。
// 2exp関数についてはd=2^bとする。
//  丸めの方向は、上記のとおり、cdivが正の無限大方向、fdivが負の無限大方向
// tdivがゼロ方向である。
//  これらすべての関数について、n=qd+r 但し 0<=|r|<|d|、を満たす。
//  q系関数は商のみ、r系関数は余りのみ、qr系関数は両方を計算する。
// 但し、qr系関数の引数として、q,rに同じ変数を渡してはならない。
// 渡した場合、結果は予測できない。
//  ui系関数の返り値は、すべてのdiv_ui関数で余りである。
// tdivとcdivにおいては、余りが負になることがあるが、このときの返り値は
// 余りの絶対値となる。
//  2exp系関数は右シフトとビットマスクだが、丸めに関しては他のものと同様である。
// 正のnに対してはmpz_tdiv_q_2expもmpz_fdiv_q_2expも単なる右ビットシフトである。
// 負のnに対しては、mpz_fdiv_q_2expは論理ビット演算関数がおこなうのと同じく
// nを2の補数としての算術ビットシフトである、これに対してmpz_tdiv_q_2expは
// nを符号と絶対値に分けて扱う。
// (訳注)mpz_fdiv_q_2exp: nを2の補数表現として算術右ビットシフト
//       mpz_tdiv_q_2exp: nを符号部と数値部に分けたまま、右ビットシフト

TFmpz_mod = procedure (var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_mod(var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_mod';
TFmpz_mod_ui = function (var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_mod_ui(var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_r_ui';
//  rに n mod d をセットする。除数dの符号は無視される。
// 結果は常に非負である。
//  mpz_mod_uiは、mpz_fdiv_r_uiの別名であり、余りはrにセットされるとともに、
// 返り値として返される。返り値のみが欲しい時は、mpz_fdiv_ui参照。

TFmpz_divexact = procedure (var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_divexact(var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_divexact';
TFmpz_divexact_ui = procedure (var q: mpz_t; const n: mpz_t; d: Cardinal); cdecl; 
//procedure mpz_divexact_ui(var q: mpz_t; const n: mpz_t; d: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_divexact_ui';
//  qに n/d をセットする。これらの関数は、事前にdがnを割り切ることが
// わかっている時のみ、正しい結果を返す。
//  これらの関数は、他の除算関数より速い。有理数を既約分数にする時などの、
// ちょうど割り切れることがわかっている時の、最良の方法である。

TFmpz_divisible_p = function (const n: mpz_t; const d: mpz_t): Integer; cdecl; 
//function mpz_divisible_p(const n: mpz_t; const d: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_divisible_p';
TFmpz_divisible_ui_p = function (const n: mpz_t; d: Cardinal): Integer; cdecl; 
//function mpz_divisible_ui_p(const n: mpz_t; d: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_divisible_ui_p';
TFmpz_divisible_2exp_p = function (const n: mpz_t; b: Cardinal): Integer; cdecl; 
//function mpz_divisible_2exp_p(const n: mpz_t; b: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_divisible_2exp_p';
//  nがdでちょうど割り切れる時に非0を返す。
// 但し、mpz_dividible_2exp_pの場合は、nが2^dでちょうど割り切れる時である。

TFmpz_congruent_p = function (const n: mpz_t; const c: mpz_t; const d: mpz_t): Integer; cdecl; 
//function mpz_congruent_p(const n: mpz_t; const c: mpz_t; const d: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_congruent_p';
TFmpz_congruent_ui_p = function (const n: mpz_t; c: Cardinal; d: Cardinal): Integer; cdecl; 
//function mpz_congruent_ui_p(const n: mpz_t; c: Cardinal; d: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_congruent_ui_p';
TFmpz_congruent_2exp_p = function (const n: mpz_t; const c: mpz_t; b: Cardinal): Integer; cdecl; 
//function mpz_congruent_2exp_p(const n: mpz_t; const c: mpz_t; b: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_congruent_2exp_p';
//  nが、dを法としてcと一致した時（cをdで割った余りと、nをdで割った余りが一致した時）
// 非0を返す。
// 但し、mpz_congruent_2exp_pの場合は、法を2^bとする。

{


  5.7 Exponentiation Functions
}
TFmpz_powm = procedure (var rop: mpz_t; const base: mpz_t; const exp: mpz_t; const m: mpz_t); cdecl; 
//procedure mpz_powm(var rop: mpz_t; const base: mpz_t; const exp: mpz_t; const m: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_powm';
TFmpz_powm_ui = procedure (var rop: mpz_t; const base: mpz_t; exp: Cardinal; const m: mpz_t); cdecl; 
//procedure mpz_powm_ui(var rop: mpz_t; const base: mpz_t; exp: Cardinal; const m: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_powm_ui';
//  ropに base^exp mod m をセットする。
//  逆数(base^(-1) mod m)が存在する時は(Section 5.9 mpz_invert 参照)
// 負のexpを指定できる。負のexpが指定されている時に、逆数が存在しなければ、
// 0による除算がおこされる。

TFmpz_pow_ui = procedure (var rop: mpz_t; const base: mpz_t; exp: Cardinal); cdecl; 
//procedure mpz_pow_ui(var rop: mpz_t; const base: mpz_t; exp: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_pow_ui';
TFmpz_ui_pow_ui = procedure (var rop: mpz_t; base: Cardinal; exp: Cardinal); cdecl; 
//procedure mpz_ui_pow_ui(var rop: mpz_t; base: Cardinal; exp: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_ui_pow_ui';
//  ropに base^expがセットされる。
//  但し、0^0は1となる。

{


  5.8 Root Extraction Funtions
}
TFmpz_root = function (var rop: mpz_t; const op: mpz_t; n: Cardinal): Integer; cdecl; 
//function mpz_root(var rop: mpz_t; const op: mpz_t; n: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_root';
// ropに、opのn乗根の整数部分がセットされる。
// opがropのn乗であれば、非0を返す。

TFmpz_sqrt = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_sqrt(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_sqrt';
// ropに opのルート(2乗根)の整数部分をセットする。

TFmpz_sqrtrem = procedure (var rop1: mpz_t; var rop2: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_sqrtrem(var rop1: mpz_t; var rop2: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_sqrtrem';
//  rop1に opのルートの整数部分、rop2に 残余(op - rop1^2)をセットする。
// opが完全平方であれば、残余rop2は0となる。
//  rop1とrop2に同じ変数が指定された時は、結果は未定義である。

TFmpz_perfect_power_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_perfect_power_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_perfect_power_p';
//  opが"perfect power"であれば非0を返す。
// ここで"perfect power"であるとは、ある整数a,b ただしb>1 が存在して、op = a^b
// であることをいう。
//  この定義によると、0と1はどちらも"perfect power"とみなされる。
// 負のopを与えることはできるが、もちろん、奇数のみしか"perfect power"
// の可能性はない。

TFmpz_perfect_square_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_perfect_square_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_perfect_square_p';
//  opが完全平方、すなわち、opの平方根が整数である時、非0を返す。
// この定義によると、0と1はどちらも完全平方とみなされる。

{


  5.9 Number Theoretic Functions
}
TFmpz_probab_prime_p = function (const n: mpz_t; reps: Integer): Integer; cdecl; 
//function mpz_probab_prime_p(const n: mpz_t; reps: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_probab_prime_p';
//  nが素数であるかどうかを判定する。
// nが確実に素数である時は2、おそらく素数である時(合成数であることを含む)は1、
// 合成数であるときは0を返す。
//  この関数は、試し割りをした後、Miller-Rabin素数テストを繰り返す。
// repは何回繰り返すかで、5-10が適当である。これを増やすことにより、
// 合成数が誤って「おそらく素数」と返される確率を下げることができる。
//  Miller-Rabinおよび同様のテストは正確には合成数テストである。
// テストにパスしない数は合成数であるとわかるが、パスした数は素数かもしれないし、
// 合成数かもしれない。非常に少数の合成数しかテストにパスしないので、
// それゆえに、パスした数はおそらく素数とみなすことができる。
//
// (訳注)Miller-Rabin素数テストは1/4の確率で誤って合成数を擬素数であると
//  判定する。この関数は、ランダムに底をとりテストを繰り返す。
//  5回繰り返した時は(1/4)^5=0.0009765625、約0.1%だけ誤って判定することとなる。

TFmpz_nextprime = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_nextprime(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_nextprime';
//  ropに opより大きい次の素数をセットする
//  この関数は、素数の判定に確率判定アルゴリズムを使用する。
// これは、実用目的には十分適当であるが、合成数を誤って判定する確率が
// ごくごくわずかだけ残る。

TFmpz_gcd = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_gcd(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_gcd';
//  ropに op1とop2の最大公約数をセットする。
// オペランドの片方または両方が負であったとしても、結果は常に正である。

TFmpz_gcd_ui = function (var rop: mpz_t; const op1: mpz_t; op2: Cardinal): Cardinal; cdecl; 
//function mpz_gcd_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_gcd_ui';
//  op1とop2の最大公約数を計算する。ropがNULLでなければ、
// 結果はropに入れられる。
//  もし、結果がunsigned long int(Cardinal)に入りきるのであれば、
// 結果は返り値として返される。もし入りきらなければ、返り値は0となり、
// 結果はop1に等しい。
// op2が0でなければ、結果は常に入りきる。

TFmpz_gcdext = procedure (var g: mpz_t;var s: mpz_t;var t: mpz_t;const a: mpz_t;const b: mpz_t); cdecl; 
//procedure mpz_gcdext(var g: mpz_t;var s: mpz_t;var t: mpz_t;const a: mpz_t;const b: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_gcdext';
//  gに aとbの最大公約数が、as + bt = g を満たす係数がs,t にセットされる。
// a,bの片方もしくは両方が負であっても、gは常に正である。
//  もし、tがNULLならば、その値は計算されない。

TFmpz_lcm = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_lcm(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_lcm';
TFmpz_lcm_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_lcm_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_lcm_ui';
//  ropに op1とop2の最小公倍数をセットする。
// op1とop2の符号にかかわりなく、ropは常に正である。
// op1かop2のどちらかが0であればropは0になる。

TFmpz_invert = function (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t): Integer; cdecl; 
//function mpz_invert(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_invert';
//  法op2の下でのop1の逆数を計算し、結果をropに入れる。
// 逆数が存在すれば返り値は非0で、ropは 0 <= rop < op2 を満たす。
// 逆数が存在しなければ、返り値は0でropは未定義となる。

TFmpz_jacobi = function (const a: mpz_t; const b: mpz_t): Integer; cdecl; 
//function mpz_jacobi(const a: mpz_t; const b: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_jacobi';
//  Jacobi(ヤコビ)記号 (a/b) を計算する。これはbが奇数でのみ定義されている。

TFmpz_legendre = function (const a: mpz_t; const p: mpz_t): Integer; cdecl; 
//function mpz_legendre(const a: mpz_t; const p: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_jacobi';
//  Legendre(ルジェンドル)記号 (a/p) を計算する。これはpが正奇素数でのみ
// 定義されている。このようなpに対して、Jacobi記号と同一である。
//
// この関数はmpz_jacobiの別名である。

TFmpz_kronecker = function (const a: mpz_t; const b: mpz_t): Integer; cdecl; 
//function mpz_kronecker(const a: mpz_t; const b: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_jacobi';
TFmpz_kronecker_si = function (const a: mpz_t; b: Integer): Integer; cdecl; 
//function mpz_kronecker_si(const a: mpz_t; b: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_kronecker_si';
TFmpz_kronecker_ui = function (const a: mpz_t; b: Cardinal): Integer; cdecl; 
//function mpz_kronecker_ui(const a: mpz_t; b: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_kronecker_ui';
TFmpz_si_kronecker = function (a: Integer; const b: mpz_t): Integer; cdecl; 
//function mpz_si_kronecker(a: Integer; const b: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_si_kronecker';
TFmpz_ui_kronecker = function (a: Cardinal; const b: mpz_t): Integer; cdecl; 
//function mpz_ui_kronecker(a: Cardinal; const b: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_ui_kronecker';
//  Jacobi(ヤコビ)記号 (a/b) をKronecker(クロネッカー)拡張、
// aが奇数のとき(a/2)=(2/a),aが偶数の時(a/2)=0 を用いて計算する。
//  bが奇数のときは、Jacobi記号はKronecker記号と同一である。
// このため、mpz_kronecker_uiなどの関数は、引数の型の違うJacobi記号としても
// 使用することができる。
//
// mpz_kroneckerはmpz_jacobiの別名である。

TFmpz_remove = function (var rop: mpz_t; const op: mpz_t; const f: mpz_t): Cardinal; cdecl; 
//function mpz_remove(var rop: mpz_t; const op: mpz_t; const f: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_remove';
//  opから因子fをすべてはらい、結果をropにストアする。返り値はいくつの因子が
// はらわれたかである。

TFmpz_fac_ui = procedure (var rop: mpz_t; op: Cardinal); cdecl; 
//procedure mpz_fac_ui(var rop: mpz_t; op: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fac_ui';
//  ropに op! (opの階乗)をセットする。

TFmpz_bin_ui = procedure (var rop: mpz_t; const n: mpz_t; k: Cardinal); cdecl; 
//procedure mpz_bin_ui(var rop: mpz_t; const n: mpz_t; k: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_bin_ui';
TFmpz_bin_uiui = procedure (var rop: mpz_t; n: Cardinal; k: Cardinal); cdecl; 
//procedure mpz_bin_uiui(var rop: mpz_t; n: Cardinal; k: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_bin_uiui';
//  二項係数(binomial coefficient) (n,k)を計算し結果をropにストアする。
// mpz_bim_uiで、nに負の値は許され、(-n,k) = (-1)^k (n+k-1,k)が使われる。
// Knuth volume 1 section 1.2.6 part G を参照。

TFmpz_fib_ui = procedure (var fn: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_fib_ui(var fn: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fib_ui';
TFmpz_fib2_ui = procedure (var fn: mpz_t; var fnsub1: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_fib2_ui(var fn: mpz_t; var fnsub1: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fib2_ui';
// mpz_fib_uiは、fnにn番目のFibonacci数 Fn をセットする。
// mpz_fib2_uiは、fnにＦn、fnsub1にＦn-1をセットする。
//  これらの関数は、独立したFibonacci数を計算するために設計されている。
// 連続した値が欲しい時は、mpz_fib2_uiで始めて、定義Ｆn+1=Ｆn+Ｆn-1を繰り返す
// などの方法がベストである。

TFmpz_lucnum_ui = procedure (var ln: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_lucnum_ui(var ln: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_lucnum_ui';
TFmpz_lucnum2_ui = procedure (var ln: mpz_t; var lnsub1: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_lucnum2_ui(var ln: mpz_t; var lnsub1: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_lucnum2_ui';
// mpz_lucnum_uiはlnにn番目のLucas数 Ｌnをセットする。
// mpz_lucnum2_uiはlnにＬn、lnsub1にＬn-1をセットする。
//  これらの関数は、独立したLucas数を計算するために設計されている。
// 連続した値が欲しい時は、mpz_lucnum2_uiで始めて、定義Ｌn+1=Ｌn+Ｌn-1を繰り返す
// などの方法がベストである。

//  Fibonacci数とLucas数は関連した数列であるので、mpz_fib2_uiとmpz_lucnum2_uiを
// 両方呼ぶ必要はまったくない。FibonacciからLucasへの変換公式はSection 16.7.4
// [Lucas Numbers Algorithm]にあり、その逆も容易である。

{


  5.10 Comparison Functions
}
TFmpz_cmp = function (const op1: mpz_t; const op2: mpz_t): Integer; cdecl; 
//function mpz_cmp(const op1: mpz_t; const op2: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmp';
TFmpz_cmp_d = function (const op1: mpz_t; op2: Double): Integer; cdecl; 
//function mpz_cmp_d(const op1: mpz_t; op2: Double): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmp_d';
TFmpz_cmp_si = function (const op1: mpz_t; op2: Integer): Integer; cdecl; 
//function mpz_cmp_si(const op1: mpz_t; op2: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmp_si';
TFmpz_cmp_ui = function (const op1: mpz_t; op2: Cardinal): Integer; cdecl; 
//function mpz_cmp_ui(const op1: mpz_t; op2: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmp_ui';
// op1とop2を比較し、op1>op2のとき正、op1=op2のとき0、op1<op2のとき負を返す

TFmpz_cmpabs = function (const op1: mpz_t; const op2: mpz_t): Integer; cdecl; 
//function mpz_cmpabs(const op1: mpz_t; const op2: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmpabs';
TFmpz_cmpabs_d = function (const op1: mpz_t; op2: Double): Integer; cdecl; 
//function mpz_cmpabs_d(const op1: mpz_t; op2: Double): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmpabs_d';
TFmpz_cmpabs_ui = function (const op1: mpz_t; op2: Cardinal): Integer; cdecl; 
//function mpz_cmpabs_ui(const op1: mpz_t; op2: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmpabs_ui';
//  op1とop2の絶対値を比較し、|op1|>|op2|のとき正、|op1|=|op2|のとき0、
// |op1|<|op2|のとき負を返す

function mpz_sgn(const op: mpz_t): Integer;
//  op>0のとき+1、op=0のとき0、op<0のとき-1を返す。
//  この関数はオリジナルはマクロで実装されている。

{


  5.11 Logical and Bit Manipulation Functions
    以下の関数は2の補数算術が使用されているようにふるまう。
    (しかし実際の実装は符号と絶対値が分離されている)
    最下位ビットはbit 0 である。
}
type
TFmpz_and = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl;
//procedure mpz_and(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_and';
// and
TFmpz_ior = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_ior(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_ior';
// inclusive-or
TFmpz_xor = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_xor(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_xor';
TFmpz_eor = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_eor(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_xor';
// exclusive-or
// op1とop2とのビット演算結果をropにセットする

TFmpz_com = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_com(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_com';
// opの1の補数表現(全ビット反転)をropにセットする

TFmpz_popcount = function (const op: mpz_t): Cardinal; cdecl; 
//function mpz_popcount(const op: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_popcount';
// op>=0のときは、opのバイナリ表記での1の立っているbit数(population count)を返す。
// op<0のときは、1の数は無限大となるので、unsigned long(Cardinal)の最大値を
// 返す。

TFmpz_hamdist = function (const op1: mpz_t; const op2: mpz_t): Cardinal; cdecl; 
//function mpz_hamdist(const op1: mpz_t; const op2: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_hamdist';
//  op1とop2が共に>=0であるか<0であるとき、2つのオペランドのハミング距離を返す。
// ハミング距離(hamming distance)は、bitごとでop1とop2が異なる値をとるbitの数である。
//  どちらかが>=0でもう片方が<0であるときは、異なるbitの数は無限大となるので、
// 返り値はunsigned long(Cardinal)の最大値となる。

TFmpz_scan0 = function (const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; 
//function mpz_scan0(const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_scan0';
TFmpz_scan1 = function (const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; 
//function mpz_scan1(const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_scan1';
//  opを、starting_bitから始めて、上位bitに向かって、最初に0 or 1であるbitが
// 見つかるまでスキャンする。返り値は見つかったbitのインデックスである。
//  starting_bit自体が探すbitであったときは、starting_bitが返される。
//  そのようなbitが見つからなかったときはULONG_MAX(unsigned longの最大値)が
// 返される。これは、mpz_scan0が正の数の端を過ぎたとき、または、
// mpz_scan1が負の数の端を過ぎたときに発生する。

TFmpz_setbit = procedure (var rop: mpz_t; bit_index: Cardinal); cdecl; 
//procedure mpz_setbit(var rop: mpz_t; bit_index: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_setbit';
// ropのbit_index bitを立てる

TFmpz_clrbit = procedure (var rop: mpz_t; bit_index: Cardinal); cdecl; 
//procedure mpz_clrbit(var rop: mpz_t; bit_index: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_clrbit';
// ropのbit_index bitを消す

TFmpz_tstbit = function (const op: mpz_t; bit_index: Cardinal): Integer; cdecl; 
//function mpz_tstbit(const op: mpz_t; bit_index: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_tstbit';
// opのbit_index bitをテストし、その結果 0か1 を返す。

{


  5.12 Input and Output Functions

    (移植者注)このsectionの関数群はFILE構造体の移植が困難であるため
     宣言していない
}

{


  5.13 Random Number Functions

// 保留

}

{


  5.14 Integer Import and Export
    以下の関数により、mpz_t変数は自由なバイナリデータ列(から/に)変換できる
}
TFmpz_import = procedure (var rop: mpz_t; count, order, size, endian, nails: Integer; const op); cdecl; 
//procedure mpz_import(var rop: mpz_t; count, order, size, endian, nails: Integer; const op); cdecl; external 'cyggmp-3.dll' name '__gmpz_import';
//  ropにopの配列データをセットする
//  パラメータはデータのフォーマットを指定する。
//
// size: それぞれの配列要素のbyte数
// count: 配列要素の数
// order: =(1,-1), 配列のエンディアン指定
//  1 =最上位要素が配列の最初にストアされている
//  -1=最下位要素が配列の最初にストアされている
// endian: =(1,-1,0), 配列要素の中でのエンディアン指定
//  1 =最上位byteが最初に来る(ビッグエンディアン)
//  -1=最下位byteが最初に来る(リトルエンディアン)
//  0 =CPUのエンディアンに従う
// nails: それぞれの配列要素の中で最上位nails bitは捨てられる
//  ここに0を指定すると配列要素は全bit使用される
//
//  データには符号情報は含まれていないので、ropは正の整数になる。
// プログラムは必要があれば、mpz_negなどを用いて自分で符号をセットしなくては
// ならない。
//  opにアライメント制限はなく、どんなアドレスでも許される。
//
// (訳注)例は省略。パラメータ説明は箇条書きに変更。

TFmpz_export = function (var rop; var countp: Integer; order, size, endian, nails: Integer; const op: mpz_t): Pointer; cdecl; 
//function mpz_export(var rop; var countp: Integer; order, size, endian, nails: Integer; const op: mpz_t): Pointer; cdecl; external 'cyggmp-3.dll' name '__gmpz_export';
//  opから配列データに変換してropに書き込む
//  (訳注)説明しないパラメータはmpz_importと同じ意味である。
//  変換された配列要素の数は*countpに書き込まれるが、countpにNULLを指定すると
// 要素数は捨てられる。
// ropにはデータを書き込むのに十分な領域が必要である。ropにNULLを指定すると
// 結果の配列は、現在のGMPアロケート関数を使って必要な領域を確保してそこに
// 書き込まれる。領域を与えられたか確保したかにかかわらず、返り値は結果への
// ポインタである。
//  opが非0であれば、最上位配列要素は非0である。opが0であれば、countは0を返し
// ropには何も書き込まれない。このとき、ropがNULLであれば、領域は確保されず、
// NULLが返される。
//  符号は無視され、絶対値がエクスポートされる。プログラムは必要があれば、
// mpz_sgnを使い符号を取得しなければならない。
//  opにアライメント制限はなく、どんなアドレスでも許される。
//  プログラムが自身で領域を確保するときは、以下の式で必要な領域を計算できる。
//   numb = 8*size - nail;
//   count = (mpz_sizeinbase(z,2) + numb-1) / numb;
//   p = malloc(count*size);
//  ここで、zが0であれば本当は領域は必要ではないが、mpz_sizeinbaseは常に1以上を
// 返すため、countは1以上になる。これはmalloc(0)で問題が発生することを避けること
// ができるためでもある。

{
  5.15 Miscellaneous Functions

}
TFmpz_fits_ulong_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_fits_ulong_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_fits_ulong_p';
TFmpz_fits_slong_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_fits_slong_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_fits_slong_p';
TFmpz_fits_uint_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_fits_uint_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_fits_uint_p';
TFmpz_fits_sint_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_fits_sint_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_fits_sint_p';
TFmpz_fits_ushort_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_fits_ushort_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_fits_ushort_p';
TFmpz_fits_sshort_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_fits_sshort_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_fits_sshort_p';
// おのおのopが収まりきれば非0、溢れるなら0を返す

function mpz_odd_p(const op: mpz_t): Boolean;
function mpz_even_p(const op: mpz_t): Boolean;
// opが偶数か奇数かを判定する。
// この関数はオリジナルではマクロである。

type
TFmpz_size = function (const op: mpz_t): Integer; cdecl;
//function mpz_size(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_size';
// opのlimbの数を返す。opが0の時は0

TFmpz_sizeinbase = function (const op: mpz_t; base: Integer): Integer; cdecl; 
//function mpz_sizeinbase(const op: mpz_t; base: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_sizeinbase';
//  opをbase進数表記した時のサイズを返す。baseは2-36が有効である。
// 符号は無視され、絶対値が使用される。
// 結果はちょうどか、1だけ大きくなる。
// baseが2の累乗であるなら、結果はいつも正しい。
// opが0であるなら、常に1を返す。
//  この関数は、opを文字列にする時に必要な領域を知るのに使うことができる。
// 通常、必要な領域は、この関数の返り値より2だけ大きい。
// 負符号とnull-terminatorの分である。
//  mpz_sizeinbase(op,2)は、1から数えて一番大きい立っているビットの場所を
// 知るのに使用できる。(bitwise関数は0から数える)


{


  10 Formatted Output

    10.1 Format Strings
      （書式の詳細はヘルプ参照）

    10.2 Functions
      これらの関数群は、対応するCの関数と同様である。
      書式文字列が不正であったり、可変引数が変換指定子と一致しない場合の
      動作は予測不可能であることを強調しておく。

      (移植者注)
      vprintf系列の関数は、可変引数の構成がDelphiと異なるので宣言していない。
      fprintf,asprintf,obstack_printfについても移植が困難であるため
      宣言していない。

      可変引数にGMP構造体を渡す時は、ポインタを渡すこと。
      そのまま指定すると、値渡しになり動作しない。

      型なしオープンパラメータ版はラッパーであるが、Delphiとgccの型の互換性に
      気をつけること。
      64bit整数型には対応していない。
      浮動小数点型はExtended->Doubleの変換を行い、doubleのみ対応している。
      stringを与えるときはヌルターミネートを呼び出し側で保証すること。
}
type
TF_gmp_printf = function: Integer; cdecl;
//function _gmp_printf(const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_printf';
function gmp_printf(const fmt: String; const Args: array of const): Integer;
// 標準出力に出力する。返り値は、エラー時-1、正常終了で書き込んだ文字数。
// Delphiではコンソールを持たないプログラムでは無効である。
//
// 可変引数を取るcdecl呼び出し原版では浮動小数点型がdoubleであるので注意。
// オープンパラメータラッパー版では浮動小数点型Extendedをdoubleに落としている。

type
TF_gmp_sprintf = function: Integer; cdecl;
//function _gmp_sprintf(buf: PChar; const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_sprintf';
function gmp_sprintf(buf: PChar; const fmt: String; const Args: array of const): Integer;
//  null終末文字列をbufに出力する。返り値はnullを除いた書き込んだ文字数。
//  bufとfmtの領域が重なることは許されていない。
//  この関数は、bufの確保領域を越えて書き込むのを防ぐ手段をもたないため、
// 推奨されない。
//
// 可変引数を取るcdecl呼び出し原版では浮動小数点型がdoubleであるので注意。
// オープンパラメータラッパー版では浮動小数点型Extendedをdoubleに落としている。

type
TF_gmp_snprintf = function: Integer; cdecl;
//function _gmp_snprintf(buf: PChar; size: Integer; const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_snprintf';
function gmp_snprintf(buf: PChar; size: Integer; const fmt: String; const Args: array of const): Integer; overload;
function gmp_snprintf(var buf: String; const fmt: String; const Args: array of const): Integer; overload;
//  null終末文字列をbufに出力する。sizeを超えて書き込まれることはない。
// 出力全体を受け取るには、文字列とnull-terminatorを書き込むのに十分な
// 大きさをsizeに指定しなければならない。
//  返り値は、nullを除いた書き込んだ(はず)の文字数である。
// もし、result>=sizeであるならば、実際の出力はsize-1文字の出力とnullに
// 切り捨てられている。
//  bufとfmtの領域が重なることは許されていない。
//  返り値はISO C99 snprintf形式である。C libraryのvsprintfが古いGLIBC 2.0.x
// をとっていたとしても、これは変わらない。
//
//  可変引数を取るcdecl呼び出し原版では浮動小数点型がdoubleであるので注意。
//  オープンパラメータラッパー版では浮動小数点型Extendedをdoubleに落としている。
//  string引数版は呼び出し側でSetLengthで確保された領域を出力領域とする。
// 出力がbufより小さければ自動的に領域はトリミングされる。

{


  10 Formatted Input

    10.1 Formatted Input Strings
      （書式の詳細はヘルプ参照）

    10.2 Formatted Input Functions
      これらの関数群は、対応するCの関数と同様である。
      書式文字列が不正であったり、可変引数が変換指定子と一致しない場合の
      動作は予測不可能であることを強調しておく。
      書式文字列と変換結果の出力変数群との領域が重なることは認められていない。

      (移植者注)
      vprintf系列の関数は、可変引数の構成がDelphiと異なるので宣言していない。
      fprintf,についても移植が困難であるため
      宣言していない。

      可変引数にGMP構造体を渡す時は、ポインタを渡すこと。
      そのまま指定すると、値渡しになり動作しない。
}
type
TF_gmp_scanf = function: Integer; cdecl;
//function _gmp_scanf(const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_scanf';
function gmp_scanf(const fmt: String; const Args: array of Pointer): Integer;
// 標準入力から読む

type
TF_gmp_sscanf = function: Integer; cdecl;
//function _gmp_sscanf(const s: PChar; const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_sscanf';
function gmp_sscanf(const s: String; const fmt: String; const Args: array of Pointer): Integer;
// sに指定されたnull終末文字列から読む

//  この関数の返り値は、標準のC99 scanfと同じく、正常に解釈されストアされた
// フィールドの数である。'%n'で指定したフィールドと、'*'により入力抑制した
// フィールドは、返り値のカウントに入れない。
//  それ以前の非入力抑制フィールドに1つもマッチしていない状態で、
// マッチすべきフィールドがあるのに、ファイルの終末,ファイルエラー,文字列の終末
// のいずれかに遭遇した場合は、返り値に0ではなくEOFを返す。
// 書式文字列中のリテラル文字と'%n'以外のフィールドはマッチが要求される。
// 書式文字列中のwhitespaseは任意一致でしかなく、この形式のEOFは発生しない。
// 先行whitespaseは、読み込んで破棄され、マッチの数に入れない。
//
//  オープンパラメータ版はラッパーである。
// stringのアドレスを渡すときはSetLengthなどで確保しておくこと。





function mpf_sgn(const op: mpf_t): Integer;
function mpq_sgn(const op: mpq_t): Integer;

(*
enum
{
  GMP_ERROR_NONE = 0,
  GMP_ERROR_UNSUPPORTED_ARGUMENT = 1,
  GMP_ERROR_DIVISION_BY_ZERO = 2,
  GMP_ERROR_SQRT_OF_NEGATIVE = 4,
  GMP_ERROR_INVALID_ARGUMENT = 8,
  GMP_ERROR_ALLOCATE = 16,
  GMP_ERROR_BAD_STRING = 32,
  GMP_ERROR_UNUSED_ERROR
};

/* Major version number is the value of __GNU_MP__ too, above and in mp.h. */
#define __GNU_MP_VERSION 4
#define __GNU_MP_VERSION_MINOR 1
#define __GNU_MP_VERSION_PATCHLEVEL 3

#define __GMP_H__
#endif /* __GMP_H__ */
*)
const
  __GNU_MP_VERSION = 4;
  __GNU_MP_VERSION_MINOR = 1;
  __GNU_MP_VERSION_PATCHLEVEL = 3;


//動的ロードDLL関数宣言
var
  mpz_init: TFmpz_init;
  mpz_init2: TFmpz_init2;
  mpz_clear: TFmpz_clear;
  mpz_realloc2: TFmpz_realloc2;
  _mpz_array_init: TF_mpz_array_init;
  _mpz_realloc: TF_mpz_realloc;
  mpz_set: TFmpz_set;
  mpz_set_ui: TFmpz_set_ui;
  mpz_set_si: TFmpz_set_si;
  mpz_set_d: TFmpz_set_d;
  mpz_set_q: TFmpz_set_q;
  mpz_set_f: TFmpz_set_f;
  mpz_set_str: TFmpz_set_str;
  mpz_swap: TFmpz_swap;
  mpz_init_set: TFmpz_init_set;
  mpz_init_set_ui: TFmpz_init_set_ui;
  mpz_init_set_si: TFmpz_init_set_si;
  mpz_init_set_d: TFmpz_init_set_d;
  mpz_init_set_str: TFmpz_init_set_str;
  mpz_get_ui: TFmpz_get_ui;
  mpz_get_si: TFmpz_get_si;
  mpz_get_d: TFmpz_get_d;
  mpz_get_d_2exp: TFmpz_get_d_2exp;
  _mpz_get_str: TF_mpz_get_str;
  mpz_getlimbn: TFmpz_getlimbn;
  mpz_add: TFmpz_add;
  mpz_add_ui: TFmpz_add_ui;
  mpz_sub: TFmpz_sub;
  mpz_sub_ui: TFmpz_sub_ui;
  mpz_ui_sub: TFmpz_ui_sub;
  mpz_mul: TFmpz_mul;
  mpz_mul_ui: TFmpz_mul_ui;
  mpz_mul_si: TFmpz_mul_si;
  mpz_addmul: TFmpz_addmul;
  mpz_addmul_ui: TFmpz_addmul_ui;
  mpz_submul: TFmpz_submul;
  mpz_submul_ui: TFmpz_submul_ui;
  mpz_mul_2exp: TFmpz_mul_2exp;
  mpz_neg: TFmpz_neg;
  mpz_abs: TFmpz_abs;
  mpz_cdiv_q: TFmpz_cdiv_q;
  mpz_cdiv_r: TFmpz_cdiv_r;
  mpz_cdiv_qr: TFmpz_cdiv_qr;
  mpz_cdiv_q_ui: TFmpz_cdiv_q_ui;
  mpz_cdiv_r_ui: TFmpz_cdiv_r_ui;
  mpz_cdiv_qr_ui: TFmpz_cdiv_qr_ui;
  mpz_cdiv_ui: TFmpz_cdiv_ui;
  mpz_cdiv_q_2exp: TFmpz_cdiv_q_2exp;
  mpz_cdiv_r_2exp: TFmpz_cdiv_r_2exp;
  mpz_fdiv_q: TFmpz_fdiv_q;
  mpz_fdiv_r: TFmpz_fdiv_r;
  mpz_fdiv_qr: TFmpz_fdiv_qr;
  mpz_fdiv_q_ui: TFmpz_fdiv_q_ui;
  mpz_fdiv_r_ui: TFmpz_fdiv_r_ui;
  mpz_fdiv_qr_ui: TFmpz_fdiv_qr_ui;
  mpz_fdiv_ui: TFmpz_fdiv_ui;
  mpz_fdiv_q_2exp: TFmpz_fdiv_q_2exp;
  mpz_fdiv_r_2exp: TFmpz_fdiv_r_2exp;
  mpz_tdiv_q: TFmpz_tdiv_q;
  mpz_tdiv_r: TFmpz_tdiv_r;
  mpz_tdiv_qr: TFmpz_tdiv_qr;
  mpz_tdiv_q_ui: TFmpz_tdiv_q_ui;
  mpz_tdiv_r_ui: TFmpz_tdiv_r_ui;
  mpz_tdiv_qr_ui: TFmpz_tdiv_qr_ui;
  mpz_tdiv_ui: TFmpz_tdiv_ui;
  mpz_tdiv_q_2exp: TFmpz_tdiv_q_2exp;
  mpz_tdiv_r_2exp: TFmpz_tdiv_r_2exp;
  mpz_mod: TFmpz_mod;
  mpz_mod_ui: TFmpz_mod_ui;
  mpz_divexact: TFmpz_divexact;
  mpz_divexact_ui: TFmpz_divexact_ui;
  mpz_divisible_p: TFmpz_divisible_p;
  mpz_divisible_ui_p: TFmpz_divisible_ui_p;
  mpz_divisible_2exp_p: TFmpz_divisible_2exp_p;
  mpz_congruent_p: TFmpz_congruent_p;
  mpz_congruent_ui_p: TFmpz_congruent_ui_p;
  mpz_congruent_2exp_p: TFmpz_congruent_2exp_p;
  mpz_powm: TFmpz_powm;
  mpz_powm_ui: TFmpz_powm_ui;
  mpz_pow_ui: TFmpz_pow_ui;
  mpz_ui_pow_ui: TFmpz_ui_pow_ui;
  mpz_root: TFmpz_root;
  mpz_sqrt: TFmpz_sqrt;
  mpz_sqrtrem: TFmpz_sqrtrem;
  mpz_perfect_power_p: TFmpz_perfect_power_p;
  mpz_perfect_square_p: TFmpz_perfect_square_p;
  mpz_probab_prime_p: TFmpz_probab_prime_p;
  mpz_nextprime: TFmpz_nextprime;
  mpz_gcd: TFmpz_gcd;
  mpz_gcd_ui: TFmpz_gcd_ui;
  mpz_gcdext: TFmpz_gcdext;
  mpz_lcm: TFmpz_lcm;
  mpz_lcm_ui: TFmpz_lcm_ui;
  mpz_invert: TFmpz_invert;
  mpz_jacobi: TFmpz_jacobi;
  mpz_legendre: TFmpz_legendre;
  mpz_kronecker: TFmpz_kronecker;
  mpz_kronecker_si: TFmpz_kronecker_si;
  mpz_kronecker_ui: TFmpz_kronecker_ui;
  mpz_si_kronecker: TFmpz_si_kronecker;
  mpz_ui_kronecker: TFmpz_ui_kronecker;
  mpz_remove: TFmpz_remove;
  mpz_fac_ui: TFmpz_fac_ui;
  mpz_bin_ui: TFmpz_bin_ui;
  mpz_bin_uiui: TFmpz_bin_uiui;
  mpz_fib_ui: TFmpz_fib_ui;
  mpz_fib2_ui: TFmpz_fib2_ui;
  mpz_lucnum_ui: TFmpz_lucnum_ui;
  mpz_lucnum2_ui: TFmpz_lucnum2_ui;
  mpz_cmp: TFmpz_cmp;
  mpz_cmp_d: TFmpz_cmp_d;
  mpz_cmp_si: TFmpz_cmp_si;
  mpz_cmp_ui: TFmpz_cmp_ui;
  mpz_cmpabs: TFmpz_cmpabs;
  mpz_cmpabs_d: TFmpz_cmpabs_d;
  mpz_cmpabs_ui: TFmpz_cmpabs_ui;
  mpz_and: TFmpz_and;
  mpz_ior: TFmpz_ior;
  mpz_xor: TFmpz_xor;
  mpz_eor: TFmpz_eor;
  mpz_com: TFmpz_com;
  mpz_popcount: TFmpz_popcount;
  mpz_hamdist: TFmpz_hamdist;
  mpz_scan0: TFmpz_scan0;
  mpz_scan1: TFmpz_scan1;
  mpz_setbit: TFmpz_setbit;
  mpz_clrbit: TFmpz_clrbit;
  mpz_tstbit: TFmpz_tstbit;
  mpz_import: TFmpz_import;
  mpz_export: TFmpz_export;
  mpz_fits_ulong_p: TFmpz_fits_ulong_p;
  mpz_fits_slong_p: TFmpz_fits_slong_p;
  mpz_fits_uint_p: TFmpz_fits_uint_p;
  mpz_fits_sint_p: TFmpz_fits_sint_p;
  mpz_fits_ushort_p: TFmpz_fits_ushort_p;
  mpz_fits_sshort_p: TFmpz_fits_sshort_p;
  mpz_size: TFmpz_size;
  mpz_sizeinbase: TFmpz_sizeinbase;
  _gmp_printf: TF_gmp_printf;
  _gmp_sprintf: TF_gmp_sprintf;
  _gmp_snprintf: TF_gmp_snprintf;
  _gmp_scanf: TF_gmp_scanf;
  _gmp_sscanf: TF_gmp_sscanf;


implementation

uses
  SysUtils, Windows;

var
  FDLLHandle: HMODULE;


procedure mpz_array_init(int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); overload;
begin
    _mpz_array_init(int_array,array_size,fixed_num_bits);
end;

procedure mpz_array_init(var int_array: array of mpz_t; fixed_num_bits: mp_size_t); overload;
var
  size: Integer;
begin
    size := length(int_array);
    if size <> 0 then
      _mpz_array_init(mpz_ptr(@int_array[0]),size,fixed_num_bits);
end;

function mpz_get_str(str: PChar; base: Integer; const op: mpz_t): PChar; overload;
begin
    Result := _mpz_get_str(str,base,op);
end;

function mpz_get_str(const op: mpz_t; base: Integer): String; overload;
begin
    SetLength(Result, mpz_sizeinbase(op,base)+2);
    _mpz_get_str(@Result[1],base,op);
    SetLength(Result,strlen(PChar(Result)));
end;


function gmp_printf(const fmt: String; const Args: array of const): Integer;
var
  Argc: Integer;
begin
    Argc := length(Args);
    asm
      push  edi
      mov   ecx,Argc;
      test  ecx,ecx;
      jz    @call_original;
     @push_loop:
      mov   edx,Args;
      dec   ecx;
      lea   edi,[edx+ecx*8];
      xor   eax,eax;
      mov   al,TVarRec[edi].VType;
      cmp   eax,vtExtended;
      mov   eax,[edi];
      jz    @case_vtExtended;
     @else:
      push  eax;
      test  ecx,ecx;
      jnz   @push_loop;
      jmp   @call_original;
     @case_vtExtended:
      fld   tbyte ptr [eax];
      sub   esp,8;
      fstp  qword ptr [esp];
      inc   Argc;
      test  ecx,ecx;
      jnz   @push_loop;
     @call_original:
      mov   eax,fmt;
      call  system.@LStrToPChar;
      push  eax;
      call  _gmp_printf;
      mov   Result,eax;
      mov   ecx,Argc;
      lea   ecx,[ecx*4+4];
      add   esp,ecx;
      pop   edi;
    end;
end;

function gmp_sprintf(buf: PChar; const fmt: String; const Args: array of const): Integer;
var
  Argc: Integer;
begin
    Argc := length(Args);
    asm
      push  edi;
      mov   ecx,Argc;
      test  ecx,ecx;
      jz    @call_original;
     @push_loop:
      mov   edx,Args;
      dec   ecx;
      lea   edi,[edx+ecx*8];
      xor   eax,eax;
      mov   al,TVarRec[edi].VType;
      cmp   eax,vtExtended;
      mov   eax,[edi];
      jz    @case_vtExtended;
     @else:
      push  eax;
      test  ecx,ecx;
      jnz   @push_loop;
      jmp   @call_original;
     @case_vtExtended:
      fld   tbyte ptr [eax];
      sub   esp,8;
      fstp  qword ptr [esp];
      inc   Argc;
      test  ecx,ecx;
      jnz   @push_loop;
     @call_original:
      mov   eax,fmt;
      call  system.@LStrToPChar;
      push  eax;
      push  buf;
      call  _gmp_sprintf;
      mov   Result,eax;
      mov   ecx,Argc;
      lea   ecx,[ecx*4+8];
      add   esp,ecx;
      pop   edi;
    end;
end;

function gmp_snprintf(buf: PChar; size: Integer; const fmt: String; const Args: array of const): Integer; overload;
var
  Argc: Integer;
begin
    Argc := length(Args);
    asm
      push  edi;
      mov   ecx,Argc;
      test  ecx,ecx;
      jz    @call_original;
     @push_loop:
      mov   edx,Args;
      dec   ecx;
      lea   edi,[edx+ecx*8];
      xor   eax,eax;
      mov   al,TVarRec[edi].VType;
      cmp   eax,vtExtended;
      mov   eax,[edi];
      jz    @case_vtExtended;
     @else:
      push  eax;
      test  ecx,ecx;
      jnz   @push_loop;
      jmp   @call_original;
     @case_vtExtended:
      fld   tbyte ptr [eax];
      sub   esp,8;
      fstp  qword ptr [esp];
      inc   Argc;
      test  ecx,ecx;
      jnz   @push_loop;
     @call_original:
      mov   eax,fmt;
      call  system.@LStrToPChar;
      push  eax;
      push  size;
      push  buf;
      call  _gmp_snprintf;
      mov   Result,eax;
      mov   ecx,Argc;
      lea   ecx,[ecx*4+12];
      add   esp,ecx;
      pop   edi;
    end;
end;

function gmp_snprintf(var buf: String; const fmt: String; const Args: array of const): Integer; overload;
begin
    Result := gmp_snprintf(PChar(buf),length(buf),fmt,Args);
    if Result < length(buf) then
      SetLength(buf,Result);
end;

function gmp_scanf(const fmt: String; const Args: array of Pointer): Integer;
var
  Argc: Integer;
begin
    Argc := length(Args);
    asm
      mov   ecx,Argc;
      test  ecx,ecx;
      jz    @call_original;
     @push_loop:
      mov   edx,Args;
      dec   ecx;
      mov   eax,[edx+ecx*4];
      push  eax;
      jnz   @push_loop;
     @call_original:
      mov   eax,fmt;
      call  system.@LStrToPChar;
      push  eax;
      call  _gmp_scanf;
      mov   Result,eax;
      mov   ecx,Argc;
      lea   ecx,[ecx*4+4];
      add   esp,ecx;
    end;
end;

function gmp_sscanf(const s: String; const fmt: String; const Args: array of Pointer): Integer;
var
  Argc: Integer;
begin
    Argc := length(Args);
    asm
      mov   ecx,Argc;
      test  ecx,ecx;
      jz    @call_original;
     @push_loop:
      mov   edx,Args;
      dec   ecx;
      mov   eax,[edx+ecx*4];
      push  eax;
      jnz   @push_loop;
     @call_original:
      mov   eax,fmt;
      call  system.@LStrToPChar;
      push  eax;
      mov   eax,s;
      call  system.@LStrToPChar;
      push  eax;
      call  _gmp_sscanf;
      mov   Result,eax;
      mov   ecx,Argc;
      lea   ecx,[ecx*4+8];
      add   esp,ecx;
    end;
end;


{
/* Using "&" rather than "&&" means these can come out branch-free.  Every
   mpz_t has at least one limb allocated, so fetching the low limb is always
   allowed.  */
#define mpz_odd_p(z)   (((z)->_mp_size != 0) & __GMP_CAST (int, (z)->_mp_d[0]))
#define mpz_even_p(z)  (! mpz_odd_p (z))
}
function mpz_odd_p(const op: mpz_t): Boolean;
begin
    Result := (op._mp_size <> 0) and ((op._mp_d^ and 1) <> 0);
end;

function mpz_even_p(const op: mpz_t): Boolean;
begin
    Result := (op._mp_size <> 0) and ((op._mp_d^ and 1) = 0);
end;

{
/* Allow faster testing for negative, zero, and positive.  */
#define mpz_sgn(Z) ((Z)->_mp_size < 0 ? -1 : (Z)->_mp_size > 0)
#define mpf_sgn(F) ((F)->_mp_size < 0 ? -1 : (F)->_mp_size > 0)
#define mpq_sgn(Q) ((Q)->_mp_num._mp_size < 0 ? -1 : (Q)->_mp_num._mp_size > 0)
}
function mpz_sgn(const op: mpz_t): Integer;
begin
    if op._mp_size > 0 then
      Result := 1
    else if op._mp_size < 0 then
      Result := -1
    else
      Result := 0;
end;

function mpf_sgn(const op: mpf_t): Integer;
begin
    if op._mp_size > 0 then
      Result := 1
    else if op._mp_size < 0 then
      Result := -1
    else
      Result := 0;
end;

function mpq_sgn(const op: mpq_t): Integer;
begin
    if op._mp_num._mp_size > 0 then
      Result := 1
    else if op._mp_num._mp_size < 0 then
      Result := -1
    else
      Result := 0;
end;

procedure LoadDLL;
begin
    FDLLHandle := LoadLibrary('cyggmp-3.dll');
    if FDLLHandle <> 0 then
    begin
      @mpz_init := GetProcAddress(FDLLHandle, '__gmpz_init');
      @mpz_init2 := GetProcAddress(FDLLHandle, '__gmpz_init2');
      @mpz_clear := GetProcAddress(FDLLHandle, '__gmpz_clear');
      @mpz_realloc2 := GetProcAddress(FDLLHandle, '__gmpz_realloc2');
      @_mpz_array_init := GetProcAddress(FDLLHandle, '__gmpz_array_init');
      @_mpz_realloc := GetProcAddress(FDLLHandle, '__gmpz_realloc');
      @mpz_set := GetProcAddress(FDLLHandle, '__gmpz_set');
      @mpz_set_ui := GetProcAddress(FDLLHandle, '__gmpz_set_ui');
      @mpz_set_si := GetProcAddress(FDLLHandle, '__gmpz_set_si');
      @mpz_set_d := GetProcAddress(FDLLHandle, '__gmpz_set_d');
      @mpz_set_q := GetProcAddress(FDLLHandle, '__gmpz_set_q');
      @mpz_set_f := GetProcAddress(FDLLHandle, '__gmpz_set_f');
      @mpz_set_str := GetProcAddress(FDLLHandle, '__gmpz_set_str');
      @mpz_swap := GetProcAddress(FDLLHandle, '__gmpz_swap');
      @mpz_init_set := GetProcAddress(FDLLHandle, '__gmpz_init_set');
      @mpz_init_set_ui := GetProcAddress(FDLLHandle, '__gmpz_init_set_ui');
      @mpz_init_set_si := GetProcAddress(FDLLHandle, '__gmpz_init_set_si');
      @mpz_init_set_d := GetProcAddress(FDLLHandle, '__gmpz_init_set_d');
      @mpz_init_set_str := GetProcAddress(FDLLHandle, '__gmpz_init_set_str');
      @mpz_get_ui := GetProcAddress(FDLLHandle, '__gmpz_get_ui');
      @mpz_get_si := GetProcAddress(FDLLHandle, '__gmpz_get_si');
      @mpz_get_d := GetProcAddress(FDLLHandle, '__gmpz_get_d');
      @mpz_get_d_2exp := GetProcAddress(FDLLHandle, '__gmpz_get_d_2exp');
      @_mpz_get_str := GetProcAddress(FDLLHandle, '__gmpz_get_str');
      @mpz_getlimbn := GetProcAddress(FDLLHandle, '__gmpz_getlimbn');
      @mpz_add := GetProcAddress(FDLLHandle, '__gmpz_add');
      @mpz_add_ui := GetProcAddress(FDLLHandle, '__gmpz_add_ui');
      @mpz_sub := GetProcAddress(FDLLHandle, '__gmpz_sub');
      @mpz_sub_ui := GetProcAddress(FDLLHandle, '__gmpz_sub_ui');
      @mpz_ui_sub := GetProcAddress(FDLLHandle, '__gmpz_ui_sub');
      @mpz_mul := GetProcAddress(FDLLHandle, '__gmpz_mul');
      @mpz_mul_ui := GetProcAddress(FDLLHandle, '__gmpz_mul_ui');
      @mpz_mul_si := GetProcAddress(FDLLHandle, '__gmpz_mul_si');
      @mpz_addmul := GetProcAddress(FDLLHandle, '__gmpz_addmul');
      @mpz_addmul_ui := GetProcAddress(FDLLHandle, '__gmpz_addmul_ui');
      @mpz_submul := GetProcAddress(FDLLHandle, '__gmpz_submul');
      @mpz_submul_ui := GetProcAddress(FDLLHandle, '__gmpz_submul_ui');
      @mpz_mul_2exp := GetProcAddress(FDLLHandle, '__gmpz_mul_2exp');
      @mpz_neg := GetProcAddress(FDLLHandle, '__gmpz_neg');
      @mpz_abs := GetProcAddress(FDLLHandle, '__gmpz_abs');
      @mpz_cdiv_q := GetProcAddress(FDLLHandle, '__gmpz_cdiv_q');
      @mpz_cdiv_r := GetProcAddress(FDLLHandle, '__gmpz_cdiv_r');
      @mpz_cdiv_qr := GetProcAddress(FDLLHandle, '__gmpz_cdiv_qr');
      @mpz_cdiv_q_ui := GetProcAddress(FDLLHandle, '__gmpz_cdiv_q_ui');
      @mpz_cdiv_r_ui := GetProcAddress(FDLLHandle, '__gmpz_cdiv_r_ui');
      @mpz_cdiv_qr_ui := GetProcAddress(FDLLHandle, '__gmpz_cdiv_qr_ui');
      @mpz_cdiv_ui := GetProcAddress(FDLLHandle, '__gmpz_cdiv_ui');
      @mpz_cdiv_q_2exp := GetProcAddress(FDLLHandle, '__gmpz_cdiv_q_2exp');
      @mpz_cdiv_r_2exp := GetProcAddress(FDLLHandle, '__gmpz_cdiv_r_2exp');
      @mpz_fdiv_q := GetProcAddress(FDLLHandle, '__gmpz_fdiv_q');
      @mpz_fdiv_r := GetProcAddress(FDLLHandle, '__gmpz_fdiv_r');
      @mpz_fdiv_qr := GetProcAddress(FDLLHandle, '__gmpz_fdiv_qr');
      @mpz_fdiv_q_ui := GetProcAddress(FDLLHandle, '__gmpz_fdiv_q_ui');
      @mpz_fdiv_r_ui := GetProcAddress(FDLLHandle, '__gmpz_fdiv_r_ui');
      @mpz_fdiv_qr_ui := GetProcAddress(FDLLHandle, '__gmpz_fdiv_qr_ui');
      @mpz_fdiv_ui := GetProcAddress(FDLLHandle, '__gmpz_fdiv_ui');
      @mpz_fdiv_q_2exp := GetProcAddress(FDLLHandle, '__gmpz_fdiv_q_2exp');
      @mpz_fdiv_r_2exp := GetProcAddress(FDLLHandle, '__gmpz_fdiv_r_2exp');
      @mpz_tdiv_q := GetProcAddress(FDLLHandle, '__gmpz_tdiv_q');
      @mpz_tdiv_r := GetProcAddress(FDLLHandle, '__gmpz_tdiv_r');
      @mpz_tdiv_qr := GetProcAddress(FDLLHandle, '__gmpz_tdiv_qr');
      @mpz_tdiv_q_ui := GetProcAddress(FDLLHandle, '__gmpz_tdiv_q_ui');
      @mpz_tdiv_r_ui := GetProcAddress(FDLLHandle, '__gmpz_tdiv_r_ui');
      @mpz_tdiv_qr_ui := GetProcAddress(FDLLHandle, '__gmpz_tdiv_qr_ui');
      @mpz_tdiv_ui := GetProcAddress(FDLLHandle, '__gmpz_tdiv_ui');
      @mpz_tdiv_q_2exp := GetProcAddress(FDLLHandle, '__gmpz_tdiv_q_2exp');
      @mpz_tdiv_r_2exp := GetProcAddress(FDLLHandle, '__gmpz_tdiv_r_2exp');
      @mpz_mod := GetProcAddress(FDLLHandle, '__gmpz_mod');
      @mpz_mod_ui := GetProcAddress(FDLLHandle, '__gmpz_fdiv_r_ui');
      @mpz_divexact := GetProcAddress(FDLLHandle, '__gmpz_divexact');
      @mpz_divexact_ui := GetProcAddress(FDLLHandle, '__gmpz_divexact_ui');
      @mpz_divisible_p := GetProcAddress(FDLLHandle, '__gmpz_divisible_p');
      @mpz_divisible_ui_p := GetProcAddress(FDLLHandle, '__gmpz_divisible_ui_p');
      @mpz_divisible_2exp_p := GetProcAddress(FDLLHandle, '__gmpz_divisible_2exp_p');
      @mpz_congruent_p := GetProcAddress(FDLLHandle, '__gmpz_congruent_p');
      @mpz_congruent_ui_p := GetProcAddress(FDLLHandle, '__gmpz_congruent_ui_p');
      @mpz_congruent_2exp_p := GetProcAddress(FDLLHandle, '__gmpz_congruent_2exp_p');
      @mpz_powm := GetProcAddress(FDLLHandle, '__gmpz_powm');
      @mpz_powm_ui := GetProcAddress(FDLLHandle, '__gmpz_powm_ui');
      @mpz_pow_ui := GetProcAddress(FDLLHandle, '__gmpz_pow_ui');
      @mpz_ui_pow_ui := GetProcAddress(FDLLHandle, '__gmpz_ui_pow_ui');
      @mpz_root := GetProcAddress(FDLLHandle, '__gmpz_root');
      @mpz_sqrt := GetProcAddress(FDLLHandle, '__gmpz_sqrt');
      @mpz_sqrtrem := GetProcAddress(FDLLHandle, '__gmpz_sqrtrem');
      @mpz_perfect_power_p := GetProcAddress(FDLLHandle, '__gmpz_perfect_power_p');
      @mpz_perfect_square_p := GetProcAddress(FDLLHandle, '__gmpz_perfect_square_p');
      @mpz_probab_prime_p := GetProcAddress(FDLLHandle, '__gmpz_probab_prime_p');
      @mpz_nextprime := GetProcAddress(FDLLHandle, '__gmpz_nextprime');
      @mpz_gcd := GetProcAddress(FDLLHandle, '__gmpz_gcd');
      @mpz_gcd_ui := GetProcAddress(FDLLHandle, '__gmpz_gcd_ui');
      @mpz_gcdext := GetProcAddress(FDLLHandle, '__gmpz_gcdext');
      @mpz_lcm := GetProcAddress(FDLLHandle, '__gmpz_lcm');
      @mpz_lcm_ui := GetProcAddress(FDLLHandle, '__gmpz_lcm_ui');
      @mpz_invert := GetProcAddress(FDLLHandle, '__gmpz_invert');
      @mpz_jacobi := GetProcAddress(FDLLHandle, '__gmpz_jacobi');
      @mpz_legendre := GetProcAddress(FDLLHandle, '__gmpz_jacobi');
      @mpz_kronecker := GetProcAddress(FDLLHandle, '__gmpz_jacobi');
      @mpz_kronecker_si := GetProcAddress(FDLLHandle, '__gmpz_kronecker_si');
      @mpz_kronecker_ui := GetProcAddress(FDLLHandle, '__gmpz_kronecker_ui');
      @mpz_si_kronecker := GetProcAddress(FDLLHandle, '__gmpz_si_kronecker');
      @mpz_ui_kronecker := GetProcAddress(FDLLHandle, '__gmpz_ui_kronecker');
      @mpz_remove := GetProcAddress(FDLLHandle, '__gmpz_remove');
      @mpz_fac_ui := GetProcAddress(FDLLHandle, '__gmpz_fac_ui');
      @mpz_bin_ui := GetProcAddress(FDLLHandle, '__gmpz_bin_ui');
      @mpz_bin_uiui := GetProcAddress(FDLLHandle, '__gmpz_bin_uiui');
      @mpz_fib_ui := GetProcAddress(FDLLHandle, '__gmpz_fib_ui');
      @mpz_fib2_ui := GetProcAddress(FDLLHandle, '__gmpz_fib2_ui');
      @mpz_lucnum_ui := GetProcAddress(FDLLHandle, '__gmpz_lucnum_ui');
      @mpz_lucnum2_ui := GetProcAddress(FDLLHandle, '__gmpz_lucnum2_ui');
      @mpz_cmp := GetProcAddress(FDLLHandle, '__gmpz_cmp');
      @mpz_cmp_d := GetProcAddress(FDLLHandle, '__gmpz_cmp_d');
      @mpz_cmp_si := GetProcAddress(FDLLHandle, '__gmpz_cmp_si');
      @mpz_cmp_ui := GetProcAddress(FDLLHandle, '__gmpz_cmp_ui');
      @mpz_cmpabs := GetProcAddress(FDLLHandle, '__gmpz_cmpabs');
      @mpz_cmpabs_d := GetProcAddress(FDLLHandle, '__gmpz_cmpabs_d');
      @mpz_cmpabs_ui := GetProcAddress(FDLLHandle, '__gmpz_cmpabs_ui');
      @mpz_and := GetProcAddress(FDLLHandle, '__gmpz_and');
      @mpz_ior := GetProcAddress(FDLLHandle, '__gmpz_ior');
      @mpz_xor := GetProcAddress(FDLLHandle, '__gmpz_xor');
      @mpz_eor := GetProcAddress(FDLLHandle, '__gmpz_xor');
      @mpz_com := GetProcAddress(FDLLHandle, '__gmpz_com');
      @mpz_popcount := GetProcAddress(FDLLHandle, '__gmpz_popcount');
      @mpz_hamdist := GetProcAddress(FDLLHandle, '__gmpz_hamdist');
      @mpz_scan0 := GetProcAddress(FDLLHandle, '__gmpz_scan0');
      @mpz_scan1 := GetProcAddress(FDLLHandle, '__gmpz_scan1');
      @mpz_setbit := GetProcAddress(FDLLHandle, '__gmpz_setbit');
      @mpz_clrbit := GetProcAddress(FDLLHandle, '__gmpz_clrbit');
      @mpz_tstbit := GetProcAddress(FDLLHandle, '__gmpz_tstbit');
      @mpz_import := GetProcAddress(FDLLHandle, '__gmpz_import');
      @mpz_export := GetProcAddress(FDLLHandle, '__gmpz_export');
      @mpz_fits_ulong_p := GetProcAddress(FDLLHandle, '__gmpz_fits_ulong_p');
      @mpz_fits_slong_p := GetProcAddress(FDLLHandle, '__gmpz_fits_slong_p');
      @mpz_fits_uint_p := GetProcAddress(FDLLHandle, '__gmpz_fits_uint_p');
      @mpz_fits_sint_p := GetProcAddress(FDLLHandle, '__gmpz_fits_sint_p');
      @mpz_fits_ushort_p := GetProcAddress(FDLLHandle, '__gmpz_fits_ushort_p');
      @mpz_fits_sshort_p := GetProcAddress(FDLLHandle, '__gmpz_fits_sshort_p');
      @mpz_size := GetProcAddress(FDLLHandle, '__gmpz_size');
      @mpz_sizeinbase := GetProcAddress(FDLLHandle, '__gmpz_sizeinbase');
      @_gmp_printf := GetProcAddress(FDLLHandle, '__gmp_printf');
      @_gmp_sprintf := GetProcAddress(FDLLHandle, '__gmp_sprintf');
      @_gmp_snprintf := GetProcAddress(FDLLHandle, '__gmp_snprintf');
      @_gmp_scanf := GetProcAddress(FDLLHandle, '__gmp_scanf');
      @_gmp_sscanf := GetProcAddress(FDLLHandle, '__gmp_sscanf');
    end;
end;

procedure FreeDLL;
begin
    if FDLLHandle <> 0 then
      FreeLibrary(FDLLHandle);
end;

function IsDLLLoaded: Boolean;
begin
    Result := FDLLHandle <> 0;
end;

initialization
  LoadDLL;

finalization
  FreeDLL;

end.

