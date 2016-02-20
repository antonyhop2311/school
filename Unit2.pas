unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, Vcl.Mask;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    MaskEdit1: TMaskEdit;
    procedure Button1Click(Sender: TObject);
    procedure MaskEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  LB:TListBox;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  If Length(MaskEdit1.text)>0 Then LB.Items.Add(MaskEdit1.text);
  MaskEdit1.Text:='';
  Form2.ActiveControl:=MaskEdit1;
end;

procedure TForm2.MaskEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=13 then  Button1Click(Sender);
end;

end.
