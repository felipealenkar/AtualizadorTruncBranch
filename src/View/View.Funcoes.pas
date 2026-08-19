unit View.Funcoes;

interface

uses
  Repository.Atualizador, Dm.Imagens, FireDac.Comp.Client,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CheckLst,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.VirtualImage;

type
  TFrmFuncoes = class(TForm)
    PnlLista: TPanel;
    VImgLBotoes: TVirtualImageList;
    LblInstrucao: TLabel;
    GrpSistema: TGroupBox;
    ChkIshop: TCheckBox;
    ChkWshop: TCheckBox;
    BtnTruncar: TButton;
    LbxDatabases: TListBox;
    VimgDb: TVirtualImage;
    procedure FormShow(Sender: TObject);
    procedure BtnTruncarClick(Sender: TObject);
  private
    FAtualizadorRepository: TAtualizadorRepository;
    FListaDatabases: TStringList;
    procedure ListarDatabases;
  public
    constructor Create(PAtualizadorRepository: TAtualizadorRepository); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  System.IOUtils, System.StrUtils;
{$R *.dfm}

{ TFrmBranches }

procedure TFrmFuncoes.BtnTruncarClick(Sender: TObject);
var
  LListaModulosOk, LListaOcorrencias: TStringList;
begin
  LListaOcorrencias := nil;
  try
    LListaOcorrencias := TStringList.Create;
    if (not ChkIshop.Checked) and (not ChkWshop.Checked) then
      LListaOcorrencias.Add('- ' + GrpSistema.Caption);
      
    if LbxDatabases.ItemIndex <= -1 then
      LListaOcorrencias.Add('- ' + LblInstrucao.Caption);

    if LListaOcorrencias.Count >= 1 then
    begin
      MessageBox(Self.Handle, PChar('Para prosseguir é necessário preencher os seguintes campos:' +
                      sLineBreak + sLineBreak + LListaOcorrencias.Text), 'Truncar módulos', MB_OK or MB_ICONWARNING);
      Exit;
    end;
  Finally
    if Assigned(LListaOcorrencias) then
      FreeAndNil(LListaOcorrencias);
  end;

  FAtualizadorRepository.Conectar(LbxDatabases.Items.Strings[LbxDatabases.ItemIndex]);
  LListaModulosOk := nil;
  
  try
    LListaModulosOk := TStringList.Create;
    if ChkIshop.Checked then
    begin
      try
        FAtualizadorRepository.TruncarModulos('ishop');
        LListaModulosOk.Add('modulo_ishop');
      except
        on E: Exception do
          MessageBox(Self.Handle, PChar('Não é possível truncar modulo_ishop.' + sLineBreak + sLineBreak + E.Message), 'Truncar módulos', MB_OK or MB_ICONERROR);   
      end;
    end;

    if ChkWshop.Checked then
    begin
      try
        FAtualizadorRepository.TruncarModulos('wshop');
        LListaModulosOk.Add('modulo_wshop');
      except
        on E: Exception do
          MessageBox(Self.Handle, PChar('Não é possível truncar modulo_wshop.' + sLineBreak + sLineBreak + E.Message), 'Truncar módulos', MB_OK or MB_ICONERROR);   
      end;
    end;
  finally
    if LListaModulosOk.Count >= 1 then
      MessageBox(Self.Handle, PChar('Os seguintes módulos foram truncados com sucesso:' + sLineBreak + sLineBreak +
                               LListaModulosOk.Text), 'Truncar módulos', MB_OK or MB_ICONINFORMATION);
    if Assigned(LListaModulosOk) then
      FreeAndNil(LListaModulosOk);
  end;
  
 
end;

constructor TFrmFuncoes.Create(PAtualizadorRepository: TAtualizadorRepository);
begin
  inherited Create(nil);
  FAtualizadorRepository := PAtualizadorRepository;
  FAtualizadorRepository.InstanciarComponetesDb;
  FListaDatabases := TStringList.Create;
  FAtualizadorRepository.Conectar('postgres');
end;

destructor TFrmFuncoes.Destroy;
begin
  FreeAndNil(FListaDatabases);
  inherited;
end;

procedure TFrmFuncoes.FormShow(Sender: TObject);
begin
  ListarDatabases;
end;

procedure TFrmFuncoes.ListarDatabases;
begin
  FAtualizadorRepository.ListarDatabases(FListaDatabases);
  LbxDatabases.Items := FListaDatabases;
end;

end.
