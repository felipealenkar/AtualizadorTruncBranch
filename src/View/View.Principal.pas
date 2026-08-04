unit View.Principal;

interface

uses
  Dm.Imagens, System.IniFiles, System.IOUtils,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, System.Types, Vcl.ImgList, Vcl.VirtualImageList;

type
  TFrmPrincipal = class(TForm)
    VImgLImagens: TVirtualImageList;
    mmoMemoLog: TMemo;
    PnlFiltros: TPanel;
    LblSistema: TLabel;
    LblBranch: TLabel;
    CbbSistema: TComboBox;
    BtnAtualizar: TButton;
    RgCompilacao: TRadioGroup;
    LbxBranches: TListBox;
    BtnAdicionarBranch: TButton;
    VImgLImagensMenores: TVirtualImageList;
    BtnRemoverBranch: TButton;
    BtnLimparBranches: TButton;
    PnlLog: TPanel;
    procedure BtnAtualizarClick(Sender: TObject);
    procedure RgCompilacaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CbbSistemaChange(Sender: TObject);
    procedure BtnAdicionarBranchClick(Sender: TObject);
    procedure BtnRemoverBranchClick(Sender: TObject);
    procedure BtnLimparBranchesClick(Sender: TObject);
  private
    FNomeArquivoBat: string;
    FBuscaBranches: string;

    procedure AdicionarLog(const PLinha: string);
    procedure CarregarBranchesFavoritas(PTipoBranch: string);
    procedure ExecutarBat(const PCaminhoBat: string; const PNomeBranch: string = ''; const PVersaoBranch: string = '');
    function ExtrairVersaoBranch(const PNomeBranch: string): string;
    procedure GravarBranchesFavoritas(PTipoBranch: string);
    procedure IniciarComponentesVisuais;
    procedure ModificarComponentes;
    procedure TravarUI(PTravado: Boolean);
    function ValidarCamposPreenchidos: Boolean;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

const
  BAT_ENCERRA_PROC: string = 'EncerraProc.bat';

  BAT_TRUNC_SHOP: string = 'TruncShop.bat';
  BAT_TRUNC_SHOP_SIMPLES: string = 'TruncShopSimples.bat';
  BAT_TRUNC_PDV: string = 'TruncPDV.bat';

  BAT_BRANCH_SHOP: string = 'BranchShop.bat';
  BAT_BRANCH_SHOP_SIMPLES: string = 'BranchShopSimples.bat';
  BAT_BRANCH_PDV: string = 'BranchPDV.bat';

  SISTEMA_ISHOP_WSHOP: string = 'Ishop/WShop';
  SISTEMA_SHOP_SIMPLES: string = 'Shop Simples';
  SISTEMA_PDV_Alterdata: string = 'PDV Alterdata';

  BRANCHES_FAVORITAS_SHOP: string = 'BRANCHES_SHOP';
  BRANCHES_FAVORITAS_PDV: string = 'BRANCHES_PDV';

  DIRETORIO_BRANCHES: string = 'G:\ALTERDAT\Versoes\wshop\Hudson\branches\';

implementation

uses
  System.RegularExpressions,
  View.Branches;

{$R *.dfm}

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  IniciarComponentesVisuais;
end;

procedure TFrmPrincipal.GravarBranchesFavoritas(PTipoBranch: string);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
  I: Integer;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'BranchesFavoritas.ini');
  LArquivoIni := nil;
  try
    LArquivoIni := TIniFile.Create(LCaminhoIni);
    LArquivoIni.EraseSection(PTipoBranch);

    for I := 0 to LbxBranches.Items.Count -1 do
      LArquivoIni.WriteString(PTipoBranch, 'Branch_' + I.ToString, LbxBranches.Items.Strings[I]);
  finally
    LArquivoIni.Free;
  end;
end;

