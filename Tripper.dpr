program Tripper;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  keygen in 'keygen.pas',
  BRegExp2 in 'bregexp\BRegExp2.pas',
  match in 'match.pas',
  apollo in 'apollo\apollo.pas',
  Base64 in 'apollo\Base64.pas',
  MD5 in 'apollo\MD5.pas',
  RC4 in 'apollo\RC4.pas',
  apollo_g in 'apollo\gmp\apollo_g.pas',
  factor_g in 'apollo\gmp\factor_g.pas',
  gmp2 in 'apollo\gmp\gmp2.pas',
  RSAbase_g in 'apollo\gmp\RSAbase_g.pas',
  apollo_l in 'apollo\longint\apollo_l.pas',
  factor_l in 'apollo\longint\factor_l.pas',
  longint in 'apollo\longint\longint.pas',
  RSAbase_l in 'apollo\longint\RSAbase_l.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'åéÇÃçëÇÃÇ∆ÇËÇ¡ÇœÅ[';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
