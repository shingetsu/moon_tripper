unit keygen;

interface

uses
  Classes, Windows;

const
  TripBufMax = 1024;

type
  TKeyRecord = record
    TripKey: String;
    pubKey: String;
    secKey: String;
    TripStr: String;
  end;

  TSearchType = (stNums, stAlpha, st7bit, stAll);

  TTripList = class(TObject)
  private
    FTrips: array[0..TripBufMax] of TKeyRecord;
    FReadBlock: Integer;
    FWriteBlock: Integer;
  // 読むときはWriteBlockのところから読む。
  // 書くときはReadBlockのところから書く。
  // 読み込みが終了して不要になればWriteBlockを先に進める
  // 書き込みが終了して読み込み可になればReadBlockを先に進める

  public
    constructor Create;
    function ReadNext(out Trips: TKeyRecord): Boolean;
    function WriteNext(const Trips: TKeyRecord): Boolean;
    function IsEmpty: Boolean;
  end;

  TKeyGenerater = class(TThread)
  private
    FpreFixed: String;
    FpostFixed: String;
    FvarString: String;
    FSearchType: TSearchType;
    FSearchForward: Boolean;

    procedure SetPreFixed(s: String);
    procedure SetPostFixed(s: String);
    procedure SetVarString(s: String);
    procedure SetSearchType(s: TSearchType);
    procedure SetSearchDirection(sForward: Boolean);

    function GetNextKey: String;

  protected
    procedure Execute; override;
  public
    property preFixed: String read FpreFixed write SetPreFixed;
    property postFixed: String read FpostFixed write SetPostFixed;
    property varString: String read FvarString write SetVarString;
    property SerachType: TSearchType read FSearchType write SetSearchType;
    property SerachForward: Boolean read FSearchForward write SetSearchDirection;
    constructor Create;
  end;

function NextChar(var c: Char; sType: TSearchType): Boolean;
function PreviousChar(var c: Char; sType: TSearchType): Boolean;

implementation

uses
  StrUtils, Unit1, apollo;

