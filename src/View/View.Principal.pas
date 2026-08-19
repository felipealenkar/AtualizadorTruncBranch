unit View.Principal;

interface

uses
  Dm.Imagens, Repository.Atualizador,
  Service.Atualizador,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, System.Types, Vcl.ImgList, Vcl.VirtualImageList;

type
  TFrmPrincipal = class(TForm)
    VImgLImagens: TVirtualImageList;
    mmoMemoLog: TMemo;
    PnlFiltros: TPanel;
    LblSistema: TLabel;
    CbbSistema: TComboBox;
    BtnAtualizar: TButton;
    RgCompilacao: TRadioGroup;
    VImgLImagensMenores: TVirtualImageList;
    PnlLog: TPanel;
    GrpVersoes: TGroupBox;
    BtnAdicionarVersao: TButton;
    BtnRemoverVersao: TButton;
    BtnLimparVersoes: TButton;
    LbxVersoes: TListBox;
    RgDiretório: TRadioGroup;
    BtnFuncoes: TButton;
    procedure BtnAtualizarClick(Sender: TObject);
    procedure RgCompilacaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CbbSistemaChange(Sender: TObject);
    procedure BtnAdicionarVersaoClick(Sender: TObject);
    procedure BtnRemoverVersaoClick(Sender: TObject);
    procedure BtnLimparVersoesClick(Sender: TObject);
    procedure RgDiretórioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnFuncoesClick(Sender: TObject);
  private
    FAtualizadorService: TAtualizadorService;
    FAtualizadorRepository: TAtualizadorRepository;

    FSistemaEscolhido: string;
    FCompilacaoEscolhida: string;
    FNomeArquivoBat: string;
    FBuscaVersoes: string;
    FGravarEmDiretoriosOriginais: Boolean;

    procedure AdicionarLog(const PLinha: string);
    procedure ExecutarBat(const PCaminhoBat: string; const PNomeBranch: string = ''; const PVersaoBranch: string = '');
    procedure IniciarComponentesVisuais;
    procedure ModificarComponentes;
    procedure TravarUI(PTravado: Boolean);
    function ValidarCamposPreenchidos: Boolean;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  Model.Atualizador,
  View.Funcoes, View.Versoes;

{$R *.dfm}

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  FAtualizadorService := TAtualizadorService.Create;
  FAtualizadorRepository := TAtualizadorRepository.Create;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAtualizadorRepository);
  FreeAndNil(FAtualizadorService);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  IniciarComponentesVisuais;
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
  FGravarEmDiretoriosOriginais := FAtualizadorRepository.CarregarConfiguracoes(CONFIGURACOES, GRAVAR_EM_DIRETORIOS_ORIGINAIS);

  case FGravarEmDiretoriosOriginais of
    True: RgDiretório.ItemIndex := 0;
    False: RgDiretório.ItemIndex := 1;
  end;
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
      GrpVersoes.Enabled := False;
      GrpVersoes.Caption := EmptyStr;
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
      GrpVersoes.Enabled := False;
      GrpVersoes.Caption := EmptyStr;
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
      GrpVersoes.Enabled := True;
      GrpVersoes.Caption := 'Versão da Lib Shop compatível';
      LbxVersoes.ItemIndex := -1;
      FNomeArquivoBat := BAT_TRUNK_PDV;
      FBuscaVersoes := PREFIXO_WSHOP; //Aqui é Wshop pois queremos a versão da Lib do Wshop mesmo
      FAtualizadorRepository.CarregarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV, LbxVersoes.Items);
    end;
  end
  else if RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_BRANCH) then
  begin
    LbxVersoes.Enabled := True;
    BtnAdicionarVersao.Enabled := True;
    BtnRemoverVersao.Enabled := True;
    BtnLimparVersoes.Enabled := True;
    GrpVersoes.Enabled := True;
    GrpVersoes.Caption := 'Versão da Branch';

    if FSistemaEscolhido = SISTEMA_ISHOP_WSHOP then
    begin
      FNomeArquivoBat := BAT_BRANCH_SHOP;
      FBuscaVersoes := PREFIXO_WSHOP;
      FAtualizadorRepository.CarregarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP, LbxVersoes.Items);
    end
    else if FSistemaEscolhido = SISTEMA_SHOP_SIMPLES then
    begin
      FNomeArquivoBat := BAT_BRANCH_SHOP_SIMPLES;
      FBuscaVersoes := PREFIXO_WSHOP;
      FAtualizadorRepository.CarregarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP, LbxVersoes.Items);
    end
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
    begin
      FNomeArquivoBat := BAT_BRANCH_PDV;
      FBuscaVersoes := PREFIXO_PDV;
      FAtualizadorRepository.CarregarVersoesFavoritas(BRANCHES_FAVORITAS_PDV, LbxVersoes.Items);
    end;
  end;
end;

procedure TFrmPrincipal.RgCompilacaoClick(Sender: TObject);
begin
  FCompilacaoEscolhida := RgCompilacao.Items.Strings[RgCompilacao.ItemIndex];
  ModificarComponentes;
