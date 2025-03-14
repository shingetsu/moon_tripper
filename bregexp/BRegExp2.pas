unit BRegExp2;

///////////////////////////////////////////////////////////////////////
// BRegExp2.pas : Borland Delphi 用 BREGEXP.DLL 利用ユニット
// 動的リンク改造版 2003/11/25
//
// TBRegExp.Createの時に bregexp.dllを動的ロードします
// IsLoadedプロパティにロードが成功したかどうかがセットされます。
//
//  arranged by 名無しが氏んでも代わりはいるもの
//  改造に伴うバグがあったとしても原作者とは無関係です。
//  権利関係は原作者の意向のままでお願いします。
//////////////////////////////////////////////////////////////////////

//=====================================================================
// BRegExp.pas : Borland Delphi 用 BREGEXP.DLL 利用ユニット
//               1998/10/03版      osamu@big.or.jp
//
// BREGEXP.DLL は、http://www.hi-ho.or.jp/~babaq/ にて公開されている
// Perl5互換の正規表現エンジン BREGEXP.DLL を Borland Delphi から利用
// するためのユニットファイルです。Delphi 3 で作成しましたが、32bit
// 版の Delphi および C++ Builder で動作可能と思います。
//
// BREGEXP.DLL の利用条件などは、同ホームページをご参照下さい。有用な
// ライブラリを無償で提供下さっている babaq さんに感謝するとともに、
// 今後のご活躍を期待しています。
//
// 本ユニットの著作権については、とやかく言うつもりはありません。好きな
// ようにお使い下さい。ただし、利用に当たってはご自分の責任の下にお願
// いします。本ユニットに関して osamu@big.or.jp は何ら責任を負うことは
// 無いものとします。
//
// 本ユニットは、 DLL とともに配布されているヘッダファイル及び、上記ホーム
// ページで行われたユーザサポートのログファイルをもとに作成されました。
// お気づきの点などありましたら、osamu@big.or.jp まで電子メールにて
// お知らせ下されば、気分次第ではなんらかの対処をする可能性があります。(^_^;
//
// 使用方法については付属のヘルプファイルをご覧下さい。
//=====================================================================
//               2001/04/14版      osamu@big.or.jp
// 本家のドキュメントのバージョンアップに伴い発覚していたバグを修正
// brx 関数を導入
// 空文字に対する検索のエラー回避
// MatchPos を 1 から数え始めるように仕様変更
// Subst 後に Strings[] を参照可能にした
// これに伴い大量の文字列に対する置き換え動作は遅くなった
//=====================================================================

interface

uses SysUtils;

//=====================================================================
// 本家 BREGEXP.H と、サポートホームページのドキュメントより
// BREGEXP.DLL と直結した宣言
//=====================================================================

const
BREGEXP_ERROR_MAX= 80;  // エラーメッセージの最大長

type
PPChar=^PChar;
TBRegExpRec=packed record
    outp: PChar;        // 置換え結果先頭ポインタ
    outendp: PChar;     // 置換え結果末尾ポインタ
    splitctr: Integer;  // split 結果カウンタ
    splitp: PPChar;     // split 結果ポインタポインタ
    rsv1: Integer;      // 予約済み
    parap: PChar;       // コマンド文字列先頭ポインタ ('s/xxxxx/yy/gi')
    paraendp: PChar;    // コマンド文字列末尾ポインタ
    transtblp: PChar;   // tr テーブルへのポインタ
    startp: PPChar;     // マッチした文字列への先頭ポインタ
    endp: PPChar;       // マッチした文字列への末尾ポインタ
    nparens: Integer;   // match/subst 中の括弧の数
end;
pTBRegExpRec=^TBRegExpRec;

