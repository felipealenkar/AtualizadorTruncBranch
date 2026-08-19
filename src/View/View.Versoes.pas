unit View.Versoes;

interface

uses
  Service.Atualizador, Dm.Imagens,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CheckLst,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;

type
  TFrmVersoes = class(TForm)
    PnlLista: TPanel;
    chklstBranches: TCheckListBox;
    PnlBotoes: TPanel;
    BtnConcluir: TButton;
    VImgLBotoes: TVirtualImageList;
    procedure chklstBranchesDblClick(Sender: TObject);
    procedure BtnConcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FAtualizadorService: TAtualizadorService;
    function ListarPastasRaiz(const PPasta, PSistema, PCompilacao: string): TStringList;
  public
    ListaVersoesSelecionadas: TStringList;

    constructor Create(PAtualizadorService: TAtualizadorService); reintroduce;
    procedure CarregarVersoes(PDiretorio, PSistema, PCompilacao: string);
  end;

implementation

uses
  System.IOUtils, System.StrUtils;
{$R *.dfm}

{ TFrmBranches }

procedure TFrmVersoes.BtnConcluirClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chklstBranches.Items.Count -1 do
  begin
    if chklstBranches.Checked[i] = True then
      ListaVersoesSelecionadas.Add(chklstBranches.Items.Strings[I]);
  end;
  ModalResult := mrOk;
end;

procedure TFrmVersoes.CarregarVersoes(PDiretorio, PSistema, PCompilacao: string);
var
  LListaPastas: TStringList;
begin
  LListaPastas := nil;
  try
    LListaPastas := ListarPastasRaiz(PDiretorio, PSistema, PCompilacao);
    chklstBranches.Items.Assign(LListaPastas);
  finally
    if Assigned(LListaPastas) then
      FreeAndNil(LListaPastas);
  end;
end;

procedure TFrmVersoes.chklstBranchesDblClick(Sender: TObject);
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

constructor TFrmVersoes.Create(PAtualizadorService: TAtualizadorService);
begin
  inherited Create(nil);
  FAtualizadorService := PAtualizadorService;
end;

procedure TFrmVersoes.FormCreate(Sender: TObject);
begin
  ListaVersoesSelecionadas := TStringList.Create;
end;

procedure TFrmVersoes.FormDestroy(Sender: TObject);
begin
  ListaVersoesSelecionadas.Free;
end;

function TFrmVersoes.ListarPastasRaiz(const PPasta, PSistema, PCompilacao: string): TStringList;
var
  Pastas: TArray<string>;
  LNomesPastas: TStringList;
  Pasta: string;
begin
  LNomesPastas := nil;
  try
    LNomesPastas := TStringList.Create;
    Pastas := TDirectory.GetDirectories(PPasta, PSistema + '*', TSearchOption.soTopDirectoryOnly);
    for Pasta in Pastas do
      LNomesPastas.Add(ExtractFileName(Pasta));

    Result := FAtualizadorService.FiltrarVersoesDisponiveis(LNomesPastas, PCompilacao);
  finally
    LNomesPastas.Free;
  end;
end;
end.
