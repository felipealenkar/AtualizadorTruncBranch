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
    LblBranchLib: TLabel;
    CbbSistema: TComboBox;
    BtnAtualizar: TButton;
    RgCompilacao: TRadioGroup;
    LbxVersoes: TListBox;
    BtnAdicionarVersao: TButton;
    VImgLImagensMenores: TVirtualImageList;
    BtnRemoverVersao: TButton;
    BtnLimparVersoes: TButton;
    PnlLog: TPanel;
    procedure BtnAtualizarClick(Sender: TObject);
    procedure RgCompilacaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CbbSistemaChange(Sender: TObject);
    procedure BtnAdicionarVersaoClick(Sender: TObject);
    procedure BtnRemoverVersaoClick(Sender: TObject);
    procedure BtnLimparVersoesClick(Sender: TObject);
  private
    FSistemaEscolhido: string;
    FCompilacaoEscolhida: string;
    FNomeArquivoBat: string;
    FBuscaVersoes: string;


    procedure AdicionarLog(const PLinha: string);
    procedure CarregarVersoesFavoritas(PTipoVersao: string);
    procedure ExecutarBat(const PCaminhoBat: string; const PNomeBranch: string = ''; const PVersaoBranch: string = '');
    procedure GravarVersoesFavoritas(PTipoBranch: string);
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

  BAT_TRUNK_SHOP: string = 'TrunkShop.bat';
  BAT_TRUNK_SHOP_SIMPLES: string = 'TrunkShopSimples.bat';
  BAT_TRUNK_PDV: string = 'TrunkPDV.bat';

  BAT_BRANCH_SHOP: string = 'BranchShop.bat';
  BAT_BRANCH_SHOP_SIMPLES: string = 'BranchShopSimples.bat';
  BAT_BRANCH_PDV: string = 'BranchPDV.bat';

  BRANCHES_FAVORITAS_SHOP: string = 'BRANCHES_SHOP';
  BRANCHES_FAVORITAS_PDV: string = 'BRANCHES_PDV';
  LIBS_FAVORITAS_SHOP_PDV: string = 'LIBS_PDV';

  SISTEMA_ISHOP_WSHOP: string = 'Ishop/WShop';
  SISTEMA_SHOP_SIMPLES: string = 'Shop Simples';
  SISTEMA_PDV_Alterdata: string = 'PDV Alterdata';

  PREFIXO_WSHOP: string = 'WSHOP';
  PREFIXO_PDV: string = 'PDV';

  COMPILACAO_TRUNK: string = 'Trunk';
  COMPILACAO_BRANCH: string = 'Branch';

  DIRETORIO_BRANCHES: string = 'G:\ALTERDAT\Versoes\wshop\Hudson\branches\';
  //DIRETORIO_BRANCHES: string = 'C:\Projects\AtualizadorTrunkBranch\Win64\Debug';

implementation

uses
  Utils.Funcoes,
  View.Branches;

{$R *.dfm}

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  IniciarComponentesVisuais;
end;

procedure TFrmPrincipal.GravarVersoesFavoritas(PTipoBranch: string);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
  I: Integer;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'VersoesFavoritas.ini');
  LArquivoIni := nil;
  try
    LArquivoIni := TIniFile.Create(LCaminhoIni);
    LArquivoIni.EraseSection(PTipoBranch);

    for I := 0 to LbxVersoes.Items.Count -1 do
      LArquivoIni.WriteString(PTipoBranch, COMPILACAO_BRANCH + '_' + I.ToString, LbxVersoes.Items.Strings[I]);
  finally
    LArquivoIni.Free;
  end;
end;

procedure TFrmPrincipal.IniciarComponentesVisuais;
begin
  CbbSistema.Items.Add(SISTEMA_ISHOP_WSHOP);
  CbbSistema.Items.Add(SISTEMA_SHOP_SIMPLES);
  CbbSistema.Items.Add(SISTEMA_PDV_Alterdata);
  RgCompilacao.ItemIndex := RgCompilacao.Items.IndexOf(COMPILACAO_TRUNK);
  CbbSistema.ItemIndex := CbbSistema.Items.IndexOf(SISTEMA_ISHOP_WSHOP);
  FSistemaEscolhido := CbbSistema.Items.Strings[CbbSistema.ItemIndex];
  FCompilacaoEscolhida := RgCompilacao.Items.Strings[RgCompilacao.ItemIndex];
  ModificarComponentes;
  mmoMemoLog.Clear;
end;

