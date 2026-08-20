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
    BtnAlterarVersao: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnTruncarClick(Sender: TObject);
    procedure Exi(Sender: TObject);
  private
    FAtualizadorRepository: TAtualizadorRepository;
    FListaDatabases: TStringList;
    procedure ListarDatabases;
    function ValidarVersao(const AVersao: string): Boolean;
  public
    constructor Create(PAtualizadorRepository: TAtualizadorRepository); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  System.IOUtils, System.RegularExpressions, System.StrUtils;
{$R *.dfm}

{ TFrmBranches }

procedure TFrmFuncoes.Exi(Sender: TObject);
var
  LListaModulosOk, LListaOcorrencias: TStringList;
  LVersao: string;
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
                      sLineBreak + sLineBreak + LListaOcorrencias.Text), 'Alterar versão', MB_OK or MB_ICONWARNING);
      Exit;
    end;
  Finally
    if Assigned(LListaOcorrencias) then
      FreeAndNil(LListaOcorrencias);
  end;

  FAtualizadorRepository.Conectar(LbxDatabases.Items.Strings[LbxDatabases.ItemIndex]);
  LListaModulosOk := nil;

  if not InputQuery('Informar versão', 'Digite a versão desejada:', LVersao) then
    Exit;

  if not ValidarVersao(LVersao) then
  begin
    MessageBox(Self.Handle, PChar('A versão digitada é inválida, a versão deve estar de acordo com um dos seguintes padrões:' +
                      sLineBreak + sLineBreak + 'X.XXXX' +
                      sLineBreak + 'X.XXXX.X' +
                      sLineBreak + 'X.XXXX.XX' +
                      sLineBreak + 'X.XXXX.XXX'), 'Versão inválida', MB_OK or MB_ICONERROR);
    Exit;
  end;

  LVersao := StringReplace(LVersao,'.',',',[rfReplaceAll]);

  try
    LListaModulosOk := TStringList.Create;
    if ChkIshop.Checked then
    begin
      try
        FAtualizadorRepository.AlterarVersao('ishop', LVersao);
        LListaModulosOk.Add('Ishop');
      except
        on E: Exception do
          MessageBox(Self.Handle, PChar('Não foi possível alterar a versão do Ishop.' + sLineBreak + sLineBreak + E.Message), 'Alterar versão', MB_OK or MB_ICONERROR);
      end;
    end;

    if ChkWshop.Checked then
    begin
      try
        FAtualizadorRepository.AlterarVersao('wshop', LVersao);
        LListaModulosOk.Add('Wshop');
      except
        on E: Exception do
          MessageBox(Self.Handle, PChar('Não foi possível alterar a versão do Wshop.' + sLineBreak + sLineBreak + E.Message), 'Alterar versão', MB_OK or MB_ICONERROR);
      end;
    end;
  finally
    if LListaModulosOk.Count >= 1 then
      MessageBox(Self.Handle, PChar('Versões alteradas com sucesso nos seguintes sistemas:' + sLineBreak + sLineBreak +
                               LListaModulosOk.Text), 'Alterar versão', MB_OK or MB_ICONINFORMATION);
    if Assigned(LListaModulosOk) then
      FreeAndNil(LListaModulosOk);
  end;
end;

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
          MessageBox(Self.Handle, PChar('Não foi possível truncar modulo_ishop.' + sLineBreak + sLineBreak + E.Message), 'Truncar módulos', MB_OK or MB_ICONERROR);
      end;
    end;

    if ChkWshop.Checked then
    begin
      try
        FAtualizadorRepository.TruncarModulos('wshop');
        LListaModulosOk.Add('modulo_wshop');
      except
        on E: Exception do
          MessageBox(Self.Handle, PChar('Não foi possível truncar modulo_wshop.' + sLineBreak + sLineBreak + E.Message), 'Truncar módulos', MB_OK or MB_ICONERROR);
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

function TFrmFuncoes.ValidarVersao(const AVersao: string): Boolean;
const
  PADRAO_VERSAO = '^\d\.\d{4}(\.\d{1,3})?$';
begin
  Result := TRegEx.IsMatch(AVersao, PADRAO_VERSAO);
end;

end.