end;

procedure TFrmPrincipal.RgDiretórioClick(Sender: TObject);
begin
  case RgDiretório.ItemIndex of
    0: FGravarEmDiretoriosOriginais := True;
    1: FGravarEmDiretoriosOriginais := False;
  end;
  FAtualizadorRepository.GravarConfiguracoes(CONFIGURACOES, GRAVAR_EM_DIRETORIOS_ORIGINAIS, FGravarEmDiretoriosOriginais);
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
    if RgDiretório.ItemIndex < 0 then
      LLista.Add('- ' + 'Destino dos arquivos');
    if ((RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_TRUNK)) and
       (FSistemaEscolhido = SISTEMA_PDV_Alterdata)) or (RgCompilacao.ItemIndex = RgCompilacao.Items.IndexOf(COMPILACAO_BRANCH)) then
    begin
      if LbxVersoes.ItemIndex < 0 then
        LLista.Add('- ' + GrpVersoes.Caption);
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
  RgDiretório.Enabled := not PTravado;
  BtnAtualizar.Enabled := not PTravado;
  BtnFuncoes.Enabled := not PTravado;

  if (FCompilacaoEscolhida = COMPILACAO_TRUNK) and
   ((FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES))then
  begin
    BtnAdicionarVersao.Enabled := False;
    BtnRemoverVersao.Enabled := False;
    BtnLimparVersoes.Enabled := False;
    LbxVersoes.Enabled := False;
  end
  else
  begin
    BtnAdicionarVersao.Enabled := not PTravado;;
    BtnRemoverVersao.Enabled := not PTravado;
    BtnLimparVersoes.Enabled := not PTravado;
    LbxVersoes.Enabled := not PTravado;
  end;
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
  LUltimoPercentual, LPercentualAtual: Integer;
  LMemoAlterado: Boolean;

  function ExtrairPercentual(const PTexto: string): Integer;
  var
    LTxt: string;
    LPontoPos: Integer;
  begin
    Result := -1;
    if Pos('%', PTexto) = 0 then
      Exit;
    LTxt := Trim(StringReplace(PTexto, '%', '', [rfReplaceAll]));
    LPontoPos := Pos('.', LTxt);
    if LPontoPos > 0 then
      LTxt := Copy(LTxt, 1, LPontoPos - 1);
    if not TryStrToInt(Trim(LTxt), Result) then
      Result := -1;
  end;

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
      LUltimoPercentual := -1;

     // ===== INÍCIO DA PARTE CORRIGIDA PARA PROGRESSO / PORCENTAGEM =====
      SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 0, 0);
      try
        repeat
          if not ReadFile(LStdOutRead, LBuffer, BUFFER_SIZE, LBytesRead, nil) or (LBytesRead = 0) then
            Break;

          LMemoAlterado := False;

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

            if LTextoRestante = '' then
            begin
              // Linha em branco (echo. do .bat) — sempre adiciona, sem passar pelo filtro de %
              AdicionarLog(LTextoRestante);
              LUltimoPercentual := -1;
              LMemoAlterado := True;
            end
            else
            begin
              LPercentualAtual := ExtrairPercentual(LTextoRestante);

              if (mmoMemoLog.Lines.Count > 0) and
                 (Pos('%', mmoMemoLog.Lines[mmoMemoLog.Lines.Count - 1]) > 0) and
                 (LPercentualAtual >= 0) then
              begin
                if (LUltimoPercentual < 0) or (LPercentualAtual - LUltimoPercentual >= 5) or (LPercentualAtual >= 100) then
                begin
                  mmoMemoLog.Lines[mmoMemoLog.Lines.Count - 1] := LTextoRestante;
                  LUltimoPercentual := LPercentualAtual;
                  LMemoAlterado := True;
                end;
              end
              else
              begin
                AdicionarLog(LTextoRestante);
                LUltimoPercentual := LPercentualAtual;
                LMemoAlterado := True;
              end;
            end;
          end;
          if LMemoAlterado then
          begin
            SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 1, 0);
            mmoMemoLog.Invalidate;
            SendMessage(mmoMemoLog.Handle, EM_SCROLLCARET, 0, 0);
            Application.ProcessMessages;
            SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 0, 0);
          end
          else
          begin
            Application.ProcessMessages; // mantém a UI responsiva mesmo sem redesenhar o Memo
          end;
        until False;
      finally
        SendMessage(mmoMemoLog.Handle, WM_SETREDRAW, 1, 0);
        mmoMemoLog.Invalidate;
      end;
      // ===== FIM DA PARTE CORRIGIDA =====

      LTextoRestante := Trim(UTF8ToString(LLinhaPendente));
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
  LFrmVersoes: TFrmVersoes;
  I: Integer;