procedure TFrmPrincipal.ModificarComponentes;
begin
  RgCompilacao.Enabled := CbbSistema.ItemIndex >= 0;

  if RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_TRUNK) then
  begin
    if FSistemaEscolhido = SISTEMA_ISHOP_WSHOP then
    begin
      LbxVersoes.Enabled := False;
      BtnAdicionarVersao.Enabled := False;
      BtnRemoverVersao.Enabled := False;
      BtnLimparVersoes.Enabled := False;
      LblBranchLib.Enabled := False;
      LblBranchLib.Caption := EmptyStr;
      LbxVersoes.ItemIndex := -1;
      FNomeArquivoBat := BAT_TRUNK_SHOP;
      LbxVersoes.Items.Clear;
    end
    else if FSistemaEscolhido = SISTEMA_SHOP_SIMPLES then
    begin
      LbxVersoes.Enabled := False;
      BtnAdicionarVersao.Enabled := False;
      BtnRemoverVersao.Enabled := False;
      BtnLimparVersoes.Enabled := False;
      LblBranchLib.Enabled := False;
      LblBranchLib.Caption := EmptyStr;
      LbxVersoes.ItemIndex := -1;
      FNomeArquivoBat := BAT_TRUNK_SHOP_SIMPLES;
      LbxVersoes.Items.Clear;
    end
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
    begin
      LbxVersoes.Enabled := True;
      BtnAdicionarVersao.Enabled := True;
      BtnRemoverVersao.Enabled := True;
      BtnLimparVersoes.Enabled := True;
      LblBranchLib.Enabled := True;
      LblBranchLib.Caption := 'Versão da Lib Shop compatível';
      LbxVersoes.ItemIndex := -1;
      FNomeArquivoBat := BAT_TRUNK_PDV;
      FBuscaVersoes := PREFIXO_WSHOP; //Aqui é Wshop pois queremos a versão da Lib do Wshop mesmo
      CarregarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV);
    end;
  end
  else if RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_BRANCH) then
  begin
    LbxVersoes.Enabled := True;
    BtnAdicionarVersao.Enabled := True;
    BtnRemoverVersao.Enabled := True;
    BtnLimparVersoes.Enabled := True;
    LblBranchLib.Enabled := True;
    LblBranchLib.Caption := 'Versão da Branch';

    if FSistemaEscolhido = SISTEMA_ISHOP_WSHOP then
    begin
      FNomeArquivoBat := BAT_BRANCH_SHOP;
      FBuscaVersoes := PREFIXO_WSHOP;
      CarregarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP);
    end
    else if FSistemaEscolhido = SISTEMA_SHOP_SIMPLES then
    begin
      FNomeArquivoBat := BAT_BRANCH_SHOP_SIMPLES;
      FBuscaVersoes := PREFIXO_WSHOP;
      CarregarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP);
    end
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
    begin
      FNomeArquivoBat := BAT_BRANCH_PDV;
      FBuscaVersoes := PREFIXO_PDV;
      CarregarVersoesFavoritas(BRANCHES_FAVORITAS_PDV);
    end;
  end;
end;

procedure TFrmPrincipal.RgCompilacaoClick(Sender: TObject);
begin
  FCompilacaoEscolhida := RgCompilacao.Items.Strings[RgCompilacao.ItemIndex];
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
    if ((RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_TRUNK)) and
       (FSistemaEscolhido = SISTEMA_PDV_Alterdata)) or (RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_BRANCH)) then
    begin
      if LbxVersoes.ItemIndex < 0 then
        LLista.Add('- ' + LblBranchLib.Caption);
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
  CbbSistema.Enabled := not PTravado;
  RgCompilacao.Enabled := not PTravado;
  BtnAdicionarVersao.Enabled := not PTravado;
  BtnRemoverVersao.Enabled := not PTravado;
  BtnLimparVersoes.Enabled := not PTravado;

  LbxVersoes.Enabled := ((not PTravado) and (RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_BRANCH))) or
  ((not PTravado) and (RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_TRUNK)) and (FSistemaEscolhido = SISTEMA_PDV_Alterdata));

  BtnAtualizar.Enabled := not PTravado;
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

procedure TFrmPrincipal.BtnAdicionarVersaoClick(Sender: TObject);
var
  LFrmBranches: TFrmBranches;
  I: Integer;
