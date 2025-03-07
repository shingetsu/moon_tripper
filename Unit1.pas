unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  keygen, match, BRegExp2;

type
  TForm1 = class(TForm)
    EditOutFileName: TEdit;
    Label3: TLabel;
    EditPreFixed: TEdit;
    EditVarStr: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditPostFixed: TEdit;
    RadioGroupType: TRadioGroup;
    GroupBoxKeyGen: TGroupBox;
    GroupBoxSerch: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    EditSearchRegular: TEdit;
    Button2: TButton;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    GroupBoxOutFile: TGroupBox;
    Button4: TButton;
    RadioGroupDir: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    RadioGroupPriority: TRadioGroup;
    Label11: TLabel;
    EditSerchClassical: TEdit;
    Label12: TLabel;
    ListBox1: TListBox;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure GroupBoxSerchClick(Sender: TObject);
  private
    { Private êÈåæ }
    KeyGenerator: TKeyGenerater;
    MatchTester: TMatchTester;
    FFailinThread: Boolean;
    FStartTime: TDateTime;
    F1secStartTime: TDateTime;
    F1secsCount: Integer;
    FLastAddTrip: String;
    procedure SearchStart;
    procedure SearchStop;
    procedure AddTrip(newTrip: String);
  public
    { Public êÈåæ }
    procedure EmergencyStop;
  end;

var
  Form1: TForm1;
  TripList: TTripList;
  BReg: TBRegExp;

implementation

{$R *.dfm}

uses
  Math;

procedure TForm1.FormCreate(Sender: TObject);
begin
    SaveDialog1.InitialDir := ExtractFilePath(Application.ExeName);
    TripList := TTripList.Create;
    BReg := TBRegExp.Create;
    if BReg.IsLoaded then
    begin
      RadioButton3.Enabled := True;
      Label1.Visible := False;
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    if KeyGenerator <> nil then
    begin
      KeyGenerator.Terminate;
      KeyGenerator.WaitFor;
      KeyGenerator.Free;
    end;
    if MatchTester <> nil then
    begin
      MatchTester.Terminate;
      MatchTester.WaitFor;
      MatchTester.Free;
    end;
    TripList.Free;
    BReg.Free;
end;

procedure TForm1.AddTrip(newTrip: String);
begin
    if newTrip = '' then
      Exit;

    if FLastAddTrip = newTrip then
      Exit;

    FLastAddTrip := newTrip;
    
    if ListBox1.Count > 10 then
      ListBox1.Items.Delete(0);

    ListBox1.Items.Add(newTrip);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  mCount,sCount: Integer;
  nDay: TDateTime;
begin
    if FFailinThread then
    begin
      FFailinThread := False;
      SearchStop;
      Exit;
    end;

    mCount := 0;
    sCount := 0;
    if KeyGenerator <> nil then
      EditVarStr.Text := KeyGenerator.varString;
    if MatchTester <> nil then
    begin
      mCount := MatchTester.MatchCount;
      sCount := MatchTester.SearchCount;
    end;
    Label2.Caption := 'search: ' + IntToStr(sCount) +
                      ' / found: '  + IntToStr(mCount);
    nDay := Now;

    Label8.Caption := Format('%n',[sCount / ((nDay - FStartTime) * 60*60*24)])
                      + ' keys/sec';
    Label12.Caption := Format('%n',[(sCount - F1secsCount)/ ((nDay - F1secStartTime) * 60*60*24)])
                      + ' keys/sec';
    Label9.Caption := IntToStr(Floor(nDay - FStartTime)) + ' days ' +
                      FormatDateTime('hh:mm:ss',nDay - FStartTime);
    if mCount <> 0 then
      Label10.Caption := Format('%n',[((nDay - FStartTime) * 60*60*24) / mCount])
                        + ' sec/found';

    AddTrip(MatchTester.LastTrip);

    F1secStartTime := nDay;
    F1secsCount := sCount;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    if SaveDialog1.Execute then
    begin
      EditOutFileName.Text := SaveDialog1.FileName;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
      SearchStart;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
      SearchStop;
end;

procedure TForm1.SearchStop;
var
  i: Integer;