begin
  LFrmVersoes := nil;
  try
    LFrmVersoes := TFrmVersoes.Create(FAtualizadorService);
    LFrmVersoes.CarregarVersoes(DIRETORIO_BRANCHES, FBuscaVersoes, FCompilacaoEscolhida);
    LFrmVersoes.ShowModal;

    for I := 0 to LFrmVersoes.ListaVersoesSelecionadas.Count -1 do
    begin
      if LbxVersoes.Items.IndexOf(LFrmVersoes.ListaVersoesSelecionadas[I]) = -1 then
        LbxVersoes.Items.Add(LFrmVersoes.ListaVersoesSelecionadas[I]);
    end;

    if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
      FAtualizadorRepository.GravarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP, COMPILACAO_BRANCH, LbxVersoes.Items)
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
    begin
      if FCompilacaoEscolhida = COMPILACAO_TRUNK then
        FAtualizadorRepository.GravarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV, COMPILACAO_BRANCH, LbxVersoes.Items)
      else if FCompilacaoEscolhida = COMPILACAO_BRANCH then
        FAtualizadorRepository.GravarVersoesFavoritas(BRANCHES_FAVORITAS_PDV, COMPILACAO_BRANCH, LbxVersoes.Items);
    end;
  finally
    if Assigned(LFrmVersoes) then
      FreeAndNil(LFrmVersoes);
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

  try
    FAtualizadorService.DefinirVersaoParaExecucao(FGravarEmDiretoriosOriginais,
              FSistemaEscolhido, FCompilacaoEscolhida, LNomeVersao, LNumeroVersao);
  except
    on E: Exception do
    begin
      MessageBox(Self.Handle, PChar(E.Message), 'Atualizar', MB_OK or MB_ICONERROR);
      Exit;
    end;
  end;

  ExecutarBat(ExtractFilePath(Application.ExeName) + BAT_ENCERRA_PROC);
  ExecutarBat(ExtractFilePath(Application.ExeName) + FNomeArquivoBat, LNomeVersao, LNumeroVersao);
end;

procedure TFrmPrincipal.BtnFuncoesClick(Sender: TObject);
var
  LFrmFuncoes: TFrmFuncoes;
begin
  LFrmFuncoes := nil;
  try
    LFrmFuncoes := TFrmFuncoes.Create(FAtualizadorRepository);
    LFrmFuncoes.ShowModal;
  finally
    FreeAndNil(LFrmFuncoes);
  end;
end;

procedure TFrmPrincipal.BtnLimparVersoesClick(Sender: TObject);
var
  Resposta: Integer;
begin
  Resposta := MessageBox(Self.Handle, 'Deseja limpar todas as versões?', 'Limpar versões', MB_YESNO or MB_ICONQUESTION);

  if Resposta = IDYES then
  begin
    LbxVersoes.Items.Clear;

    if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or
       (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
      FAtualizadorRepository.GravarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP, COMPILACAO_BRANCH, LbxVersoes.Items)
    else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
    begin
      if FCompilacaoEscolhida = COMPILACAO_TRUNK then
        FAtualizadorRepository.GravarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV, COMPILACAO_BRANCH, LbxVersoes.Items)
      else if FCompilacaoEscolhida = COMPILACAO_BRANCH then
        FAtualizadorRepository.GravarVersoesFavoritas(BRANCHES_FAVORITAS_PDV, COMPILACAO_BRANCH, LbxVersoes.Items);
    end;
  end;
end;

procedure TFrmPrincipal.BtnRemoverVersaoClick(Sender: TObject);
begin
  if LbxVersoes.ItemIndex <> -1 then
  begin
    LbxVersoes.Items.Delete(LbxVersoes.ItemIndex);

    if (FSistemaEscolhido = SISTEMA_ISHOP_WSHOP) or
       (FSistemaEscolhido = SISTEMA_SHOP_SIMPLES) then
      FAtualizadorRepository.GravarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP, COMPILACAO_BRANCH, LbxVersoes.Items)
    else if (FSistemaEscolhido = SISTEMA_PDV_Alterdata) then
    begin
      if FCompilacaoEscolhida = COMPILACAO_TRUNK then
        FAtualizadorRepository.GravarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV, COMPILACAO_BRANCH, LbxVersoes.Items)
      else if FCompilacaoEscolhida = COMPILACAO_BRANCH then
        FAtualizadorRepository.GravarVersoesFavoritas(BRANCHES_FAVORITAS_PDV, COMPILACAO_BRANCH, LbxVersoes.Items);
    end;
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
      FAtualizadorRepository.CarregarVersoesFavoritas(BRANCHES_FAVORITAS_SHOP, LbxVersoes.Items);
  end
  else if FSistemaEscolhido = SISTEMA_PDV_Alterdata then
  begin
    if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = COMPILACAO_TRUNK then
      FAtualizadorRepository.CarregarVersoesFavoritas(LIBS_FAVORITAS_SHOP_PDV, LbxVersoes.Items)
    else if RgCompilacao.Items.Strings[RgCompilacao.ItemIndex] = COMPILACAO_BRANCH then
      FAtualizadorRepository.CarregarVersoesFavoritas(BRANCHES_FAVORITAS_PDV, LbxVersoes.Items);
  end;

  ModificarComponentes;
end;

end.
