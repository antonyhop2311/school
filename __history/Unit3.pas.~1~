unit Unit3;

interface

uses
  System.SysUtils, System.Classes, System.Variants, IdHTTP, ComObj;

  type ThreadUserInfoVK = class(TThread)
  private
    { Private declarations }
    IdHTTP1: TIdHTTP;
    procedure SaveRes;
  protected
    procedure Execute; override;
    procedure UpdateCaption;
  public
    constructor Create(CreateSuspennded: Boolean; IDTheard,token,IDpo:String; Proxy,sLUID:TStringList);
  end;

implementation

uses unit1;
var
  sUserID, sToken, strWho, sFields, sSaveType, sSaveParam: string;
  iIDTheard:integer;
  sLUIDth:TstringList;
  PageProfile: String;
  I: Integer;
  { ThreadUserInfoVK }

constructor ThreadUserInfoVK.Create(CreateSuspennded: Boolean; IDTheard,token,IDpo:String; Proxy,sLUID:TstringList);
begin
   inherited Create(CreateSuspennded);
   sLUIDth:=sLUID;
   sToken:=token;
   iIDTheard:=StrToInt(IDTheard);
   IdHTTP1:=TIdHTTP.Create();
   IdHTTP1.AllowCookies:=True;
   IdHTTP1.HandleRedirects:=true;
end;

procedure ThreadUserInfoVK.UpdateCaption;
begin
   Form1.ProgressBar1.Position:=Form1.ProgressBar1.Position+1;
end;

procedure ThreadUserInfoVK.SaveRes;
var
  fr: TextFile;
  wd, WordTable :OleVariant;
 function FindAndReplace(const FindText:string):boolean;
  const wdReplaceAll = 2;
 begin
  wd.selection.start := 0;
  wd.selection.end := 0;
  wd.Selection.Find.MatchSoundsLike := False;
  wd.Selection.Find.MatchAllWordForms := False;
  wd.Selection.Find.MatchWholeWord := False;
  wd.Selection.Find.Format := False;
  wd.Selection.Find.Forward := True;
  wd.Selection.Find.ClearFormatting;
  wd.Selection.Find.Text:=FindText;
  FindAndReplace:=wd.Selection.Find.Execute;
 end;

begin
    strWho:=sPathDocTemp+'users\all_in'+iIDTheard.ToString+'.txt';
    AssignFile(fr,strWho);
    Rewrite(fr);
        WriteLN(fr,ResultUser[iIDTheard].Text);
    CloseFile(fr);
end;

procedure ThreadUserInfoVK.Execute;
var
  data:TStringList;
  sfind, sStrFind:String;
begin
  sFields:='fields=';
  for i:=0 to Form1.CheckListBox1.count-1 do begin
     IF Form1.CheckListBox1.Checked[i]=True Then
        sFields:=sFields+Form1.CheckListBox1.Items[i].ToLower+',';
  end;
  Delete(sFields,length(sFields),1);
  if Length(sFields)<10 then sFields:='';
  i:=0;
  data:=TStringList.Create;
  ResultUser[iIDTheard]:=TStringList.Create;
  while not Terminated do begin
    if i=Form1.ProgressBar1.Max then Terminate
    else begin
     sUserID:=sLUIDth.Strings[i];
     if pos('id',sUserID)=1 then begin
         delete(sUserID,1,2);
         strWho:='user_ids='+sUserID;
     end else begin
         if (sUserID[1] in ['0'..'9'])and(sUserID[Length(sUserID)] in ['0'..'9']) Then begin
            strWho:='user_ids='+sUserID;
         end else strWho:='name_case='+sUserID;
     end;

     data.Clear;
     data.Add(strWho);
     if Length(sFields)>0 then data.Add(sFields);
     data.Add('v='+verVK);
     data.Add(sToken);
     Try
       PageProfile:=IdHTTP1.post('https://api.vk.com/method/users.get',data);
     except
       PageProfile:=strWho+': Ошибка';
     End;
     ///сохраняем если нет поля online
     if Form1.CheckBox1.Checked=False then
       ResultUser[iIDTheard].add(PageProfile)
     else begin
     //поле онлай есть проверяем есть ли в сети если да то сохраняем
       sStrFind:='online":';
       sfind:=Form1.Pars(PageProfile,sStrFind,',');
       if length(sfind)=0 then sfind:=Form1.Pars(PageProfile,sStrFind,'}');
       if sfind='1' then ResultUser[iIDTheard].add(PageProfile);
     end;
     inc(i);
     Synchronize(UpdateCaption);
    end;
  end;//for
  SaveRes;
  Form1.Button1.Caption:='Пуск';
  Form1.ProgressBar1.Position:=0;
  IdHTTP1.Free;
  form1.Memo1.Lines.Add('Поток №'+iIDTheard.ToString+' завершил работу.');
  form1.Timer1.enabled:=true;
end;

end.