begin
    if KeyGenerator = nil then
      Exit;

    Label11.Visible := True;
    Application.ProcessMessages;

    KeyGenerator.Terminate;
    Timer1.Enabled := False;
    EditVarStr.Text := KeyGenerator.varString;

    MatchTester.Terminate;
    MatchTester.WaitFor;
    FreeAndNil(MatchTester);
    KeyGenerator.WaitFor;
    FreeAndNil(KeyGenerator);

    GroupBoxKeyGen.Enabled := True;
    GroupBoxSerch.Enabled := True;
    GroupBoxOutFile.Enabled := True;
    RadioGroupPriority.Enabled := True;
    with GroupBoxOutFile do
      for i := 0 to ControlCount-1 do
      begin
        Controls[i].Enabled := True;
      end;
    with GroupBoxKeyGen do
      for i := 0 to ControlCount-1 do
      begin
        Controls[i].Enabled := True;
      end;
    with GroupBoxSerch do
      for i := 0 to ControlCount-1 do
      begin
        Controls[i].Enabled := True;
      end;

    if not BReg.IsLoaded then
    begin
      RadioButton3.Enabled := False;
    end;
    GroupBoxSerchClick(nil);

    Button2.Enabled := True;
    Button3.Enabled := False;
    Label11.Visible := False;
end;

procedure TForm1.EmergencyStop;
begin
    FFailinThread := True;
end;

procedure TForm1.SearchStart;
var
  i: Integer;
begin
    if MatchTester <> nil then
      Exit;

    if RadioGroupPriority.ItemIndex > ord(tpNormal) then
    begin
      MessageBeep(MB_ICONEXCLAMATION);
      if MessageDlg('priorityÇ™çÇÇ∑Ç¨ÇÈÇ∆å≈Ç‹ÇËÇ‹Ç∑ÅB'#13#10'ã≠çsÇµÇ‹Ç∑Ç©ÅH',
                    mtWarning,[mbOK, mbAbort],0) = mrAbort then
        Exit;
    end;
    RadioGroupPriority.Enabled := False;
    MatchTester := TMatchTester.Create;
    KeyGenerator := TKeyGenerater.Create;
    GroupBoxKeyGen.Enabled := False;
    GroupBoxSerch.Enabled := False;
    GroupBoxOutFile.Enabled := False;
    with GroupBoxOutFile do
      for i := 0 to ControlCount-1 do
      begin
        Controls[i].Enabled := False;
      end;
    with GroupBoxKeyGen do
      for i := 0 to ControlCount-1 do
      begin
        Controls[i].Enabled := False;
      end;
    with GroupBoxSerch do
      for i := 0 to ControlCount-1 do
      begin
        Controls[i].Enabled := False;
      end;

    Button2.Enabled := False;
    Button3.Enabled := True;
    with KeyGenerator do
    begin
      preFixed := EditPreFixed.Text;
      postFixed := EditPostFixed.Text;
      varString := EditVarStr.Text;
      SerachType := TSearchType(RadioGroupType.ItemIndex);
      SerachForward := (RadioGroupDir.ItemIndex = 0);
    end;
    with MatchTester do
    begin
      OutFileName := EditOutFileName.Text;
      if RadioButton1.Checked then
        MatchType := mtClassicFront;
      if RadioButton2.Checked then
        MatchType := mtClassicBack;
      if RadioButton3.Checked then
        MatchType := mtRegular;

      if MatchType = mtRegular then
        MatchText := EditSearchRegular.Text
      else
        MatchText := EditSerchClassical.Text;
    end;
    MatchTester.Resume;
    KeyGenerator.Resume;
    Timer1.Enabled := True;
    FStartTime := Now;
    F1secStartTime := FStartTime;
    F1secsCount:= 0;
end;

procedure TForm1.GroupBoxSerchClick(Sender: TObject);
begin
    if RadioButton1.Checked or RadioButton2.Checked then
    begin
      EditSerchClassical.Enabled := True;
      EditSearchRegular.Enabled := False;
    end;
    if RadioButton3.Checked then
    begin
      EditSerchClassical.Enabled := False;
      EditSearchRegular.Enabled := True;
    end;
end;

end.
