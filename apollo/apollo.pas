unit apollo;
{
*********************************************************
�V��&Crescent �g���b�v�F�؃��[�`��
�C���^�t�F�[�X
Delphi+gmp&longint���I�I���

  programmed by "replaceable anonymous"

/////////////////////////////////////////////////////////
�����ŕϊ����s���̂�Base64, MD5���K�v�ł�
*********************************************************

���ŗ���
  ver 0.4 2004/08/14
    cyggmp-3.dll�̃��[�h�����������gmp��(����)
    ���s�����longint�ł��g�p����悤��


/////////////////////////////////////////////////////////
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

*********************************************************
�g���b�v�d�lver0.3 2004/03/20

  ##apollo512-2 2004/02/16
	1)������ϊ����[��(base64.c)

		���{������<->������
			�ŉ���6bit����base64�e�[�u���ɏ������ĕϊ�
			������̐擪�����������̍ŉ���6bit
			������̍Ō�����ŏ��

			�z�肳��鎚���ɑ���Ȃ�����0����[�����
			(�����ϊ�����A���������)

		���������k
			�^����ꂽ���������MD5�n�b�V�����Ƃ�A
			����base64�G���R�[�h�̐擪11�������Ƃ�

	2)���̐������[��

		�f���e�X�g�ɂ̓~���[�e�X�g���g�p���A�ŏ���10��
		�f���ɑ΂��ăp�X�����[�f����f���Ƃ݂Ȃ��B

		���J�搔e��65537

		�g���b�v���������񂩂�f��p,q�𐶐�
			����������ˑ��̃����_����p,q�̂Ƃ��
				hash1:  �g���b�v����������($key)��MD5�n�b�V��
				hash2:  $key + 'pad1'  ��MD5�n�b�V��
				hash3:  $key + 'pad2'  ��MD5�n�b�V��
				hash4:  $key + 'pad3'  ��MD5�n�b�V��

				�Ƃ��Ahashs�����̘A���Ƃ���B

				p��num[0]-num[6] := hashs[0-27] (28byte)
				q��num[0]-num[8] := hashs[28-63](36byte)
				(little-endian�ŏ�������B�܂�hashs�̍ŏ���
				�o�C�g��p�̍ŉ��ʃo�C�g�ɂȂ�悤��)

				p��216bit��菬���Ȉ����ɂȂ�̂�h������
				p.num[6]�̉�����24bit��(216bit�ځA��215bit)��1�ɂ���
				q��280bit��菬���Ȉ����ɂȂ�̂�h������
				q.num[8]�̉�����24bit��(280bit�ځA��279bit)��1�ɂ���
				����ɂ��An��496bit������邱�Ƃ͂Ȃ�

			p,q��RSA�ɓK����f���ɂ���ϊ���
				q��q�ȏ�ōŏ��̋[�f���Ƃ���
				p��p�ȏ�ōŏ��̋[�f���Ƃ���

				(p-1)(q-1)��e=65537���݂��ɑf ����
				t = 0x7743,de �� 1 mod(p-1)(q-1),n = pq �Ȃ�t,d,n�ɑ΂�
				t^ed �� t (mod n)������

				�𖞂���p,q���o��܂�p+=2,q+=2���đf���e�X�g����J��Ԃ�
				�������������s��(300=RSACreateGiveup)�𒴂���ƃG���[

		�������Đ�������n�����J���Ad��閧���Ə̂���
		������ɕϊ�����ۂ͏�L�ϊ�����p����86�����Ƃ���

	3)�������[��
		RSA�Í��� m^d �� c (mod n)
		�Ɏg�p����m�̕ϊ����[��

		�^����ꂽ�����Ώۃn�b�V���������Mes[0-63]�Ƃ���
		64byte�ɖ����Ȃ��ꍇ�A�󂫂ɂ�0�����肳��A
		������ꍇ�͒����������͖��������

		m.num[0-15] := Mes[0-63](64byte)
		(little-endian�ŏ�������BMes�̍ŏ��̃o�C�g��m�̍ŉ��ʃo�C�g)


  ##apollo1024-3 2004/03/20
	1)������ϊ����[��
    apollo512-2 �Ɠ���

	2)���̐������[��

		�f���e�X�g�ɂ̓~���[�e�X�g���g�p���A�ŏ���10��
		�f���ɑ΂��ăp�X�����[�f����f���Ƃ݂Ȃ��B

		���J�搔e��65537

		�g���b�v���������񂩂�f��p,q�𐶐�
			����������ˑ��̃����_����p,q�̂Ƃ��
				hash1:  �g���b�v����������($key)��MD5�n�b�V��
				hash2:  $key + 'pad1'  ��MD5�n�b�V��
				hash3:  $key + 'pad2'  ��MD5�n�b�V��
				hash4:  $key + 'pad3'  ��MD5�n�b�V��
				hash5:  $key + 'pad4'  ��MD5�n�b�V��
				hash6:  $key + 'pad5'  ��MD5�n�b�V��
				hash7:  $key + 'pad6'  ��MD5�n�b�V��
				hash8:  $key + 'pad7'  ��MD5�n�b�V��

				�Ƃ��Ahashs�����̘A���Ƃ���B

				p��num[0]-num[12] := hashs[0-51] (52byte)
				q��num[0]-num[18] := hashs[52-127](76byte)
				(little-endian�ŏ�������B�܂�hashs�̍ŏ���
				�o�C�g��p�̍ŉ��ʃo�C�g�ɂȂ�悤��)

				p��410bit��菬���Ȉ����ɂȂ�̂�h������
				p.num[12]�̉�����26bit��(410bit�ځA��409bit)��1�ɂ���
				q��602bit��菬���Ȉ����ɂȂ�̂�h������
				q.num[18]�̉�����26bit��(602bit�ځA��601bit)��1�ɂ���
				����ɂ��An��1012bit������邱�Ƃ͂Ȃ�

			p,q��RSA�ɓK����f���ɂ���ϊ���
				q��q�ȏ�ōŏ��̋[�f���Ƃ���
				p��p�ȏ�ōŏ��̋[�f���Ƃ���

				(p-1)(q-1)��e=65537���݂��ɑf ����
				t = 0x7743,de �� 1 mod(p-1)(q-1),n = pq �Ȃ�t,d,n�ɑ΂�
				t^ed �� t (mod n)������

				�𖞂���p,q���o��܂�p+=2,q+=2���đf���e�X�g����J��Ԃ�
				�������������s��(300=RSACreateGiveup)�𒴂���ƃG���[

		�������Đ�������n�����J���Ad��閧���Ə̂���
		������ɕϊ�����ۂ͏�L�ϊ�����p����171�����Ƃ���

	3)�������[��
		apollo512-2 �Ɠ���

*********************************************************
�Í����d�l(ver0.0 2004/03/24)

  �Í����ɂ�RSA���J���Í���RC4���ʌ��Í��𕹗p����B
  RC4�̌��������_���ɐ������A���J���Í��ňÍ������ĕt������B

  a)�Í����菇
    �g���b�v(pubkey)=n�̌����Ɠ��������̗�����p�ӂ���B
    �������A���l�������Ƃ���n�𒴂��Ă͂Ȃ�Ȃ�(RSA�ł̗v��)
    �����m�Ƃ���B
    m��n��e�ňÍ�������(c = m^e mod n)
    RC4�̌��Ƃ���m���g���A�^����ꂽ�������Í�������B
    c(���J���ňÍ�������RC4�̌�)+RC4�̈Í�����Base64�G���R�[�h����

  b)�����菇
    �Í�����Base64�f�R�[�h���A�Í������ꂽRC4��(=c)�𓾂�B
    �閧��(=d)�ƌ��J��(=n)��c�𕜍����ARC4���𓾂�(m = c ^ d mod n)
    RC4�̌��Ƃ���m���g���A�f�R�[�h�ς݂̈Í����𕜍�����

*********************************************************
*********************************************************
��������
  procedure RSAkeycreate512(var publickey: String;var secretkey: String;const keystr: String);
  procedure RSAkeycreate1024(var publickey: String;var secretkey: String;const keystr: String);
  �g���b�v���y�A�쐬���쐬
    keystr: �g���b�v��������
    publickey: ���J��������(�@n)
    secretkey: �閧��������(�閧���搔d)

  �ȉ��̃��[�`���͂ǂ���̎d�l�̃g���b�v���y�A�ł����Ă������܂�

  function RSAsign(const mes: String;const publickey: String;const secretkey: String): String;
  ����
    �Ԃ�l: ����������
    mes:  �����Ώ�(n�����Z�����Ƃ��K�v)
      mes�ɂ͏����������Ώۂ�MD5�Ȃǂ�^���Ă�������

  function RSAverify(const mes: String;const testsignature: String;const publickey: String): Boolean;
  �F��
    �Ԃ�l: �ʂ��true
    mes:  �����Ώ�(n�����Z�����Ƃ��K�v)
    testsignature: ����������

  function triphash(const keystr: String): String;
  ���������k �݂₷���悤��11�����Ɉ��k���܂�
  (keystr��MD5�n�b�V����Base64�G���R�[�h�擪11����)


  function RSAencrypt(const plainmes: String;const publickey: String): String;
  ���J���ɂ��Í��� �g���b�v�L�[��m���Ă���l�������J���ł���Í������{���܂�
    �Ԃ�l: �Í�����
    plainmes: �Í�����������

  function RSAdecrypt(const cryptmes: String;const publickey: String;const secretkey: String): String;
  �閧���ɂ�镜�� RSAencrypt���ꂽ�Í������𕜍����܂�
  �����ɂ͌��y�A���K�v�ł�
    �Ԃ�l: �������ꂽ��
    cryptmes: �Í�����
}

interface

var
  RSAkeycreate512: procedure (var publickey: String;var secretkey: String;const keystr: String);
  RSAkeycreate1024: procedure (var publickey: String;var secretkey: String;const keystr: String);
  //�g���b�v���y�A�쐬

  RSAsign: function (const mes: String;const publickey: String;const secretkey: String): String;
  //����

  RSAverify: function (const mes: String;const testsignature: String;const publickey: String): Boolean;
  //�F��

  triphash: function (const keystr: String): String;
  //���������k 11�����Ɉ��k

  RSAencrypt: function (const plainmes: String;const publickey: String): String;
  //���J���ɂ��Í���

  RSAdecrypt: function (const cryptmes: String;const publickey: String;const secretkey: String): String;
  //�閧���ɂ�镜��(���y�A���K�v)

  RSAdesign: function (const mes: String;const publickey: String;const secretkey: String): String;
  //�f�o�b�O�p

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
