unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, REGISTRY, ShellApi,
  Vcl.Menus, Vcl.ExtDlgs, Vcl.CheckLst, Vcl.OleCtrls, SHDocVw, mshtml,
  Vcl.ComCtrls, Unit3;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel4: TPanel;
    ProgressBar1: TProgressBar;
    TrayIcon1: TTrayIcon;
    PopupMenu3: TPopupMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Memo1: TMemo;
    Timer1: TTimer;
    Panel5: TPanel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CollapseAll(CPG:TCategoryPanelGroup;CatPanel: TCategoryPanel;iJump:Integer);
    procedure Button1Click(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure N9Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure WMMinimize(var Message: TMessage); message WM_SYSCOMMAND;
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    function Pars(ForS, T_, _T: string): string;
  private
    { Private declarations }
  public
    { Public declarations }
    MyThreadUserInfoVK:ThreadUserInfoVK;
  end;
const
   verVK='5.45';

var
  Form1: TForm1;
  ResultUser:array[0..2] of TStringList;
  sToken, sRunExe, sPathDocTemp, sPathRunEXE, sNameRunExe, sIDpo, sUser, sPasw : string;
  WBi:integer;
  WebBrowser1:TWebBrowser;

implementation

{$R *.dfm}

uses Unit2;

var
    ft: TextFile;
    Proxy, sListUserID:TStringList;
    ppi:Integer;


function TForm1.Pars(ForS, T_, _T: string): string;
var
  a, b: integer;
begin
//hash:=Pars(Res,'online":',',');
  Result := '';
  if (T_ = '') or (ForS = '') or (_T = '') then Exit;
  a := Pos(T_, ForS);
  if a = 0 then Exit
  else a := a + Length(T_);
  ForS := Copy(ForS, a, Length(ForS) - a + 1);
  b := Pos(_T, ForS);
  if b > 0 then Result := Copy(ForS, 1, b - 1);
end;

procedure TForm1.CollapseAll(CPG:TCategoryPanelGroup;CatPanel: TCategoryPanel;iJump:Integer);
var
  i: integer;
  CP: TCategoryPanel;
begin
  For i:= 1 to CPG.Panels.Count Do Begin
    CP := (FindComponent('CategoryPanel' + inttostr(i+iJump)) as TCategoryPanel);
    CP.Collapsed := (not (CP = (CatPanel as TCategoryPanel)));
    CP.Height := CPG.Height-(CPG.Panels.Count*30)+25;
  End;
  CPG.Realign;
end;

procedure TForm1.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
Var
  i:Integer;
  html_tag:Variant;
  stemp, ss:String;
  Documents: IHTMLDocument2;
begin
 stemp:=WebBrowser1.OleObject.Document.body.innerHTML;
 if (Pos('��� ����������� ��� ���������� ����� ', stemp)>0)or(pos('������� ��� email',stemp)>0) then begin
    html_tag:=WebBrowser1.OleObject.Document.Forms.Item(0).Elements;
    For i:=0 To (html_tag.Length-1) Do Begin
      If (html_tag.item(i).name='email') Then html_tag.item(i).value:='79154305272';
      If (html_tag.item(i).name='pass') Then html_tag.item(i).value:='1qaz2wsx';
      If (html_tag.item(i).id='install_allow') Then html_tag.item(i).click;
      if (pos('������� ��� email',stemp)>0) then begin
        Documents := WebBrowser1.ControlInterface.Document as IHtmlDocument2;
        if (Documents <>  nil) then begin
         WebBrowser1.OleObject.document.getElementById('quick_login_button').click;
        end;
      end;//
    End;
    exit;
 end;
 if (WBi=2)and(Pos('����������� ������ � ������ ��������.', stemp)>0) then begin
   Documents := WebBrowser1.ControlInterface.Document as IHtmlDocument2;
   if (Documents <>  nil) then begin
      WebBrowser1.OleObject.document.getElementById('install_allow').click;
   end;
   exit;
 end;
 if ((Pos('access_token', URL)>0)and(pos('������ �� �������� ������ ��� ��������� ������. ����� ������� �� ������',stemp)>0)) then begin
   sToken:=copy(URL, pos('access_token=',URL)+Length('access_token='), pos('&',URL)-pos('access_token=',URL)-Length('access_token='));
   sToken:='access_token='+sToken;
     try
       WebBrowser1.Align:=alnone;
       WebBrowser1.left:=500;
     finally

     end;
     Memo1.Visible:=true;
     Memo1.Lines.Add('����������� ��������');
     ProgressBar1.Max:=100;
     ProgressBar1.Position:=0;
     try
       MyThreadUserInfoVK:=ThreadUserInfoVK.Create(false,IntToStr(ppi),sToken,Edit1.Text,Proxy,sListUserID);
       MyThreadUserInfoVK.Priority:=tpNormal;
       MyThreadUserInfoVK.FreeOnTerminate:=true;
       MyThreadUserInfoVK.Resume;
       inc(ppi);
       Memo1.Lines.Add('������� '+ppi.ToString+' �����.');
     except
     end;

 end;
 if (WBi=1)and((Pos('�����', stemp)>0)and(Pos('��� ��������', stemp)>0)) then begin
   Documents := WebBrowser1.ControlInterface.Document as IHtmlDocument2;
   if (Documents <>  nil) then begin
      WebBrowser1.OleObject.document.getElementById('logout_link').click;
      WBi:=2;
   end;
   exit;
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:Integer;
procedure PauseBrowser;
var
  iCountPause:Integer;
begin
        iCountPause:=0;
         Repeat
           iCountPause:=iCountPause+1;
         Until (WebBrowser1.ReadyState = READYSTATE_COMPLETE)or(iCountPause=55000);
end;
begin
  if Length(Edit1.Text)=0 then exit;
  if Length(Edit2.Text)=0 then exit;
  if Length(Edit3.Text)=0 then exit;
  If Button1.Caption='����' then begin
    ppi:=0;
    Button1.Caption:='����������';
    if WebBrowser1=nil then begin
      WebBrowser1:=TWebBrowser.Create(self);
      TWinControl(WebBrowser1).Name:='WebBrowser1name';
      TWinControl(WebBrowser1).Parent:=Panel4;
    end;
    WebBrowser1.Top:=1;
    WebBrowser1.Height:=(Panel4.Height-20);
    WebBrowser1.Width:=145;
   // WebBrowser1.Align:=alClient;
   // WebBrowser1.Left:=1;
       WebBrowser1.Align:=alnone;
       WebBrowser1.left:=Panel4.Width-150;
    WebBrowser1.Silent := true;
    WebBrowser1.RegisterAsBrowser:= True;
    WebBrowser1.OnDocumentComplete:=WebBrowser1DocumentComplete;
        WBi:=1;
          WebBrowser1.Navigate('vk.com');
        PauseBrowser;
          WebBrowser1.Navigate('http://oauth.vk.com/authorize?client_id='+Edit1.Text+'&scope=messages,groups&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token&v='+verVK);
  End Else Begin
    Button1.Caption:='���������';
    ProgressBar1.Position:=0;
    try
      MyThreadUserInfoVK.Terminate;
    except
    end;
  End;//else if Button1.
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   sIDpo:=Edit1.Text;
   sUser:=Edit2.Text;
   sPasw:=Edit3.Text;
   AssignFile(ft,sPathRunEXE+'setup.ini');
    Rewrite(ft);
    Writeln(ft,sIDpo);
    Writeln(ft,sUser);
    Writeln(ft,sPasw);
   CloseFile(ft);
end;

procedure CheckingReg;
var
  reg : TRegistry;
  sNameKeyReg:string;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  sNameKeyReg:='SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION';
  If (not reg.KeyExists(sNameKeyReg)) then sNameKeyReg:='SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION';
  If reg.OpenKey(sNameKeyReg,true) then begin
    If not reg.ValueExists(sNameRunExe) then begin
      reg.Access := KEY_WRITE;
      reg.WriteInteger(sNameRunExe,11000);
      ShellExecute(Form1.handle,'open',PChar(sNameRunExe),'',PChar(sPathRunEXE),SW_SHOWNORMAL);
      Application.Terminate;
    End;//if not
    reg.CloseKey;
  End;//if reg.Open
  reg.Free;
end;

procedure ExistsCreateDir(sNameDir:String);
begin
    Try
        If not DirectoryExists(sNameDir) then CreateDir(sNameDir);
    Finally
    End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 sRunExe:=PChar(Application.ExeName);
 sPathRunEXE:=ExtractFilePath(sRunExe);
 sNameRunExe:=ExtractFileName(sRunExe);
 If sPathRunEXE[length(sPathRunEXE)]<>'\' then sPathRunEXE:=sPathRunEXE+'\';
 sPathDocTemp:=sPathRunEXE+'temp\';
 ExistsCreateDir(sPathRunEXE+'temp');
 ExistsCreateDir(sPathDocTemp+'users');
 //�������� ����������� ��������
 If FileExists(sPathRunEXE+'setup.ini')=true then begin
   AssignFile(ft,sPathRunEXE+'setup.ini');
    Reset(ft);
    Readln(ft,sIDpo);
    Readln(ft,sUser);
    Readln(ft,sPasw);
   CloseFile(ft);
   Edit1.Text:= sIDpo;
   Edit2.Text:= sUser;
   Edit3.Text:= sPasw;
 End;//
 CheckingReg;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   if  WebBrowser1<>nil then begin
    WebBrowser1.Height:=(Panel4.Height-20);
    WebBrowser1.left:=Panel4.Width-150;
   end;
end;

procedure TForm1.WMMinimize(var Message: TMessage);
begin
  If Visible = true then N6.Caption:='��������'
  Else n6.Caption:='��������';
  If Message.WParam = SC_MINIMIZE then Visible:=False
  Else Inherited;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  If Visible =true then N6.Caption:='��������'
  Else N6.Caption:='��������';
  Visible := NOT Visible;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
 close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Memo1.Visible:=false;
end;

end.