procedure TFrmPrincipal.IniciarComponentesVisuais;
begin
  CbbSistema.Items.Add(SISTEMA_ISHOP_WSHOP);
  CbbSistema.Items.Add(SISTEMA_SHOP_SIMPLES);
  CbbSistema.Items.Add(SISTEMA_PDV_Alterdata);
  RgCompilacao.ItemIndex := 0;
  mmoMemoLog.Clear;
end;

procedure TFrmPrincipal.ModificarComponentes;
begin
  RgCompilacao.Enabled := CbbSistema.ItemIndex >= 0;

  if RgCompilacao.ItemIndex = 0 then
  begin
    LbxBranches.Enabled := False;
    BtnAdicionarBranch.Enabled := False;
    BtnRemoverBranch.Enabled := False;
    BtnLimparBranches.Enabled := False;
    LbxBranches.ItemIndex := -1;

    if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_ISHOP_WSHOP then
      FNomeArquivoBat := BAT_TRUNC_SHOP
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_SHOP_SIMPLES then
      FNomeArquivoBat := BAT_TRUNC_SHOP_SIMPLES
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_PDV_Alterdata then
      FNomeArquivoBat := BAT_TRUNC_PDV;
  end
  else if RgCompilacao.ItemIndex = 1 then
  begin
    LbxBranches.Enabled := True;
    BtnAdicionarBranch.Enabled := True;
    BtnRemoverBranch.Enabled := True;
    BtnLimparBranches.Enabled := True;

    if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_ISHOP_WSHOP then
    begin
      FNomeArquivoBat := BAT_BRANCH_SHOP;
      FBuscaBranches := 'WSHOP';
    end
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_SHOP_SIMPLES then
    begin
      FNomeArquivoBat := BAT_BRANCH_SHOP_SIMPLES;
      FBuscaBranches := 'WSHOP';
    end
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_PDV_Alterdata then
    begin
      FNomeArquivoBat := BAT_BRANCH_PDV;
      FBuscaBranches := 'PDV';
    end;
  end;
end;

procedure TFrmPrincipal.RgCompilacaoClick(Sender: TObject);
begin
  ModificarComponentes;
end;

function TFrmPrincipal.ValidarCamposPreenchidos: Boolean;
var
  LLista: TStringList;
begin
  LLista := nil;
  try
    LLista := TStringList.Create;
    if CbbSistema.ItemIndex < 0 then
      LLista.Add('- ' + LblSistema.Caption);
    if RgCompilacao.ItemIndex < 0 then
      LLista.Add('- ' + RgCompilacao.Caption);
    if RgCompilacao.ItemIndex = 1 then
    begin
      if LbxBranches.ItemIndex < 0 then
        LLista.Add('- ' + LblBranch.Caption);
    end;

    Result := LLista.Count = 0;

    if not Result then
      MessageBox(Self.Handle, PChar('Para prosseguir é necessário preencher os seguintes campos:' +
                      sLineBreak + sLineBreak + LLista.Text), 'Atualizar', MB_OK or MB_ICONWARNING);
  finally
    if Assigned(LLista) then
      FreeAndNil(LLista);
  end;
end;

procedure TFrmPrincipal.TravarUI(PTravado: Boolean);
begin
  BtnAtualizar.Enabled := not PTravado;
  CbbSistema.Enabled := not PTravado;
  RgCompilacao.Enabled := not PTravado;
  LbxBranches.Enabled := (not PTravado) and (RgCompilacao.ItemIndex = 1);
end;

procedure TFrmPrincipal.AdicionarLog(const PLinha: string);
begin
  mmoMemoLog.Lines.Add(PLinha);
  mmoMemoLog.SelStart := Length(mmoMemoLog.Text);
  mmoMemoLog.SelLength := 0;
  mmoMemoLog.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TFrmPrincipal.ExecutarBat(const PCaminhoBat: string; const PNomeBranch: string = ''; const PVersaoBranch: string = '');
const
  BUFFER_SIZE = 4096;