function NextChar(var c: Char; sType: TSearchType): Boolean;
begin
    Result := False;
    case sType of
      stNums:
        begin
          if c in ['0'..'8'] then
          begin
            Inc(c);
          end else if c = '9' then
          begin
            c := '0';
            Result := True;
          end else
          begin
            c := '0'
          end;
        end;
      stAlpha:
        begin
          if c in ['0'..'8','A'..'Y','a'..'y'] then
          begin
            Inc(c);
          end else if c = '9' then
          begin
            c := 'A';
          end else if c = 'Z' then
          begin
            c := 'a';
          end else if c = 'z' then
          begin
            c := '0';
            Result := True;
          end else
          begin
            c := '0';
          end;
        end;
      st7bit:
        begin
          if c in [#$20..#$7d] then
          begin
            Inc(c);
            if c in ['&','<','>'] then
              Inc(c);
          end else if c = #$7e then
          begin
            c := #$20;
            Result := True;
          end else
          begin
            c := #$20;
          end;
        end;
      stAll:
        begin
          if c = High(Char) then
            Result := True;
          Inc(c);
        end;
    end;
end;

function PreviousChar(var c: Char; sType: TSearchType): Boolean;
begin
    Result := False;
    case sType of
      stNums:
        begin
          if c in ['1'..'9'] then
          begin
            Dec(c);
          end else if c = '0' then
          begin
            c := '9';
            Result := True;
          end else
          begin
            c := '9'
          end;
        end;
      stAlpha:
        begin
          if c in ['1'..'9','B'..'Z','b'..'z'] then
          begin
            Dec(c);
          end else if c = 'A' then
          begin
            c := '9';
          end else if c = 'a' then
          begin
            c := 'Z';
          end else if c = '0' then
          begin
            c := 'z';
            Result := True;
          end else
          begin
            c := 'z';
          end;
        end;
      st7bit:
        begin
          if c in [#$21..#$7e] then
          begin
            Dec(c);
            if c in ['&','<','>'] then
              Dec(c);
          end else if c = #$20 then
          begin
            c := #$7e;
            Result := True;
          end else
          begin
            c := #$7e;
          end;
        end;
      stAll:
        begin
          if c = Low(Char) then
            Result := True;
          Dec(c);
        end;
    end;
end;

constructor TTripList.Create;
begin
    inherited;
    FReadBlock := 1;
    FWriteBlock := 0;
end;

function TTripList.IsEmpty: Boolean;
var
  tmpNowRead: Integer;
  tmpReadBlock: Integer;
begin
    tmpNowRead := FWriteBlock;
    tmpReadBlock := FReadBlock;
    if (tmpNowRead = tmpReadBlock-1) or
        ((tmpNowRead = TripBufMax) and (tmpReadBlock = 0)) then
    begin
      Result := True;
    end else
    begin
      Result := False;
    end;
end;

function TTripList.ReadNext(out Trips: TKeyRecord): Boolean;
var
  tmpNowRead: Integer;
  tmpReadBlock: Integer;
begin
    Result := False;
    tmpNowRead := FWriteBlock;
    tmpReadBlock := FReadBlock;
    if (tmpNowRead = tmpReadBlock-1) or
        ((tmpNowRead = TripBufMax) and (tmpReadBlock = 0)) then
    begin
      Exit;
    end;
    if tmpNowRead = TripBufMax then
      tmpNowRead := 0
    else
      Inc(tmpNowRead);
    Trips := FTrips[tmpNowRead];
    FWriteBlock := tmpNowRead;
    Result := True;
end;

function TTripList.WriteNext(const Trips: TKeyRecord): Boolean;
var
  tmpNowWrite: Integer;
begin
    Result := False;
    tmpNowWrite := FReadBlock;
    if tmpNowWrite = FWriteBlock then
    begin
      Exit;
    end;
    FTrips[tmpNowWrite] := Trips;
    if tmpNowWrite = TripBufMax then
      tmpNowWrite := 0
    else
      Inc(tmpNowWrite);
    FReadBlock := tmpNowWrite;
    Result := True;
end;

constructor TKeyGenerater.Create;
begin
    inherited Create(True);
    FreeOnTerminate := False;
    Priority := TThreadPriority(Form1.RadioGroupPriority.ItemIndex);
end;

function TKeyGenerater.GetNextKey: String;
type
  TFunctionNext = function(var c: Char; sType: TSearchType): Boolean;
var
  tmpVar: String;
  len: Integer;
  c: Char;
  i: integer;
  carry: Boolean;
  funcNext: TFunctionNext;
begin
    Result := FpreFixed + FvarString + FpostFixed;

    tmpVar := FvarString;
    len := length(tmpVar);
    carry := True;
    i := 1;
    if FSearchForward then
      funcNext := NextChar
    else
      funcNext := PreviousChar;

    while((i <= len) and carry) do
    begin
      c := tmpVar[i];
      carry := funcNext(c,FSearchType);
      tmpVar[i] := c;
      Inc(i);
    end;
    if carry then
    begin
      c := #0;
      funcNext(c,FSearchType);
      tmpVar := tmpVar + c;
    end;
    FvarString := tmpVar;
end;

procedure TKeyGenerater.SetPreFixed(s: String);
begin
    if Suspended then
      FpreFixed := s;
end;

procedure TKeyGenerater.SetPostFixed(s: String);
begin
    if Suspended then
      FpostFixed := s;
end;

procedure TKeyGenerater.SetVarString(s: String);
begin
    if Suspended then
      FvarString := s;
end;

procedure TKeyGenerater.SetSearchType(s: TSearchType);
begin
    if Suspended then
      FSearchType := s;
end;

procedure TKeyGenerater.SetSearchDirection(sForward: Boolean);
begin
    if Suspended then
      FSearchForward := sForward;
end;

procedure TKeyGenerater.Execute;
var
  tmpTrip: TKeyRecord;
  tTripKey: String;
  tPubKey: String;
  tSecKey: String;
  tTripStr: String;
begin
    while not Terminated do
    begin
      tTripKey := GetNextKey;
      RSAkeycreate512(tPubKey,tSecKey,tTripKey);
      tTripStr := triphash(tPubKey);
      with tmpTrip do
      begin
        TripKey := tTripKey;
        pubKey := tPubKey;
        secKey := tSecKey;
        TripStr := tTripStr;
      end;
      while (not TripList.WriteNext(tmpTrip)) and (not Terminated) do
      begin
        Sleep(1000);
      end;
    end;
end;

end.
 