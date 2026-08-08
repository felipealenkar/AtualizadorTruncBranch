unit View.Branches;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CheckLst;

type
  TFrmBranches = class(TForm)
    PnlLista: TPanel;
    chklstBranches: TCheckListBox;
    PnlBotoes: TPanel;
    BtnConcluir: TButton;
    procedure chklstBranchesDblClick(Sender: TObject);
    procedure BtnConcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function ListarPastasRaiz(const PPasta, PSistema: string): TStringList;
  public
    ListaBranchesSelecionadas: TStringList;
    procedure CarregarListBox(PDiretorio, PSistema: string);
  end;

implementation

uses
  System.IOUtils;

{$R *.dfm}

{ TFrmBranches }

procedure TFrmBranches.BtnConcluirClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chklstBranches.Items.Count -1 do
  begin
    if chklstBranches.Checked[i] = True then
      ListaBranchesSelecionadas.Add(chklstBranches.Items.Strings[I]);
  end;
  ModalResult := mrOk;
end;

procedure TFrmBranches.CarregarListBox(PDiretorio, PSistema: string);
var
  LListaPastas: TStringList;
begin
  LListaPastas := nil;
  try
    LListaPastas := ListarPastasRaiz(PDiretorio, PSistema);
    chklstBranches.Items.Assign(LListaPastas);
  finally
    if Assigned(LListaPastas) then
      FreeAndNil(LListaPastas);
  end;
end;

procedure TFrmBranches.chklstBranchesDblClick(Sender: TObject);
var
  ClickPos: TPoint;
  Index: Integer;
begin
  ClickPos := chklstBranches.ScreenToClient(Mouse.CursorPos);
  Index := chklstBranches.ItemAtPos(ClickPos, True);
  if Index <> -1 then
  begin
    chklstBranches.ItemIndex := Index;
    chklstBranches.Checked[Index] := not chklstBranches.Checked[Index];
  end;
end;

procedure TFrmBranches.FormCreate(Sender: TObject);
begin
  ListaBranchesSelecionadas := TStringList.Create;
end;

procedure TFrmBranches.FormDestroy(Sender: TObject);
begin
  ListaBranchesSelecionadas.Free;
end;

function TFrmBranches.ListarPastasRaiz(const PPasta, PSistema: string): TStringList;
var
  Pastas: TArray<string>;
  Pasta: string;
begin
  Result := TStringList.Create;
  Pastas := TDirectory.GetDirectories(PPasta, PSistema + '*', TSearchOption.soTopDirectoryOnly);

  for Pasta in Pastas do
    Result.Add(ExtractFileName(Pasta));
end;

end.
