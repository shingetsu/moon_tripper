unit gmp2;
{
///////////////////////////////////////////////////////////////////////
GMP (GNU Multiple Precision Arithmetic Library)
Windows DLL�p Delphi���j�b�g (based on gmp-4.1.3)
�ÓI���[�h��

  Delphi����cyggmp-3.dll���g�p���邽�߂̃��j�b�g�ł��B
  Windows���ȊO�ł̓���͍l�����Ă��܂���B
  �������Z�𒆐S�ɈڐA���ł��B�錾���Ă��Ȃ��֐���}�N��������܂��B

  ���C�Z���X�̓I���W�i���̂܂܂ł�(GNU LGPL)
  �ڐA�ɔ����o�O������\��������̂Ŏg���ۂ͒��ӂ��Ă��������B

programed by ������������ł�����͂������

2004/07/22 4.1.3-0.0 : �������Z�Ɠ��o�͂���������
2004/08/12 4.1.3-0.1 : overload�Ń��b�p�������Ă���֐��̔�����
2004/08/13 4.1.3-0.2 : ���I���[�h�ɑΉ�

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
//  DLL�����[�h����Ă����True��Ԃ�
//  �������A�o�[�W�����Ⴂ��DLL���^����ꂽ�Ƃ���
// ���ׂĂ̊֐����g�p�\�ł���ۏ�͂Ȃ�

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
//mp_srcptr �͌Ăяo���錾��const�����ɂ���
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
  �������Z�������Ȃ��֐��Q�Bprefix: mpz_



  5.1 Initialization Functions
    �������Z�������Ȃ��֐��Q�̓I�y�����h������������Ă��邱�Ƃ����肵�Ă���B
    �֐����g�p����ۂ�mpz_init��p���ď��������Ă����Ȃ���΂Ȃ�Ȃ��B
    ��x����������΁A���x�ł��ǂ�Ȓl�ł��X�g�A���邱�Ƃ��ł���B
}
TFmpz_init = procedure (var int: mpz_t); cdecl; 
//procedure mpz_init(var int: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_init';
// int�����������A�l��0�ɃZ�b�g����

TFmpz_init2 = procedure (var int: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_init2(var int: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_init2';
// int��n bit�̗̈�������ď��������A�l��0�ɃZ�b�g����
// n�͗̈�̏����̒l�ŁA���̌�̉��Z���ʂ��i�[����̂ɕK�v�ł���΁A
// int�͎����I�Ɋg�������B
// ���̊֐����g�p���邱�Ƃɂ��A���O�ɍő�T�C�Y���킩���Ă���Ƃ��ɁA
// ���̂悤�ȍĔz�u��h�����Ƃ��ł���B

TFmpz_clear = procedure (var int: mpz_t); cdecl; 
//procedure mpz_clear(var int: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_clear';
// int�̎g�p���Ă����̈���J������B
// mpz_t �ϐ��͕s�v�ɂȂ�΂��̊֐����Ăяo���ĉ�����Ȃ��Ă͂Ȃ�Ȃ��B

TFmpz_realloc2 = procedure (var int: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_realloc2(var int: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_realloc2';
// int�̊m�ۗ̈��n bit�ɕύX����B
// �ύX��A���肫���int�̒l�͕ێ�����A�����łȂ����0�ɃZ�b�g�����B
// ���̊֐��́A�����Ĕz�u���J��Ԃ����̂�h�����߂ɕϐ��̈��傫��������A
// �̈���k�����ăq�[�v�Ƀ�������ԋp����̂Ɏg�p�ł���B

TF_mpz_array_init = procedure (int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); cdecl; 
//procedure _mpz_array_init(int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_array_init';
procedure mpz_array_init(int_array: mpz_ptr; array_size: Integer; fixed_num_bits: mp_size_t); overload;
procedure mpz_array_init(var int_array: array of mpz_t; fixed_num_bits: mp_size_t); overload;
// ���̊֐��͓���ȏ��������s���B
// fixed_num_bits bit�́u�Œ蒷�v�̗̈���Aint_array�̂��ꂼ��̗v�f�Ɋm�ۂ���B
// ���̊֐��Ŋm�ۂ����̈�́A�ʏ��mpz_init�Ŋm�ۂ����̈�Ƃ͈Ⴂ�A
// �����g������Ȃ��B�v���O�����́A�g�p����ǂ�Ȓl���m�ۂ���̂ɏ\���ł���
// �Ƃ������Ƃ�ۏ؂��Ȃ��Ă͂Ȃ�Ȃ��B
// �i�K�v�ȗ̈�̗ʂɊւ��Ă̓w���v�{�����Q�Ɓj
// ���̊֐��́A�����ȗ̈���ʂɊm�ۂ�����Ĕz�u�����肷��̂�����邱�Ƃɂ��A
// ����Ȕz�񂪕K�v�ȃA���S���Y���ŁA�������̎g�p�ʂ�}���邱�Ƃ��ł���B
// ���̊֐��ɂ��A�m�ۂ��ꂽ�̈���J�������i�͂Ȃ��B
// mpz_clear���Ăяo���Ă͂Ȃ�Ȃ��B
//
// overload�ł̓I�[�v���z��p�����[�^�ɂ�郉�b�p�[�ł���B

type
TF_mpz_realloc = procedure (var int: mpz_t; n: Cardinal); cdecl;
//procedure _mpz_realloc(var int: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_realloc';
// mpz_realloc2�Ɠ��������A�Ԃ�l�͏����ɓK���Ȃ��̂ŁA�j�����ׂ��ł���B
// �Ĕz�u�ɂ�mpz_realloc2�̕����K���ł���B
// �V�����T�C�Y��limb���ł��鎞�ȊO��mpz_realloc2�Ɠ����B

{


  5.2 Assignment Functions
    ���̊֐��Q�́A�������ς݂̗̈�ɐV�����l���Z�b�g����
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
// rop��op�̒l���Z�b�g����B
// mpz_set_d,mpz_set_q,mpz_set_f��op�𐮐��ɐ؂�̂Ă�B

TFmpz_set_str = function (var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; 
//function mpz_set_str(var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_set_str';
// rop�ɁAbase�i����null-terminated������̎����l��������B
// white space��str���Ɍ���Ă��A���ׂď����ɖ��������B
// base��2-36���L���ł���B0�ł��鎞�́A�ȉ��̋K���Ŋ�����߂���:
// '0x'or'0X'�Ŏn�܂��16�i���A����ȊO��'0'�Ŏn�܂��8�i���A
// ����ȊO��10�i�������肳���B
// ���̊֐��́A���ׂĂ̕�����base�i���Ƃ��ėL���Ȑ����ł����0���A
// �����łȂ����-1��Ԃ��B

TFmpz_swap = procedure (var rop1: mpz_t; var rop2: mpz_t); cdecl; 
//procedure mpz_swap(var rop1: mpz_t; var rop2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_swap';
// rop1��rop2�������悭��������B

{


  5.3 Combined Initialization and Assignment Functions
    GMP�͕ʌn���̏������Z�b�g�֐��Q��p�ӂ��Ă���B
    ���̊֐��Q�́A�������Ɠ����ɒl���Z�b�g������̂ŁAmpz_init_set...
    �Ƃ������O�ł���B
    ��������mpz_init_set...�֐��Q�ŏ���������΁A�������Z�֐���souce�Ƃ��Ă�
    destination�Ƃ��Ă��g�p�ł���B
    ���ɏ������ς݂̕ϐ��ɑ΂��āA���̊֐��Q���g���Ă͂Ȃ�Ȃ��B
}
TFmpz_init_set = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_init_set(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set';
TFmpz_init_set_ui = procedure (var rop: mpz_t; op: Cardinal); cdecl; 
//procedure mpz_init_set_ui(var rop: mpz_t; op: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_ui';
TFmpz_init_set_si = procedure (var rop: mpz_t; op: Integer); cdecl; 
//procedure mpz_init_set_si(var rop: mpz_t; op: Integer); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_si';
TFmpz_init_set_d = procedure (var rop: mpz_t; op: Double); cdecl; 
//procedure mpz_init_set_d(var rop: mpz_t; op: Double); cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_d';
// rop��1 limb�ŏ��������Aop�̐����l���Z�b�g����

TFmpz_init_set_str = function (var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; 
//function mpz_init_set_str(var rop: mpz_t; const str: PChar; base: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_init_set_str';
// �̈悪�����������ȊO��mpz_set_str�Ɠ���
// �G���[���N������-1��Ԃ����ꍇ�ł�rop�͏���������Ă���̂�
// mpz_clear���ĂԕK�v������

{


  5.4 Conversion Functions
    GMP�����^����AC�̕W���^�ւ̕ϊ��֐��Q�ł���B
    GMP�����^�ւ̕ϊ��ɂ��Ă�Section 5.2[Assigning Integers],
    Section 5.12[I/O of Integers]���Q��
}
TFmpz_get_ui = function (const op: mpz_t): Cardinal; cdecl; 
//function mpz_get_ui(const op: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_ui';
// op�̒l��unsigned long�ŕԂ�
// op����������傫�����́A���܂肫��ŉ���bit���Ԃ����B
// �����͖�������A��Βl���g����B

TFmpz_get_si = function (const op: mpz_t): Integer; cdecl; 
//function mpz_get_si(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_si';
// op�̒l��signed long�ŕԂ�
// op���傫���ꍇ�́Aop�Ɠ������ŁA���܂肫��ŉ���bit���Ԃ����B
// op��signed long�Ɏ��܂�Ȃ����́A�Ԃ�l�͂��܂�Ӗ��������Ȃ��B
// ���܂邩�ǂ�����mpz_fits_slong_p�֐��Œ��ׂ���B

TFmpz_get_d = function (const op: mpz_t): Double; cdecl; 
//function mpz_get_d(const op: mpz_t): Double; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_d';
// op��double�ɕϊ�����

TFmpz_get_d_2exp = function (var exp: Integer; const op: mpz_t): Double; cdecl; 
//function mpz_get_d_2exp(var exp: Integer; const op: mpz_t): Double; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_d_2exp';
// d*2^exp (0.5<|d|<1) �Ȃ�op�̂悢�ߎ��ld,exp�����߂�

TF_mpz_get_str = function (str: PChar; base: Integer; const op: mpz_t): PChar; cdecl; 
//function _mpz_get_str(str: PChar; base: Integer; const op: mpz_t): PChar; cdecl; external 'cyggmp-3.dll' name '__gmpz_get_str'; overload;
function mpz_get_str(str: PChar; base: Integer; const op: mpz_t): PChar; overload;
function mpz_get_str(const op: mpz_t; base: Integer): String; overload;
// op��base�i���̐��l������ɕϊ�����Bbase��2-36���L���ł���B
// str��NULL�ł���Ό��݂�allocation�֐��ŕ�����̈悪�m�ۂ����B
// ���̗ʂ�strlen(str)+1�ł���A���傤�Ǖ�����ƃk���^�[�~�l�[�^�̕��ł���B
// str��NULL�łȂ���΁Ampz_sizeinbase(op,base)+2���\���̗̈���w����
// ���Ȃ���΂Ȃ�Ȃ��B+2�͕����ƃ^�[�~�l�[�^�̕��ł���B
// �Ԃ�l�́A�֐��Ŋm�ۂ������^�������ɂ�炸�A���ʕ�����ւ̃|�C���^�ł���B
//
// �����A���P�[�g�֐��̂܂܂�str��nil������Č������Ŋm�ۂ���ƁA
// Delphi����͉���ł����AMSVCRT.dll����łȂ��Ɖ���ł��Ȃ��̂Œ���
//
// overload�ł́Astring�ɂ�郉�b�p�[�ł���B

type
TFmpz_getlimbn = function (const op: mpz_t; n: mp_size_t): mp_limb_t; cdecl;
//function mpz_getlimbn(const op: mpz_t; n: mp_size_t): mp_limb_t; cdecl; external 'cyggmp-3.dll' name '__gmpz_getlimbn';
// op��n�Ԗڂ�limb��Ԃ��B�����͖�������A��Βl�݂̂��g����B
// mpz_size�֐����g�p����ƁAop�ɂ�����limb�����邩�𒲂ׂ���B
// n��0����mpz_size(op)-1�͈̔͂ɂȂ��ƁA���̊֐���0��Ԃ��B

{


  5.5 Arithmetic Functions
}
TFmpz_add = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_add(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_add';
TFmpz_add_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_add_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_add_ui';
// rop��op1+op2���Z�b�g����

TFmpz_sub = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_sub(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_sub';
TFmpz_sub_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_sub_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_sub_ui';
TFmpz_ui_sub = procedure (var rop: mpz_t; op1: Cardinal; const op2: mpz_t); cdecl; 
//procedure mpz_ui_sub(var rop: mpz_t; op1: Cardinal; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_ui_sub';
// rop��op1-op2���Z�b�g����

TFmpz_mul = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_mul(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul';
TFmpz_mul_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_mul_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul_ui';
TFmpz_mul_si = procedure (var rop: mpz_t; const op1: mpz_t; op2: Integer); cdecl; 
//procedure mpz_mul_si(var rop: mpz_t; const op1: mpz_t; op2: Integer); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul_si';
// rop��op1*op2���Z�b�g����

TFmpz_addmul = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_addmul(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_addmul';
TFmpz_addmul_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_addmul_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_addmul_ui';
// rop��rop+op1*op2���Z�b�g����

TFmpz_submul = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_submul(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_submul';
TFmpz_submul_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_submul_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_submul_ui';
// rop��rop-op1*op2���Z�b�g����

TFmpz_mul_2exp = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_mul_2exp(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_mul_2exp';
// rop��op1*2^op2���Z�b�g����
// ���̑���́A����op2 bit�V�t�g����̂Ɠ����ł���B

TFmpz_neg = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_neg(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_neg';
// rop��-op���Z�b�g����

TFmpz_abs = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_abs(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_abs';
// rop��op�̐�Βl���Z�b�g����

{


  5.6 Division Functions
    division�͏�����0�ł��鎞�ɂ��Ă͖���`�ł���B
    division,modulo�֐�(�ݏ��]�֐�mpz_pown,mpz_pown_ui���܂�)�ɏ���0��
    �^������ƁA0�ɂ�鏜�Z���Ӑ}�I�ɔ���������B
    ����ɂ��A�v���O�����͒ʏ��C�̐����v�Z�Ɠ����悤�ɁA�Z�p��O���󂯎��
    ���Ƃ��ł���B
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
  //cdiv�n�́Aq���{�������֊ۂ߁Ar�̕�����d�Ɣ��΂Ɏ��B"ceil"
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
  //fdiv�n�́Aq���|�������֊ۂ߁Ar�̕�����d�Ɠ����Ɏ��B"floor"
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
  //tdiv�n�́Aq��0�Ɍ������Ċۂ߁Ar�̕�����n�Ɠ����Ɏ��B"truncate"

//  �����̊֐��Q�͂��ׂāAn��d�Ŋ���A��q(and/or)�]��r�𓾂�B
// 2exp�֐��ɂ��Ă�d=2^b�Ƃ���B
//  �ۂ߂̕����́A��L�̂Ƃ���Acdiv�����̖���������Afdiv�����̖��������
// tdiv���[�������ł���B
//  ����炷�ׂĂ̊֐��ɂ��āAn=qd+r �A�� 0<=|r|<|d|�A�𖞂����B
//  q�n�֐��͏��̂݁Ar�n�֐��͗]��̂݁Aqr�n�֐��͗������v�Z����B
// �A���Aqr�n�֐��̈����Ƃ��āAq,r�ɓ����ϐ���n���Ă͂Ȃ�Ȃ��B
// �n�����ꍇ�A���ʂ͗\���ł��Ȃ��B
//  ui�n�֐��̕Ԃ�l�́A���ׂĂ�div_ui�֐��ŗ]��ł���B
// tdiv��cdiv�ɂ����ẮA�]�肪���ɂȂ邱�Ƃ����邪�A���̂Ƃ��̕Ԃ�l��
// �]��̐�Βl�ƂȂ�B
//  2exp�n�֐��͉E�V�t�g�ƃr�b�g�}�X�N�����A�ۂ߂Ɋւ��Ă͑��̂��̂Ɠ��l�ł���B
// ����n�ɑ΂��Ă�mpz_tdiv_q_2exp��mpz_fdiv_q_2exp���P�Ȃ�E�r�b�g�V�t�g�ł���B
// ����n�ɑ΂��ẮAmpz_fdiv_q_2exp�͘_���r�b�g���Z�֐��������Ȃ��̂Ɠ�����
// n��2�̕␔�Ƃ��Ă̎Z�p�r�b�g�V�t�g�ł���A����ɑ΂���mpz_tdiv_q_2exp��
// n�𕄍��Ɛ�Βl�ɕ����Ĉ����B
// (��)mpz_fdiv_q_2exp: n��2�̕␔�\���Ƃ��ĎZ�p�E�r�b�g�V�t�g
//       mpz_tdiv_q_2exp: n�𕄍����Ɛ��l���ɕ������܂܁A�E�r�b�g�V�t�g

TFmpz_mod = procedure (var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_mod(var r: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_mod';
TFmpz_mod_ui = function (var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; 
//function mpz_mod_ui(var r: mpz_t; const n: mpz_t; d: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_fdiv_r_ui';
//  r�� n mod d ���Z�b�g����B����d�̕����͖��������B
// ���ʂ͏�ɔ񕉂ł���B
//  mpz_mod_ui�́Ampz_fdiv_r_ui�̕ʖ��ł���A�]���r�ɃZ�b�g�����ƂƂ��ɁA
// �Ԃ�l�Ƃ��ĕԂ����B�Ԃ�l�݂̂��~�������́Ampz_fdiv_ui�Q�ƁB

TFmpz_divexact = procedure (var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; 
//procedure mpz_divexact(var q: mpz_t; const n: mpz_t; const d: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_divexact';
TFmpz_divexact_ui = procedure (var q: mpz_t; const n: mpz_t; d: Cardinal); cdecl; 
//procedure mpz_divexact_ui(var q: mpz_t; const n: mpz_t; d: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_divexact_ui';
//  q�� n/d ���Z�b�g����B�����̊֐��́A���O��d��n������؂邱�Ƃ�
// �킩���Ă��鎞�̂݁A���������ʂ�Ԃ��B
//  �����̊֐��́A���̏��Z�֐���葬���B�L���������񕪐��ɂ��鎞�Ȃǂ́A
// ���傤�Ǌ���؂�邱�Ƃ��킩���Ă��鎞�́A�ŗǂ̕��@�ł���B

TFmpz_divisible_p = function (const n: mpz_t; const d: mpz_t): Integer; cdecl; 
//function mpz_divisible_p(const n: mpz_t; const d: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_divisible_p';
TFmpz_divisible_ui_p = function (const n: mpz_t; d: Cardinal): Integer; cdecl; 
//function mpz_divisible_ui_p(const n: mpz_t; d: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_divisible_ui_p';
TFmpz_divisible_2exp_p = function (const n: mpz_t; b: Cardinal): Integer; cdecl; 
//function mpz_divisible_2exp_p(const n: mpz_t; b: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_divisible_2exp_p';
//  n��d�ł��傤�Ǌ���؂�鎞�ɔ�0��Ԃ��B
// �A���Ampz_dividible_2exp_p�̏ꍇ�́An��2^d�ł��傤�Ǌ���؂�鎞�ł���B

TFmpz_congruent_p = function (const n: mpz_t; const c: mpz_t; const d: mpz_t): Integer; cdecl; 
//function mpz_congruent_p(const n: mpz_t; const c: mpz_t; const d: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_congruent_p';
TFmpz_congruent_ui_p = function (const n: mpz_t; c: Cardinal; d: Cardinal): Integer; cdecl; 
//function mpz_congruent_ui_p(const n: mpz_t; c: Cardinal; d: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_congruent_ui_p';
TFmpz_congruent_2exp_p = function (const n: mpz_t; const c: mpz_t; b: Cardinal): Integer; cdecl; 
//function mpz_congruent_2exp_p(const n: mpz_t; const c: mpz_t; b: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_congruent_2exp_p';
//  n���Ad��@�Ƃ���c�ƈ�v�������ic��d�Ŋ������]��ƁAn��d�Ŋ������]�肪��v�������j
// ��0��Ԃ��B
// �A���Ampz_congruent_2exp_p�̏ꍇ�́A�@��2^b�Ƃ���B

{


  5.7 Exponentiation Functions
}
TFmpz_powm = procedure (var rop: mpz_t; const base: mpz_t; const exp: mpz_t; const m: mpz_t); cdecl; 
//procedure mpz_powm(var rop: mpz_t; const base: mpz_t; const exp: mpz_t; const m: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_powm';
TFmpz_powm_ui = procedure (var rop: mpz_t; const base: mpz_t; exp: Cardinal; const m: mpz_t); cdecl; 
//procedure mpz_powm_ui(var rop: mpz_t; const base: mpz_t; exp: Cardinal; const m: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_powm_ui';
//  rop�� base^exp mod m ���Z�b�g����B
//  �t��(base^(-1) mod m)�����݂��鎞��(Section 5.9 mpz_invert �Q��)
// ����exp���w��ł���B����exp���w�肳��Ă��鎞�ɁA�t�������݂��Ȃ���΁A
// 0�ɂ�鏜�Z�����������B

TFmpz_pow_ui = procedure (var rop: mpz_t; const base: mpz_t; exp: Cardinal); cdecl; 
//procedure mpz_pow_ui(var rop: mpz_t; const base: mpz_t; exp: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_pow_ui';
TFmpz_ui_pow_ui = procedure (var rop: mpz_t; base: Cardinal; exp: Cardinal); cdecl; 
//procedure mpz_ui_pow_ui(var rop: mpz_t; base: Cardinal; exp: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_ui_pow_ui';
//  rop�� base^exp���Z�b�g�����B
//  �A���A0^0��1�ƂȂ�B

{


  5.8 Root Extraction Funtions
}
TFmpz_root = function (var rop: mpz_t; const op: mpz_t; n: Cardinal): Integer; cdecl; 
//function mpz_root(var rop: mpz_t; const op: mpz_t; n: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_root';
// rop�ɁAop��n�捪�̐����������Z�b�g�����B
// op��rop��n��ł���΁A��0��Ԃ��B

TFmpz_sqrt = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_sqrt(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_sqrt';
// rop�� op�̃��[�g(2�捪)�̐����������Z�b�g����B

TFmpz_sqrtrem = procedure (var rop1: mpz_t; var rop2: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_sqrtrem(var rop1: mpz_t; var rop2: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_sqrtrem';
//  rop1�� op�̃��[�g�̐��������Arop2�� �c�](op - rop1^2)���Z�b�g����B
// op�����S�����ł���΁A�c�]rop2��0�ƂȂ�B
//  rop1��rop2�ɓ����ϐ����w�肳�ꂽ���́A���ʂ͖���`�ł���B

TFmpz_perfect_power_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_perfect_power_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_perfect_power_p';
//  op��"perfect power"�ł���Δ�0��Ԃ��B
// ������"perfect power"�ł���Ƃ́A���鐮��a,b ������b>1 �����݂��āAop = a^b
// �ł��邱�Ƃ������B
//  ���̒�`�ɂ��ƁA0��1�͂ǂ����"perfect power"�Ƃ݂Ȃ����B
// ����op��^���邱�Ƃ͂ł��邪�A�������A��݂̂���"perfect power"
// �̉\���͂Ȃ��B

TFmpz_perfect_square_p = function (const op: mpz_t): Integer; cdecl; 
//function mpz_perfect_square_p(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_perfect_square_p';
//  op�����S�����A���Ȃ킿�Aop�̕������������ł��鎞�A��0��Ԃ��B
// ���̒�`�ɂ��ƁA0��1�͂ǂ�������S�����Ƃ݂Ȃ����B

{


  5.9 Number Theoretic Functions
}
TFmpz_probab_prime_p = function (const n: mpz_t; reps: Integer): Integer; cdecl; 
//function mpz_probab_prime_p(const n: mpz_t; reps: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_probab_prime_p';
//  n���f���ł��邩�ǂ����𔻒肷��B
// n���m���ɑf���ł��鎞��2�A�����炭�f���ł��鎞(�������ł��邱�Ƃ��܂�)��1�A
// �������ł���Ƃ���0��Ԃ��B
//  ���̊֐��́A���������������AMiller-Rabin�f���e�X�g���J��Ԃ��B
// rep�͉���J��Ԃ����ŁA5-10���K���ł���B����𑝂₷���Ƃɂ��A
// ������������āu�����炭�f���v�ƕԂ����m���������邱�Ƃ��ł���B
//  Miller-Rabin����ѓ��l�̃e�X�g�͐��m�ɂ͍������e�X�g�ł���B
// �e�X�g�Ƀp�X���Ȃ����͍������ł���Ƃ킩�邪�A�p�X�������͑f����������Ȃ����A
// ��������������Ȃ��B���ɏ����̍����������e�X�g�Ƀp�X���Ȃ��̂ŁA
// ����䂦�ɁA�p�X�������͂����炭�f���Ƃ݂Ȃ����Ƃ��ł���B
//
// (��)Miller-Rabin�f���e�X�g��1/4�̊m���Ō���č��������[�f���ł����
//  ���肷��B���̊֐��́A�����_���ɒ���Ƃ�e�X�g���J��Ԃ��B
//  5��J��Ԃ�������(1/4)^5=0.0009765625�A��0.1%��������Ĕ��肷�邱�ƂƂȂ�B

TFmpz_nextprime = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_nextprime(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_nextprime';
//  rop�� op���傫�����̑f�����Z�b�g����
//  ���̊֐��́A�f���̔���Ɋm������A���S���Y�����g�p����B
// ����́A���p�ړI�ɂ͏\���K���ł��邪�A������������Ĕ��肷��m����
// ���������킸�������c��B

TFmpz_gcd = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_gcd(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_gcd';
//  rop�� op1��op2�̍ő���񐔂��Z�b�g����B
// �I�y�����h�̕Е��܂��͗��������ł������Ƃ��Ă��A���ʂ͏�ɐ��ł���B

TFmpz_gcd_ui = function (var rop: mpz_t; const op1: mpz_t; op2: Cardinal): Cardinal; cdecl; 
//function mpz_gcd_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_gcd_ui';
//  op1��op2�̍ő���񐔂��v�Z����Brop��NULL�łȂ���΁A
// ���ʂ�rop�ɓ������B
//  �����A���ʂ�unsigned long int(Cardinal)�ɓ��肫��̂ł���΁A
// ���ʂ͕Ԃ�l�Ƃ��ĕԂ����B�������肫��Ȃ���΁A�Ԃ�l��0�ƂȂ�A
// ���ʂ�op1�ɓ������B
// op2��0�łȂ���΁A���ʂ͏�ɓ��肫��B

TFmpz_gcdext = procedure (var g: mpz_t;var s: mpz_t;var t: mpz_t;const a: mpz_t;const b: mpz_t); cdecl; 
//procedure mpz_gcdext(var g: mpz_t;var s: mpz_t;var t: mpz_t;const a: mpz_t;const b: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_gcdext';
//  g�� a��b�̍ő���񐔂��Aas + bt = g �𖞂����W����s,t �ɃZ�b�g�����B
// a,b�̕Е��������͗��������ł����Ă��Ag�͏�ɐ��ł���B
//  �����At��NULL�Ȃ�΁A���̒l�͌v�Z����Ȃ��B

TFmpz_lcm = procedure (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; 
//procedure mpz_lcm(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_lcm';
TFmpz_lcm_ui = procedure (var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; 
//procedure mpz_lcm_ui(var rop: mpz_t; const op1: mpz_t; op2: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_lcm_ui';
//  rop�� op1��op2�̍ŏ����{�����Z�b�g����B
// op1��op2�̕����ɂ������Ȃ��Arop�͏�ɐ��ł���B
// op1��op2�̂ǂ��炩��0�ł����rop��0�ɂȂ�B

TFmpz_invert = function (var rop: mpz_t; const op1: mpz_t; const op2: mpz_t): Integer; cdecl; 
//function mpz_invert(var rop: mpz_t; const op1: mpz_t; const op2: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_invert';
//  �@op2�̉��ł�op1�̋t�����v�Z���A���ʂ�rop�ɓ����B
// �t�������݂���ΕԂ�l�͔�0�ŁArop�� 0 <= rop < op2 �𖞂����B
// �t�������݂��Ȃ���΁A�Ԃ�l��0��rop�͖���`�ƂȂ�B

TFmpz_jacobi = function (const a: mpz_t; const b: mpz_t): Integer; cdecl; 
//function mpz_jacobi(const a: mpz_t; const b: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_jacobi';
//  Jacobi(���R�r)�L�� (a/b) ���v�Z����B�����b����ł̂ݒ�`����Ă���B

TFmpz_legendre = function (const a: mpz_t; const p: mpz_t): Integer; cdecl; 
//function mpz_legendre(const a: mpz_t; const p: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_jacobi';
//  Legendre(���W�F���h��)�L�� (a/p) ���v�Z����B�����p������f���ł̂�
// ��`����Ă���B���̂悤��p�ɑ΂��āAJacobi�L���Ɠ���ł���B
//
// ���̊֐���mpz_jacobi�̕ʖ��ł���B

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
//  Jacobi(���R�r)�L�� (a/b) ��Kronecker(�N���l�b�J�[)�g���A
// a����̂Ƃ�(a/2)=(2/a),a�������̎�(a/2)=0 ��p���Čv�Z����B
//  b����̂Ƃ��́AJacobi�L����Kronecker�L���Ɠ���ł���B
// ���̂��߁Ampz_kronecker_ui�Ȃǂ̊֐��́A�����̌^�̈ႤJacobi�L���Ƃ��Ă�
// �g�p���邱�Ƃ��ł���B
//
// mpz_kronecker��mpz_jacobi�̕ʖ��ł���B

TFmpz_remove = function (var rop: mpz_t; const op: mpz_t; const f: mpz_t): Cardinal; cdecl; 
//function mpz_remove(var rop: mpz_t; const op: mpz_t; const f: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_remove';
//  op������qf�����ׂĂ͂炢�A���ʂ�rop�ɃX�g�A����B�Ԃ�l�͂����̈��q��
// �͂��ꂽ���ł���B

TFmpz_fac_ui = procedure (var rop: mpz_t; op: Cardinal); cdecl; 
//procedure mpz_fac_ui(var rop: mpz_t; op: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fac_ui';
//  rop�� op! (op�̊K��)���Z�b�g����B

TFmpz_bin_ui = procedure (var rop: mpz_t; const n: mpz_t; k: Cardinal); cdecl; 
//procedure mpz_bin_ui(var rop: mpz_t; const n: mpz_t; k: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_bin_ui';
TFmpz_bin_uiui = procedure (var rop: mpz_t; n: Cardinal; k: Cardinal); cdecl; 
//procedure mpz_bin_uiui(var rop: mpz_t; n: Cardinal; k: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_bin_uiui';
//  �񍀌W��(binomial coefficient) (n,k)���v�Z�����ʂ�rop�ɃX�g�A����B
// mpz_bim_ui�ŁAn�ɕ��̒l�͋�����A(-n,k) = (-1)^k (n+k-1,k)���g����B
// Knuth volume 1 section 1.2.6 part G ���Q�ƁB

TFmpz_fib_ui = procedure (var fn: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_fib_ui(var fn: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fib_ui';
TFmpz_fib2_ui = procedure (var fn: mpz_t; var fnsub1: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_fib2_ui(var fn: mpz_t; var fnsub1: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_fib2_ui';
// mpz_fib_ui�́Afn��n�Ԗڂ�Fibonacci�� Fn ���Z�b�g����B
// mpz_fib2_ui�́Afn�ɂen�Afnsub1�ɂen-1���Z�b�g����B
//  �����̊֐��́A�Ɨ�����Fibonacci�����v�Z���邽�߂ɐ݌v����Ă���B
// �A�������l���~�������́Ampz_fib2_ui�Ŏn�߂āA��`�en+1=�en+�en-1���J��Ԃ�
// �Ȃǂ̕��@���x�X�g�ł���B

TFmpz_lucnum_ui = procedure (var ln: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_lucnum_ui(var ln: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_lucnum_ui';
TFmpz_lucnum2_ui = procedure (var ln: mpz_t; var lnsub1: mpz_t; n: Cardinal); cdecl; 
//procedure mpz_lucnum2_ui(var ln: mpz_t; var lnsub1: mpz_t; n: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_lucnum2_ui';
// mpz_lucnum_ui��ln��n�Ԗڂ�Lucas�� �kn���Z�b�g����B
// mpz_lucnum2_ui��ln�ɂkn�Alnsub1�ɂkn-1���Z�b�g����B
//  �����̊֐��́A�Ɨ�����Lucas�����v�Z���邽�߂ɐ݌v����Ă���B
// �A�������l���~�������́Ampz_lucnum2_ui�Ŏn�߂āA��`�kn+1=�kn+�kn-1���J��Ԃ�
// �Ȃǂ̕��@���x�X�g�ł���B

//  Fibonacci����Lucas���͊֘A��������ł���̂ŁAmpz_fib2_ui��mpz_lucnum2_ui��
// �����ĂԕK�v�͂܂������Ȃ��BFibonacci����Lucas�ւ̕ϊ�������Section 16.7.4
// [Lucas Numbers Algorithm]�ɂ���A���̋t���e�Ղł���B

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
// op1��op2���r���Aop1>op2�̂Ƃ����Aop1=op2�̂Ƃ�0�Aop1<op2�̂Ƃ�����Ԃ�

TFmpz_cmpabs = function (const op1: mpz_t; const op2: mpz_t): Integer; cdecl; 
//function mpz_cmpabs(const op1: mpz_t; const op2: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmpabs';
TFmpz_cmpabs_d = function (const op1: mpz_t; op2: Double): Integer; cdecl; 
//function mpz_cmpabs_d(const op1: mpz_t; op2: Double): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmpabs_d';
TFmpz_cmpabs_ui = function (const op1: mpz_t; op2: Cardinal): Integer; cdecl; 
//function mpz_cmpabs_ui(const op1: mpz_t; op2: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_cmpabs_ui';
//  op1��op2�̐�Βl���r���A|op1|>|op2|�̂Ƃ����A|op1|=|op2|�̂Ƃ�0�A
// |op1|<|op2|�̂Ƃ�����Ԃ�

function mpz_sgn(const op: mpz_t): Integer;
//  op>0�̂Ƃ�+1�Aop=0�̂Ƃ�0�Aop<0�̂Ƃ�-1��Ԃ��B
//  ���̊֐��̓I���W�i���̓}�N���Ŏ�������Ă���B

{


  5.11 Logical and Bit Manipulation Functions
    �ȉ��̊֐���2�̕␔�Z�p���g�p����Ă���悤�ɂӂ�܂��B
    (���������ۂ̎����͕����Ɛ�Βl����������Ă���)
    �ŉ��ʃr�b�g��bit 0 �ł���B
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
// op1��op2�Ƃ̃r�b�g���Z���ʂ�rop�ɃZ�b�g����

TFmpz_com = procedure (var rop: mpz_t; const op: mpz_t); cdecl; 
//procedure mpz_com(var rop: mpz_t; const op: mpz_t); cdecl; external 'cyggmp-3.dll' name '__gmpz_com';
// op��1�̕␔�\��(�S�r�b�g���])��rop�ɃZ�b�g����

TFmpz_popcount = function (const op: mpz_t): Cardinal; cdecl; 
//function mpz_popcount(const op: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_popcount';
// op>=0�̂Ƃ��́Aop�̃o�C�i���\�L�ł�1�̗����Ă���bit��(population count)��Ԃ��B
// op<0�̂Ƃ��́A1�̐��͖�����ƂȂ�̂ŁAunsigned long(Cardinal)�̍ő�l��
// �Ԃ��B

TFmpz_hamdist = function (const op1: mpz_t; const op2: mpz_t): Cardinal; cdecl; 
//function mpz_hamdist(const op1: mpz_t; const op2: mpz_t): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_hamdist';
//  op1��op2������>=0�ł��邩<0�ł���Ƃ��A2�̃I�y�����h�̃n�~���O������Ԃ��B
// �n�~���O����(hamming distance)�́Abit���Ƃ�op1��op2���قȂ�l���Ƃ�bit�̐��ł���B
//  �ǂ��炩��>=0�ł����Е���<0�ł���Ƃ��́A�قȂ�bit�̐��͖�����ƂȂ�̂ŁA
// �Ԃ�l��unsigned long(Cardinal)�̍ő�l�ƂȂ�B

TFmpz_scan0 = function (const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; 
//function mpz_scan0(const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_scan0';
TFmpz_scan1 = function (const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; 
//function mpz_scan1(const op: mpz_t; starting_bit: Cardinal): Cardinal; cdecl; external 'cyggmp-3.dll' name '__gmpz_scan1';
//  op���Astarting_bit����n�߂āA���bit�Ɍ������āA�ŏ���0 or 1�ł���bit��
// ������܂ŃX�L��������B�Ԃ�l�͌�������bit�̃C���f�b�N�X�ł���B
//  starting_bit���̂��T��bit�ł������Ƃ��́Astarting_bit���Ԃ����B
//  ���̂悤��bit��������Ȃ������Ƃ���ULONG_MAX(unsigned long�̍ő�l)��
// �Ԃ����B����́Ampz_scan0�����̐��̒[���߂����Ƃ��A�܂��́A
// mpz_scan1�����̐��̒[���߂����Ƃ��ɔ�������B

TFmpz_setbit = procedure (var rop: mpz_t; bit_index: Cardinal); cdecl; 
//procedure mpz_setbit(var rop: mpz_t; bit_index: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_setbit';
// rop��bit_index bit�𗧂Ă�

TFmpz_clrbit = procedure (var rop: mpz_t; bit_index: Cardinal); cdecl; 
//procedure mpz_clrbit(var rop: mpz_t; bit_index: Cardinal); cdecl; external 'cyggmp-3.dll' name '__gmpz_clrbit';
// rop��bit_index bit������

TFmpz_tstbit = function (const op: mpz_t; bit_index: Cardinal): Integer; cdecl; 
//function mpz_tstbit(const op: mpz_t; bit_index: Cardinal): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_tstbit';
// op��bit_index bit���e�X�g���A���̌��� 0��1 ��Ԃ��B

{


  5.12 Input and Output Functions

    (�ڐA�Ғ�)����section�̊֐��Q��FILE�\���̂̈ڐA������ł��邽��
     �錾���Ă��Ȃ�
}

{


  5.13 Random Number Functions

// �ۗ�

}

{


  5.14 Integer Import and Export
    �ȉ��̊֐��ɂ��Ampz_t�ϐ��͎��R�ȃo�C�i���f�[�^��(����/��)�ϊ��ł���
}
TFmpz_import = procedure (var rop: mpz_t; count, order, size, endian, nails: Integer; const op); cdecl; 
//procedure mpz_import(var rop: mpz_t; count, order, size, endian, nails: Integer; const op); cdecl; external 'cyggmp-3.dll' name '__gmpz_import';
//  rop��op�̔z��f�[�^���Z�b�g����
//  �p�����[�^�̓f�[�^�̃t�H�[�}�b�g���w�肷��B
//
// size: ���ꂼ��̔z��v�f��byte��
// count: �z��v�f�̐�
// order: =(1,-1), �z��̃G���f�B�A���w��
//  1 =�ŏ�ʗv�f���z��̍ŏ��ɃX�g�A����Ă���
//  -1=�ŉ��ʗv�f���z��̍ŏ��ɃX�g�A����Ă���
// endian: =(1,-1,0), �z��v�f�̒��ł̃G���f�B�A���w��
//  1 =�ŏ��byte���ŏ��ɗ���(�r�b�O�G���f�B�A��)
//  -1=�ŉ���byte���ŏ��ɗ���(���g���G���f�B�A��)
//  0 =CPU�̃G���f�B�A���ɏ]��
// nails: ���ꂼ��̔z��v�f�̒��ōŏ��nails bit�͎̂Ă���
//  ������0���w�肷��Ɣz��v�f�͑Sbit�g�p�����
//
//  �f�[�^�ɂ͕������͊܂܂�Ă��Ȃ��̂ŁArop�͐��̐����ɂȂ�B
// �v���O�����͕K�v������΁Ampz_neg�Ȃǂ�p���Ď����ŕ������Z�b�g���Ȃ��Ă�
// �Ȃ�Ȃ��B
//  op�ɃA���C�����g�����͂Ȃ��A�ǂ�ȃA�h���X�ł��������B
//
// (��)��͏ȗ��B�p�����[�^�����͉ӏ������ɕύX�B

TFmpz_export = function (var rop; var countp: Integer; order, size, endian, nails: Integer; const op: mpz_t): Pointer; cdecl; 
//function mpz_export(var rop; var countp: Integer; order, size, endian, nails: Integer; const op: mpz_t): Pointer; cdecl; external 'cyggmp-3.dll' name '__gmpz_export';
//  op����z��f�[�^�ɕϊ�����rop�ɏ�������
//  (��)�������Ȃ��p�����[�^��mpz_import�Ɠ����Ӗ��ł���B
//  �ϊ����ꂽ�z��v�f�̐���*countp�ɏ������܂�邪�Acountp��NULL���w�肷���
// �v�f���͎̂Ă���B
// rop�ɂ̓f�[�^���������ނ̂ɏ\���ȗ̈悪�K�v�ł���Brop��NULL���w�肷���
// ���ʂ̔z��́A���݂�GMP�A���P�[�g�֐����g���ĕK�v�ȗ̈���m�ۂ��Ă�����
// �������܂��B�̈��^����ꂽ���m�ۂ������ɂ�����炸�A�Ԃ�l�͌��ʂւ�
// �|�C���^�ł���B
//  op����0�ł���΁A�ŏ�ʔz��v�f�͔�0�ł���Bop��0�ł���΁Acount��0��Ԃ�
// rop�ɂ͉����������܂�Ȃ��B���̂Ƃ��Arop��NULL�ł���΁A�̈�͊m�ۂ��ꂸ�A
// NULL���Ԃ����B
//  �����͖�������A��Βl���G�N�X�|�[�g�����B�v���O�����͕K�v������΁A
// mpz_sgn���g���������擾���Ȃ���΂Ȃ�Ȃ��B
//  op�ɃA���C�����g�����͂Ȃ��A�ǂ�ȃA�h���X�ł��������B
//  �v���O���������g�ŗ̈���m�ۂ���Ƃ��́A�ȉ��̎��ŕK�v�ȗ̈���v�Z�ł���B
//   numb = 8*size - nail;
//   count = (mpz_sizeinbase(z,2) + numb-1) / numb;
//   p = malloc(count*size);
//  �����ŁAz��0�ł���Ζ{���͗̈�͕K�v�ł͂Ȃ����Ampz_sizeinbase�͏��1�ȏ��
// �Ԃ����߁Acount��1�ȏ�ɂȂ�B�����malloc(0)�Ŗ�肪�������邱�Ƃ�����邱��
// ���ł��邽�߂ł�����B

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
// ���̂���op�����܂肫��Δ�0�A����Ȃ�0��Ԃ�

function mpz_odd_p(const op: mpz_t): Boolean;
function mpz_even_p(const op: mpz_t): Boolean;
// op������������𔻒肷��B
// ���̊֐��̓I���W�i���ł̓}�N���ł���B

type
TFmpz_size = function (const op: mpz_t): Integer; cdecl;
//function mpz_size(const op: mpz_t): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_size';
// op��limb�̐���Ԃ��Bop��0�̎���0

TFmpz_sizeinbase = function (const op: mpz_t; base: Integer): Integer; cdecl; 
//function mpz_sizeinbase(const op: mpz_t; base: Integer): Integer; cdecl; external 'cyggmp-3.dll' name '__gmpz_sizeinbase';
//  op��base�i���\�L�������̃T�C�Y��Ԃ��Bbase��2-36���L���ł���B
// �����͖�������A��Βl���g�p�����B
// ���ʂ͂��傤�ǂ��A1�����傫���Ȃ�B
// base��2�̗ݏ�ł���Ȃ�A���ʂ͂����������B
// op��0�ł���Ȃ�A���1��Ԃ��B
//  ���̊֐��́Aop�𕶎���ɂ��鎞�ɕK�v�ȗ̈��m��̂Ɏg�����Ƃ��ł���B
// �ʏ�A�K�v�ȗ̈�́A���̊֐��̕Ԃ�l���2�����傫���B
// ��������null-terminator�̕��ł���B
//  mpz_sizeinbase(op,2)�́A1���琔���Ĉ�ԑ傫�������Ă���r�b�g�̏ꏊ��
// �m��̂Ɏg�p�ł���B(bitwise�֐���0���琔����)


{


  10 Formatted Output

    10.1 Format Strings
      �i�����̏ڍׂ̓w���v�Q�Ɓj

    10.2 Functions
      �����̊֐��Q�́A�Ή�����C�̊֐��Ɠ��l�ł���B
      ���������񂪕s���ł�������A�ψ������ϊ��w��q�ƈ�v���Ȃ��ꍇ��
      ����͗\���s�\�ł��邱�Ƃ��������Ă����B

      (�ڐA�Ғ�)
      vprintf�n��̊֐��́A�ψ����̍\����Delphi�ƈقȂ�̂Ő錾���Ă��Ȃ��B
      fprintf,asprintf,obstack_printf�ɂ��Ă��ڐA������ł��邽��
      �錾���Ă��Ȃ��B

      �ψ�����GMP�\���̂�n�����́A�|�C���^��n�����ƁB
      ���̂܂܎w�肷��ƁA�l�n���ɂȂ蓮�삵�Ȃ��B

      �^�Ȃ��I�[�v���p�����[�^�ł̓��b�p�[�ł��邪�ADelphi��gcc�̌^�̌݊�����
      �C�����邱�ƁB
      64bit�����^�ɂ͑Ή����Ă��Ȃ��B
      ���������_�^��Extended->Double�̕ϊ����s���Adouble�̂ݑΉ����Ă���B
      string��^����Ƃ��̓k���^�[�~�l�[�g���Ăяo�����ŕۏ؂��邱�ƁB
}
type
TF_gmp_printf = function: Integer; cdecl;
//function _gmp_printf(const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_printf';
function gmp_printf(const fmt: String; const Args: array of const): Integer;
// �W���o�͂ɏo�͂���B�Ԃ�l�́A�G���[��-1�A����I���ŏ������񂾕������B
// Delphi�ł̓R���\�[���������Ȃ��v���O�����ł͖����ł���B
//
// �ψ��������cdecl�Ăяo�����łł͕��������_�^��double�ł���̂Œ��ӁB
// �I�[�v���p�����[�^���b�p�[�łł͕��������_�^Extended��double�ɗ��Ƃ��Ă���B

type
TF_gmp_sprintf = function: Integer; cdecl;
//function _gmp_sprintf(buf: PChar; const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_sprintf';
function gmp_sprintf(buf: PChar; const fmt: String; const Args: array of const): Integer;
//  null�I���������buf�ɏo�͂���B�Ԃ�l��null���������������񂾕������B
//  buf��fmt�̗̈悪�d�Ȃ邱�Ƃ͋�����Ă��Ȃ��B
//  ���̊֐��́Abuf�̊m�ۗ̈���z���ď������ނ̂�h����i�������Ȃ����߁A
// ��������Ȃ��B
//
// �ψ��������cdecl�Ăяo�����łł͕��������_�^��double�ł���̂Œ��ӁB
// �I�[�v���p�����[�^���b�p�[�łł͕��������_�^Extended��double�ɗ��Ƃ��Ă���B

type
TF_gmp_snprintf = function: Integer; cdecl;
//function _gmp_snprintf(buf: PChar; size: Integer; const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_snprintf';
function gmp_snprintf(buf: PChar; size: Integer; const fmt: String; const Args: array of const): Integer; overload;
function gmp_snprintf(var buf: String; const fmt: String; const Args: array of const): Integer; overload;
//  null�I���������buf�ɏo�͂���Bsize�𒴂��ď������܂�邱�Ƃ͂Ȃ��B
// �o�͑S�̂��󂯎��ɂ́A�������null-terminator���������ނ̂ɏ\����
// �傫����size�Ɏw�肵�Ȃ���΂Ȃ�Ȃ��B
//  �Ԃ�l�́Anull����������������(�͂�)�̕������ł���B
// �����Aresult>=size�ł���Ȃ�΁A���ۂ̏o�͂�size-1�����̏o�͂�null��
// �؂�̂Ă��Ă���B
//  buf��fmt�̗̈悪�d�Ȃ邱�Ƃ͋�����Ă��Ȃ��B
//  �Ԃ�l��ISO C99 snprintf�`���ł���BC library��vsprintf���Â�GLIBC 2.0.x
// ���Ƃ��Ă����Ƃ��Ă��A����͕ς��Ȃ��B
//
//  �ψ��������cdecl�Ăяo�����łł͕��������_�^��double�ł���̂Œ��ӁB
//  �I�[�v���p�����[�^���b�p�[�łł͕��������_�^Extended��double�ɗ��Ƃ��Ă���B
//  string�����ł͌Ăяo������SetLength�Ŋm�ۂ��ꂽ�̈���o�͗̈�Ƃ���B
// �o�͂�buf��菬������Ύ����I�ɗ̈�̓g���~���O�����B

{


  10 Formatted Input

    10.1 Formatted Input Strings
      �i�����̏ڍׂ̓w���v�Q�Ɓj

    10.2 Formatted Input Functions
      �����̊֐��Q�́A�Ή�����C�̊֐��Ɠ��l�ł���B
      ���������񂪕s���ł�������A�ψ������ϊ��w��q�ƈ�v���Ȃ��ꍇ��
      ����͗\���s�\�ł��邱�Ƃ��������Ă����B
      ����������ƕϊ����ʂ̏o�͕ϐ��Q�Ƃ̗̈悪�d�Ȃ邱�Ƃ͔F�߂��Ă��Ȃ��B

      (�ڐA�Ғ�)
      vprintf�n��̊֐��́A�ψ����̍\����Delphi�ƈقȂ�̂Ő錾���Ă��Ȃ��B
      fprintf,�ɂ��Ă��ڐA������ł��邽��
      �錾���Ă��Ȃ��B

      �ψ�����GMP�\���̂�n�����́A�|�C���^��n�����ƁB
      ���̂܂܎w�肷��ƁA�l�n���ɂȂ蓮�삵�Ȃ��B
}
type
TF_gmp_scanf = function: Integer; cdecl;
//function _gmp_scanf(const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_scanf';
function gmp_scanf(const fmt: String; const Args: array of Pointer): Integer;
// �W�����͂���ǂ�

type
TF_gmp_sscanf = function: Integer; cdecl;
//function _gmp_sscanf(const s: PChar; const fmt: PChar): Integer; cdecl; varargs; external 'cyggmp-3.dll' name '__gmp_sscanf';
function gmp_sscanf(const s: String; const fmt: String; const Args: array of Pointer): Integer;
// s�Ɏw�肳�ꂽnull�I�������񂩂�ǂ�

//  ���̊֐��̕Ԃ�l�́A�W����C99 scanf�Ɠ������A����ɉ��߂���X�g�A���ꂽ
// �t�B�[���h�̐��ł���B'%n'�Ŏw�肵���t�B�[���h�ƁA'*'�ɂ����͗}������
// �t�B�[���h�́A�Ԃ�l�̃J�E���g�ɓ���Ȃ��B
//  ����ȑO�̔���͗}���t�B�[���h��1���}�b�`���Ă��Ȃ���ԂŁA
// �}�b�`���ׂ��t�B�[���h������̂ɁA�t�@�C���̏I��,�t�@�C���G���[,������̏I��
// �̂����ꂩ�ɑ��������ꍇ�́A�Ԃ�l��0�ł͂Ȃ�EOF��Ԃ��B
// ���������񒆂̃��e����������'%n'�ȊO�̃t�B�[���h�̓}�b�`���v�������B
// ���������񒆂�whitespase�͔C�ӈ�v�ł����Ȃ��A���̌`����EOF�͔������Ȃ��B
// ��swhitespase�́A�ǂݍ���Ŕj������A�}�b�`�̐��ɓ���Ȃ��B
//
//  �I�[�v���p�����[�^�ł̓��b�p�[�ł���B
// string�̃A�h���X��n���Ƃ���SetLength�ȂǂŊm�ۂ��Ă������ƁB





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


//���I���[�hDLL�֐��錾
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

