unit match;

interface

uses
  Classes, SysUtils, StrUtils, Windows;

type
  TMatchType = (mtClassicFront,mtClassicBack,mtRegular);
  TMatchFunc = function(t: String): Boolean of object;

  TMatchTester = class(TThread)
  private
    FMatchType: TMatchType;
    FOutFileName: String;
    FMatchText: String;
    FMatchTextLen: Integer;
    FMatchCount: Integer;
    FSearchCount: Integer;
    FFile: TFileStream;
    IsMatch: TMatchFunc;
    FLastTrip: String;

    procedure SetMatchType(s: TMatchType);
    procedure SetOutFileName(s: String);
    procedure SetMatchText(s: String);
    procedure TerminateTreads;

    function MatchClassicFront(t: String): Boolean;
    function MatchClassicBack(t: String): Boolean;
    function MatchRegular(t: String): Boolean;
    function MatchTrue(t: String): Boolean;

  protected
    procedure Execute; override;
  public
    property OutFileName: String read FOutFileName write SetOutFileName;
    property MatchType: TMatchType read FMatchType write SetMatchType;
    property MatchText: String read FMatchText write SetMatchText;
    property MatchCount: Integer read FMatchCount;
    property SearchCount: Integer read FSearchCount;
    property LastTrip: String read FLastTrip;
    constructor Create;
  end;

implementation

uses Unit1, keygen, BRegExp2, Dialogs;

constructor TMatchTester.Create;
begin
    inherited Create(True);
    FreeOnTerminate := False;
    
    FMatchCount := 0;
    FSearchCount := 0;
end;

procedure TMatchTester.SetOutFileName(s: String);
begin
    if Suspended then
      FOutFileName := s;
end;

procedure TMatchTester.SetMatchText(s: String);
begin
    if Suspended then
      FMatchText := s;
end;

procedure TMatchTester.SetMatchType(s: TMatchType);
begin
    if Suspended then
      FMatchType := s;
end;

function TMatchTester.MatchTrue(t: String): Boolean;
begin
    if t = '' then
    begin
      Result := False;
      Exit;
    end;
    Result := True;
end;

function TMatchTester.MatchClassicFront(t: String): Boolean;
begin
    if t = '' then
    begin
      Result := False;
      Exit;
    end;
    Result := StrLComp(PChar(t),PChar(FMatchText),FMatchTextLen) = 0;
end;

function TMatchTester.MatchClassicBack(t: String): Boolean;
var
  tmp: String;
begin
    if t = '' then
    begin
      Result := False;
      Exit;
    end;
    tmp := ReverseString(t);
    Result := StrLComp(PChar(tmp),PChar(FMatchText),FMatchTextLen) = 0;
end;

function TMatchTester.MatchRegular(t: String): Boolean;
begin
    if t = '' then
    begin
      Result := False;
      Exit;
    end;
    Result := BReg.Match(FMatchText,t);
end;

procedure TMatchTester.TerminateTreads;
begin
    Form1.EmergencyStop;
end;

procedure TMatchTester.Execute;
var
  tmpTrip: TKeyRecord;
  buf: String;
begin
    try
      if FileExists(FOutFileName) then
        FFile := TFileStream.Create(FOutFileName,fmOpenReadWrite,fmShareDenyWrite)
      else
        FFile := TFileStream.Create(FOutFileName,fmCreate,fmShareDenyWrite);
      FFile.Free;

      FMatchTextLen := length(FMatchText);
      case FMatchType of
        mtClassicFront:
          begin
            IsMatch := MatchClassicFront;
            if FMatchTextLen > 11 then
              FMatchTextLen := 11;
          end;
        mtClassicBack:
          begin
            IsMatch := MatchClassicBack;
            if FMatchTextLen > 11 then
              FMatchTextLen := 11;
          end;
        mtRegular:
          IsMatch := MatchRegular;
        else
          IsMatch := nil;
      end;

      if not Assigned(IsMatch) or (FMatchTextLen = 0) then
        IsMatch := MatchTrue;


      while not (Terminated and TripList.IsEmpty) do
      begin
        while (not TripList.ReadNext(tmpTrip)) and (not Terminated) do
        begin
          Sleep(1500);
        end;
        Inc(FSearchCount);
        if IsMatch(tmpTrip.TripStr) then
        begin
          Inc(FMatchCount);
          FLastTrip := tmpTrip.TripStr;
          buf := tmpTrip.TripStr + #13#10 +
                  #9 + 'key := ' + tmpTrip.TripKey + #13#10 +
                  #9 + 'pub := ' + tmpTrip.pubKey + #13#10 +
                  #9 + 'sec := ' + tmpTrip.secKey + #13#10;
          FFile := TFileStream.Create(FOutFileName,fmOpenReadWrite,fmShareDenyWrite);
          try
            FFile.Seek(0,soFromEnd);
            FFile.Write(buf[1],length(buf));
          finally
            FFile.Free;
          end;
        end;
      end;
    except
      on EBRegExpError do
        begin
          MessageBeep(MB_ICONEXCLAMATION);
          ShowMessage('正規表現にエラーがあります');
          Synchronize(TerminateTreads);
        end;
      on EStreamError do
        begin
          MessageBeep(MB_ICONEXCLAMATION);
          ShowMessage('ファイル入出力に失敗しました');
          Synchronize(TerminateTreads);
        end;
    else
      MessageBeep(MB_ICONEXCLAMATION);
      Synchronize(TerminateTreads);
    end;
end;

end.