type
  FuncBMatch = function (str, target, targetendp: PChar;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
  FuncBSubst = function (str, target, targetendp: PChar;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
  FuncBTrans = function (str, target, targetendp: PChar;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
  FuncBSplit = function (str, target, targetendp: PChar; limit: Integer;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
  FuncBRegFree = procedure (rx: pTBRegExpRec); cdecl;
  FuncBRegExpVersion = function :PChar; cdecl;

var
  BMatch: FuncBMatch;
  BSubst: FuncBSubst;
  BTrans: FuncBTrans;
  BSplit: FuncBSplit;
  BRegFree: FuncBRegFree;
  BRegExpVersion: FuncBRegExpVersion;
{
function BMatch(str, target, targetendp: PChar;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
    external 'bregexp.dll';
function BSubst(str, target, targetendp: PChar;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
    external 'bregexp.dll';
function BTrans(str, target, targetendp: PChar;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
    external 'bregexp.dll';
function BSplit(str, target, targetendp: PChar; limit: Integer;
                var rxp: pTBRegExpRec; msg: PChar): Boolean; cdecl;
    external 'bregexp.dll';
procedure BRegFree(rx: pTBRegExpRec); cdecl;
    external 'bregexp.dll' name 'BRegfree';
function BRegExpVersion: PChar; cdecl;
    external 'bregexp.dll' name 'BRegexpVersion';
}
//=====================================================================
// TBRegExp : BREGEXP.DLL の機能をカプセル化するオブジェクト
//=====================================================================

type
EBRegExpError=class(Exception) end;
TBRegExpMode=(brxNone, brxMatch, brxSplit);
TBRegExp=class(TObject)
  private
    FIsLoaded: Boolean;
    FDLLHandle: THandle;
    Mode: TBRegExpMode;
    pTargetString: PChar;
    pBRegExp: PTBRegExpRec;
    function GetMatchPos: Integer;
    function GetMatchLength: Integer;
    function GetSplitCount: Integer;
    function GetSplitStrings(index: Integer): string;
    function GetMatchStrings(index:Integer): string;
    function GetMatchCount: Integer;
    function GetCount: Integer;
    function GetStrings(index: Integer): string;
    function GetLastCommand: string;
    procedure CheckCommand(const Command: string);
  public
    constructor Create;
    destructor Destroy; override;
  public
    function Match(const Command, TargetString: string): Boolean;
    function Subst(const Command: string; var TargetString: string): Boolean;
    function Split(const Command, TargetString: string; Limit: Integer): Boolean;
    function Trans(const Command: string;var TargetString: string): Boolean;
    property LastCommand: string read GetLastCommand;
    property MatchPos: Integer read GetMatchPos;
    property MatchLength: Integer read GetMatchLength;
    property Count: Integer read GetCount;
    property Strings[index: Integer]: string read GetStrings; default;
    property IsLoaded: Boolean read FIsLoaded;
end;

//=====================================================================
// 自動的に実体化、破棄されるユーティリティインスタンス
//=====================================================================

function brx: TBRegExp;

//=====================================================================

implementation

uses
  Windows;
//=====================================================================

var fbrx: TBRegExp;
function brx: TBRegExp;
begin
    if fbrx=nil then fbrx:=TBRegExp.Create;
    Result:=fbrx;
end;

//=====================================================================

constructor TBRegExp.Create;
begin
    inherited;
    FDLLHandle := LoadLibrary('bregexp.dll');
    if FDLLHandle <> 0 then
    begin
      @BMatch := GetProcAddress(FDLLHandle, 'BMatch');
      @BSubst := GetProcAddress(FDLLHandle, 'BSubst');
      @BTrans := GetProcAddress(FDLLHandle, 'BTrans');
      @BSplit := GetProcAddress(FDLLHandle, 'BSplit');
      @BRegFree := GetProcAddress(FDLLHandle, 'BRegfree');
      @BRegExpVersion := GetProcAddress(FDLLHandle, 'BRegexpVersion');
      if @BMatch = nil then
        FIsLoaded := False
      else if @BSubst = nil then
        FIsLoaded := False
      else if @BTrans = nil then
        FIsLoaded := False
      else if @BSplit = nil then
        FIsLoaded := False
      else if @BRegFree = nil then
        FIsLoaded := False
      else if @BRegExpVersion = nil then
        FIsLoaded := False
      else
        FIsLoaded := True;
    end
    else
      FIsLoaded := False;

end;

destructor TBRegExp.Destroy;
begin
    if FIsLoaded then
    begin;
      if pBRegExp<>nil then
          BRegFree(pBRegExp);
      FreeLibrary(FDLLHandle);
    end;
    inherited Destroy;
end;

//=====================================================================
// 前回のコマンド文字列を返す

function TBRegExp.GetLastCommand: string;
var len: Integer;
begin
    if pBRegExp=nil then begin
        Result:= '';
    end else begin
        len:= Integer(pBRegExp^.paraendp)-Integer(pBRegExp^.parap);
        SetLength(Result, len);
        Move(pBRegExp^.parap^, Result[1], len);
    end;
end;

//=====================================================================
// 前回と異なるコマンドであればキャッシュをクリアする内部手続き

procedure TBRegExp.CheckCommand(const Command: string);
var p,q: PChar;
begin
    if not FIsLoaded then
      raise EBRegExpError.Create('DLL not loaded');
    if pBRegExp=nil then Exit;
    p:= pBRegExp.parap - 1;
    q:= PChar(@Command[1]) - 1;
    repeat
        Inc(p);
        Inc(q);
        if p^<>q^ then begin
            BRegFree(pBRegExp);
            pBRegExp:= nil;
            Break;
        end;
    until p^=#0;
end;

//=====================================================================

function TBRegExp.Match(const Command, TargetString: string): Boolean;
var ErrorString: string;
    i: Integer;
begin
    if not FIsLoaded then
      raise EBRegExpError.Create('DLL not loaded');
    CheckCommand(Command);
    SetLength(ErrorString, BREGEXP_ERROR_MAX);
    Mode:=brxNone;
    if TargetString='' then begin // エラー回避
        i:=0;
        Result:=BMatch(
            PChar(Command),
            PChar(@i),
            PChar(@i)+1,    
            pBRegExp,
            PChar(ErrorString));
    end else begin
        Result:=BMatch(
            PChar(Command),
            PChar(TargetString),
            PChar(TargetString)+Length(TargetString),
            pBRegExp,
            PChar(ErrorString));
    end;
    SetLength(ErrorString, StrLen(PChar(ErrorString)));
    if ErrorString<>'' then
        raise EBRegExpError.Create(ErrorString);
    if Result then Mode:= brxMatch;
    pTargetString:= PChar(TargetString);
end;

//=====================================================================

function TBRegExp.Subst(const Command: string;
                        var TargetString: string): Boolean;
var ErrorString: string;
    ep,sp: PPChar;
    i: Integer;
    TextBuffer: string;
begin
    if not FIsLoaded then
      raise EBRegExpError.Create('DLL not loaded');
    CheckCommand(Command);
    Result:=False;
    if TargetString='' then Exit;
    TextBuffer:= TargetString;  // ( ) を正しく返すためにテキストを保存する
    UniqueString(TextBuffer);
    SetLength(ErrorString, BREGEXP_ERROR_MAX);
    Mode:=brxNone;
    Result:=BSubst(
        PChar(Command),
        PChar(TargetString),
        PChar(TargetString)+Length(TargetString),
        pBRegExp,
        PChar(ErrorString));
    SetLength(ErrorString,StrLen(PChar(ErrorString)));
    if ErrorString<>'' then 
        raise EBRegExpError.Create(ErrorString);

    if Result then begin // ( ) の結果を正しく返すため
        sp:=pBRegExp^.startp;
        ep:=pBRegExp^.endp;
        for i:=0 to GetMatchCount-1 do begin
            Inc(ep^, Integer(TextBuffer)-Integer(TargetString));
            Inc(sp^, Integer(TextBuffer)-Integer(TargetString));
            Inc(sp);
            Inc(ep);
        end;
        TargetString:= pBRegExp^.outp;
        Mode:=brxMatch;
    end;
end;

//=====================================================================

function TBRegExp.Trans(const Command: string;
                        var TargetString: string): Boolean;
var ErrorString: string;
begin
    if not FIsLoaded then
      raise EBRegExpError.Create('DLL not loaded');
    CheckCommand(Command);
    Mode:=brxNone;
    if TargetString='' then // エラー回避
        TargetString:= #0;
    SetLength(ErrorString, BREGEXP_ERROR_MAX);
    Result:=BTrans(
        PChar(Command),
        PChar(TargetString),
        PChar(TargetString)+Length(TargetString),
        pBRegExp,
        PChar(ErrorString));
    SetLength(ErrorString,StrLen(PChar(ErrorString)));
    if ErrorString<>'' then
        raise EBRegExpError.Create(ErrorString);
    if Result then TargetString:=pBRegExp^.outp;
end;

//=====================================================================

function TBRegExp.Split(const Command, TargetString: string;
                        Limit: Integer): Boolean;
var ErrorString: string;
    t: string;
begin
    if not FIsLoaded then
      raise EBRegExpError.Create('DLL not loaded');
    CheckCommand(Command);
    SetLength(ErrorString, BREGEXP_ERROR_MAX);
    Mode:=brxNone;
    if TargetString='' then begin // エラー回避
        t:= #0;
        Result:=BSplit(
            PChar(Command),
            PChar(t),
            PChar(t)+1,
            Limit,
            pBRegExp,
            PChar(ErrorString));
    end else begin
        Result:=BSplit(
            PChar(Command),
            PChar(TargetString),
            PChar(TargetString)+Length(TargetString),
            Limit,
            pBRegExp,
            PChar(ErrorString));
    end;
    SetLength(ErrorString,StrLen(PChar(ErrorString)));
    if ErrorString<>'' then
        raise EBRegExpError.Create(ErrorString);
    Mode:=brxSplit;
end;

//=====================================================================

function TBRegExp.GetMatchPos: Integer;
begin
    if Mode<>brxMatch then
        raise EBRegExpError.Create('no match pos');
    Result:=Integer(pBRegExp.startp^)-Integer(pTargetString)+1;
end;

//=====================================================================

function TBRegExp.GetMatchLength: Integer;
begin
    if Mode<>brxMatch then
        raise EBRegExpError.Create('no match length');
    Result:=Integer(pBRegExp.endp^)-Integer(pBRegExp.startp^);
end;

//=====================================================================

function TBRegExp.GetCount: Integer;
begin
    Result:=0;
    case Mode of
    brxNone:
        raise EBRegExpError.Create('no count now');
    brxMatch:
        Result:=GetMatchCount;
    brxSplit:
        Result:=GetSplitCount;
    end;
end;

//=====================================================================

function TBRegExp.GetMatchCount: Integer;
begin
    Result:= pBRegExp^.nparens+1;
end;

//=====================================================================

function TBRegExp.GetSplitCount: Integer;
begin
    Result:=pBRegExp^.splitctr;
end;

//=====================================================================

function TBRegExp.GetStrings(index: Integer): string;
begin
    Result:='';
    case Mode of
    brxNone:
        raise EBRegExpError.Create('no strings now');
    brxMatch:
        Result:=GetMatchStrings(index);
    brxSplit:
        Result:=GetSplitStrings(index);
    end;
end;

//=====================================================================

function TBRegExp.GetMatchStrings(index:Integer):string;
var sp,ep: PPChar;
begin
    Result:='';
    if (index<0) or (index>=GetMatchCount) then
        raise EBRegExpError.Create('index out of range');
    sp:=pBRegExp^.startp; Inc(sp, index);
    ep:=pBRegExp^.endp;   Inc(ep, index);
    SetLength(Result,Integer(ep^)-Integer(sp^));
    Move(sp^^,PChar(Result)^,Integer(ep^)-Integer(sp^));
end;

//=====================================================================

function TBRegExp.GetSplitStrings(index:Integer): string;
var p: PPChar;
    sp,ep: PChar;
begin
    if (index<0) or (index>=GetSplitCount) then
        raise EBRegExpError.Create('index out of range');
    p:=pBRegExp^.splitp;
    Inc(p,index*2); sp:=p^;
    Inc(p);         ep:=p^;
    SetLength(Result,Integer(ep)-Integer(sp));
    Move(sp^,PChar(Result)^,Integer(ep)-Integer(sp));
end;

//=====================================================================

initialization
finalization
    fbrx.Free;
end.