var
  LSaAttr: TSecurityAttributes;
  LStdOutRead, LStdOutWrite: THandle;
  LStdInNul: THandle;
  LStartupInfo: TStartupInfo;
  LProcessInfo: TProcessInformation;
  LComando: string;
  LBuffer: array[0..BUFFER_SIZE - 1] of AnsiChar;
  LBytesRead: DWORD;
  LExitCode: DWORD;
  LLinhaPendente, LTexto: UTF8String;
  LTextoRestante: string;
  LPos: Integer;
begin
  if not FileExists(PCaminhoBat) then
  begin
    MessageBox(Self.Handle, PChar('Arquivo não encontrado: ' + PCaminhoBat),
      'Atualizar', MB_OK or MB_ICONERROR);
    Exit;
  end;

  TravarUI(True);
  mmoMemoLog.Clear;
  try
    LStdOutWrite := 0;
    LStdInNul := INVALID_HANDLE_VALUE;
    LSaAttr.nLength := SizeOf(TSecurityAttributes);
    LSaAttr.bInheritHandle := True;
    LSaAttr.lpSecurityDescriptor := nil;

    if not CreatePipe(LStdOutRead, LStdOutWrite, @LSaAttr, 0) then
      raise Exception.Create('Falha ao criar pipe para captura da saída.');

    try
      SetHandleInformation(LStdOutRead, HANDLE_FLAG_INHERIT, 0);

      LStdInNul := CreateFile('NUL', GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
        @LSaAttr, OPEN_EXISTING, 0, 0);
      if LStdInNul = INVALID_HANDLE_VALUE then
        raise Exception.CreateFmt('Falha ao abrir NUL para stdin. Código do erro: %d', [GetLastError]);

      FillChar(LStartupInfo, SizeOf(LStartupInfo), 0);
      LStartupInfo.cb := SizeOf(LStartupInfo);
      LStartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      LStartupInfo.wShowWindow := SW_HIDE;
      LStartupInfo.hStdOutput := LStdOutWrite;
      LStartupInfo.hStdError := LStdOutWrite;
      LStartupInfo.hStdInput := LStdInNul;

      if PNomeBranch = EmptyStr then
        LComando := Format('cmd.exe /c "%s"', [PCaminhoBat])
      else
        LComando := Format('cmd.exe /c ""%s" "%s" "%s""', [PCaminhoBat, PNomeBranch, PVersaoBranch]);

      UniqueString(LComando);

      FillChar(LProcessInfo, SizeOf(LProcessInfo), 0);

      if not CreateProcess(nil, PChar(LComando), nil, nil, True,
        CREATE_NO_WINDOW, nil, nil, LStartupInfo, LProcessInfo) then
        raise Exception.CreateFmt('Falha ao executar o .bat. Código do erro: %d', [GetLastError]);

      CloseHandle(LStdOutWrite);
      LStdOutWrite := 0;

      LLinhaPendente := '';

     // ===== INÍCIO DA PARTE CORRIGIDA PARA PROGRESSO / PORCENTAGEM =====
      SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 0, 0);
      try
        repeat
          if not ReadFile(LStdOutRead, LBuffer, BUFFER_SIZE, LBytesRead, nil) or (LBytesRead = 0) then
            Break;

          SetString(LTexto, LBuffer, LBytesRead);
          LLinhaPendente := LLinhaPendente + LTexto;

          // Processa enquanto houver quebras de linha normais (#13#10) ou retornos de carro (#13)
          while True do
          begin
            LPos := Pos(UTF8String(#13#10), LLinhaPendente);

            if LPos = 0 then
              LPos := Pos(UTF8String(#13), LLinhaPendente); // Apenas o retorno de carro do progresso

            if LPos = 0 then
              Break;

            LTextoRestante := Trim(UTF8ToString(Copy(LLinhaPendente, 1, LPos - 1)));

            // Remove o delimitador processado da string pendente
            if (LPos + 1 <= Length(LLinhaPendente)) and (LLinhaPendente[LPos] = #13) and (LLinhaPendente[LPos+1] = #10) then
              Delete(LLinhaPendente, 1, LPos + 1)
            else
              Delete(LLinhaPendente, 1, LPos);

            if LTextoRestante <> '' then
            begin
              // Se a linha atual e a última linha do Memo contiverem '%',
              // significa que é uma barra de progresso em andamento. Substituímos em vez de criar nova linha.
              if (mmoMemoLog.Lines.Count > 0) and
                 (Pos('%', mmoMemoLog.Lines[mmoMemoLog.Lines.Count - 1]) > 0) and
                 (Pos('%', LTextoRestante) > 0) then
              begin
                mmoMemoLog.Lines[mmoMemoLog.Lines.Count - 1] := LTextoRestante;
              end
              else
              begin
                AdicionarLog(LTextoRestante);
              end;
            end;
          end;

          SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 1, 0);
          mmoMemoLog.Invalidate;
          SendMessage(mmoMemoLog.Handle, EM_SCROLLCARET, 0, 0);
          Application.ProcessMessages;
          SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 0, 0);
        until False;
      finally
        SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 1, 0);
        mmoMemoLog.Invalidate;
      end;
      // ===== FIM DA PARTE CORRIGIDA =====

      LTextoRestante := Trim(UTF8ToString(LLinhaPendente));
      if LTextoRestante <> '' then
        AdicionarLog(LTextoRestante);

      WaitForSingleObject(LProcessInfo.hProcess, INFINITE);
      GetExitCodeProcess(LProcessInfo.hProcess, LExitCode);

      CloseHandle(LProcessInfo.hProcess);
      CloseHandle(LProcessInfo.hThread);
    finally
      CloseHandle(LStdOutRead);
      if LStdOutWrite <> 0 then
        CloseHandle(LStdOutWrite);
      if LStdInNul <> INVALID_HANDLE_VALUE then
        CloseHandle(LStdInNul);
    end;
  finally
    TravarUI(False);
  end;
end;

function TFrmPrincipal.ExtrairVersaoBranch(const PNomeBranch: string): string;
var
  LRegex: TRegEx;
  LMatch: TMatch;
begin
  LRegex := TRegEx.Create('^(WSHOP|PDV_ALTERDATA)_(\d[\d.,]*)(_.*)?$', [roIgnoreCase]);
  LMatch := LRegex.Match(PNomeBranch);

  if not LMatch.Success then
    raise Exception.CreateFmt('A branch "%s" está em um formato não reconhecido.' + sLineBreak +
          'Esperado prefixo "WSHOP_" ou "PDV_ALTERDATA_" seguido da versão.', [PNomeBranch]);

  Result := LMatch.Groups[2].Value;
end;

procedure TFrmPrincipal.BtnAdicionarBranchClick(Sender: TObject);
var
  LFrmBranches: TFrmBranches;
  I: Integer;
begin
  LFrmBranches := nil;
  try
    LFrmBranches := TFrmBranches.Create(nil);
    LFrmBranches.CarregarListBox(DIRETORIO_BRANCHES, FBuscaBranches);
    LFrmBranches.ShowModal;

    for I := 0 to LFrmBranches.ListaBranchesSelecionadas.Count -1 do
    begin
      if LbxBranches.Items.IndexOf(LFrmBranches.ListaBranchesSelecionadas[I]) = -1 then
        LbxBranches.Items.Add(LFrmBranches.ListaBranchesSelecionadas[I]);
    end;

    if (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_ISHOP_WSHOP) or
       (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_SHOP_SIMPLES) then
      GravarBranchesFavoritas(BRANCHES_FAVORITAS_SHOP)
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_PDV_Alterdata then
      GravarBranchesFavoritas(BRANCHES_FAVORITAS_PDV);
  finally
    if Assigned(LFrmBranches) then
      FreeAndNil(LFrmBranches);
  end;
end;

procedure TFrmPrincipal.BtnAtualizarClick(Sender: TObject);
var
  LNomeBranch, LVersaoBranch: string;
begin
  if not ValidarCamposPreenchidos then
    Exit;

  ExecutarBat(ExtractFilePath(Application.ExeName) + BAT_ENCERRA_PROC);

  if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = 'Trunc' then
    ExecutarBat(ExtractFilePath(Application.ExeName) + FNomeArquivoBat)
  else if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = 'Branch' then
  begin
    LNomeBranch := LbxBranches.Items.Strings[LbxBranches.ItemIndex];
    try
      LVersaoBranch := ExtrairVersaoBranch(LNomeBranch);
    except
      on E: Exception do
      begin
        MessageBox(Self.Handle, PChar(E.Message), 'Atualizar', MB_OK or MB_ICONERROR);
        Exit;
      end;
    end;
    ExecutarBat(ExtractFilePath(Application.ExeName) + FNomeArquivoBat, LNomeBranch, LVersaoBranch);
  end;
end;

procedure TFrmPrincipal.BtnLimparBranchesClick(Sender: TObject);
var
  Resposta: Integer;
begin
  Resposta := MessageBox(Self.Handle, 'Deseja limpar todas as Branches?', 'Limpar Branches', MB_YESNO or MB_ICONQUESTION);

  if Resposta = IDYES then
  begin
    LbxBranches.Items.Clear;

    if (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_ISHOP_WSHOP) or
       (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_SHOP_SIMPLES) then
      GravarBranchesFavoritas(BRANCHES_FAVORITAS_SHOP)
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_PDV_Alterdata then
      GravarBranchesFavoritas(BRANCHES_FAVORITAS_PDV);
  end;
end;

procedure TFrmPrincipal.BtnRemoverBranchClick(Sender: TObject);
begin
  if LbxBranches.ItemIndex <> -1 then
  begin
    LbxBranches.Items.Delete(LbxBranches.ItemIndex);

    if (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_ISHOP_WSHOP) or
       (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_SHOP_SIMPLES) then
      GravarBranchesFavoritas(BRANCHES_FAVORITAS_SHOP)
    else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_PDV_Alterdata then
      GravarBranchesFavoritas(BRANCHES_FAVORITAS_PDV);
  end;
end;

procedure TFrmPrincipal.CarregarBranchesFavoritas(PTipoBranch: string);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
  LListaBranches: TStringList;
  I: Integer;
  LValorBranch: string;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'BranchesFavoritas.ini');

  if not TFile.Exists(LCaminhoIni) then
  begin
    Exit;
  end;

  LArquivoIni := nil;
  LListaBranches := nil;
  try
    LListaBranches := TStringList.Create;
    LArquivoIni := TIniFile.Create(LCaminhoIni);

    LbxBranches.Items.Clear;
    LArquivoIni.ReadSectionValues(PTipoBranch, LListaBranches);

    for I := 0 to LListaBranches.Count - 1 do
    begin
      // LValores.ValueFromIndex[I] pega diretamente o valor após o '='
      LValorBranch := LListaBranches.ValueFromIndex[I];

      if LValorBranch <> EmptyStr then
        LbxBranches.Items.Add(LValorBranch);
    end;
  finally
    LListaBranches.Free;
    LArquivoIni.Free;
  end;
end;

procedure TFrmPrincipal.CbbSistemaChange(Sender: TObject);
begin
  LbxBranches.Items.Clear;

  if (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_ISHOP_WSHOP) or
     (CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_SHOP_SIMPLES) then
    CarregarBranchesFavoritas(BRANCHES_FAVORITAS_SHOP)
  else if CbbSistema.Items.Strings[CbbSistema.ItemIndex] = SISTEMA_PDV_Alterdata then
    CarregarBranchesFavoritas(BRANCHES_FAVORITAS_PDV);

  ModificarComponentes;
end;

end.