begin
  LFrmBranches := nil;
  try
    LFrmBranches := TFrmBranches.Create(nil);
    LFrmBranches.CarregarVersoes(DIRETORIO_BRANCHES, FBuscaVersoes, FCompilacaoEscolhida);
    LFrmBranches.ShowModal;

    for I := 0 to LFrmBranches.ListaVersoesSelecionadas.Count -1 do
    begin
      if LbxVersoes.Items.IndexOf(LFrmBranches.ListaVersoesSelecionadas[I]) = -1 then
        LbxVersoes.Items.Add(LFrmBranches.ListaVersoesSelecionadas[I]);
    end;

    if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
      GravarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP)
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
    begin
      if FCompilacaoEscolhida = COMPILACAO_TRUNK then
        GravarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV)
      else if FCompilacaoEscolhida = COMPILACAO_BRANCH then
        GravarVersoesFavoritas(BRANCHES_FAVORITAS_PDV);
    end;
  finally
    if Assigned(LFrmBranches) then
      FreeAndNil(LFrmBranches);
  end;
end;

procedure TFrmPrincipal.BtnAtualizarClick(Sender: TObject);
var
  LNomeVersao, LNumeroVersao: string;
begin
  LNomeVersao := EmptyStr;
  LNumeroVersao := EmptyStr;

  if not ValidarCamposPreenchidos then
    Exit;

  if LbxVersoes.ItemIndex >= 0 then
    LNomeVersao := LbxVersoes.Items.Strings[LbxVersoes.ItemIndex];

  if (FCompilacaoEscolhida = COMPILACAO_TRUNK) and (FSistemaEscolhido = SISTEMA_PDV_Alterdata) and
     (LNomeVersao <> 'Trunk') then
  begin
    LNomeVersao := PREFIXO_WSHOP + '_' + LNomeVersao;
  end
  else if (FCompilacaoEscolhida = COMPILACAO_BRANCH) then
  begin
    try
      LNumeroVersao := TFuncoes.ExtrairVersao(LNomeVersao);
    except
      on E: Exception do
      begin
        MessageBox(Self.Handle, PChar(E.Message), 'Atualizar', MB_OK or MB_ICONERROR);
        Exit;
      end;
    end;
  end;

  ExecutarBat(ExtractFilePath(Application.ExeName) + BAT_ENCERRA_PROC);
  ExecutarBat(ExtractFilePath(Application.ExeName) + FNomeArquivoBat, LNomeVersao, LNumeroVersao);
end;

procedure TFrmPrincipal.BtnLimparVersoesClick(Sender: TObject);
var
  Resposta: Integer;
begin
  Resposta := MessageBox(Self.Handle, 'Deseja limpar todas as Branches?', 'Limpar Branches', MB_YESNO or MB_ICONQUESTION);

  if Resposta = IDYES then
  begin
    LbxVersoes.Items.Clear;

    if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or
       (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
      GravarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP)
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
      GravarVersoesFavoritas(BRANCHES_FAVORITAS_PDV);
  end;
end;

procedure TFrmPrincipal.BtnRemoverVersaoClick(Sender: TObject);
begin
  if LbxVersoes.ItemIndex <> -1 then
  begin
    LbxVersoes.Items.Delete(LbxVersoes.ItemIndex);

    if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or
       (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
      GravarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP)
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
      GravarVersoesFavoritas(BRANCHES_FAVORITAS_PDV);
  end;
end;

procedure TFrmPrincipal.CarregarVersoesFavoritas(PTipoVersao: string);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
  LListaBranches: TStringList;
  I: Integer;
  LValorBranch: string;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'VersoesFavoritas.ini');

  if not TFile.Exists(LCaminhoIni) then
  begin
    Exit;
  end;

  LArquivoIni := nil;
  LListaBranches := nil;
  try
    LListaBranches := TStringList.Create;
    LArquivoIni := TIniFile.Create(LCaminhoIni);

    LbxVersoes.Items.Clear;
    LArquivoIni.ReadSectionValues(PTipoVersao, LListaBranches);

    for I := 0 to LListaBranches.Count - 1 do
    begin
      // LValores.ValueFromIndex[I] pega diretamente o valor após o '='
      LValorBranch := LListaBranches.ValueFromIndex[I];

      if LValorBranch <> EmptyStr then
        LbxVersoes.Items.Add(LValorBranch);
    end;
  finally
    LListaBranches.Free;
    LArquivoIni.Free;
  end;
end;

procedure TFrmPrincipal.CbbSistemaChange(Sender: TObject);
begin
  LbxVersoes.Items.Clear;
  FSistemaEscolhido := CbbSistema.Items.Strings[CbbSistema.ItemIndex];

  if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
  begin
    if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = COMPILACAO_TRUNK then
      LbxVersoes.Items.Clear
    else if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = COMPILACAO_BRANCH then
      CarregarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP);
  end
  else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
  begin
    if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = COMPILACAO_TRUNK then
      CarregarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV)
    else if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = COMPILACAO_BRANCH then
      CarregarVersoesFavoritas(BRANCHES_FAVORITAS_PDV);
  end;

  ModificarComponentes;
end;

end.
