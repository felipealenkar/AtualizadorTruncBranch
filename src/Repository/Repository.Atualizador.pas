unit Repository.Atualizador;

interface

uses
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.PG, FireDAC.VCLUI.Wait,
  System.Classes;

type
  TAtualizadorRepository = class
  private
    FPgDriver: TFDPhysPgDriverLink;
    FWaitCursor: TFDGUIxWaitCursor;
    FConnection: TFDConnection;
  public
    procedure InstanciarComponetesDb;
    procedure DestruirComponentesDb;
    procedure Conectar(PNomeDatabase: string);

    function CarregarConfiguracoes(PSecao, PChave: string; PPadrao: Boolean = False): Boolean;
    procedure CarregarVersoesFavoritas(PTipoVersao: string; PListaVersoes: TStrings);
    procedure GravarConfiguracoes(PSecao, PChave: string; PValor: Boolean);
    procedure GravarVersoesFavoritas(PTipoVersao, PCompilacao: string; PListaVersoes: TStrings);
    procedure ListarDatabases(PListaDatabases: TStringList);
    procedure TruncarModulos(PSistema: string);
  end;

implementation

uses
  FireDAC.DApt, FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Stan.Option,
  Model.Atualizador,
  System.IOUtils, System.IniFiles, System.SysUtils;

procedure TAtualizadorRepository.CarregarVersoesFavoritas(PTipoVersao: string; PListaVersoes: TStrings);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
  LListaBranches: TStringList;
  I: Integer;
  LValorBranch: string;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), VERSOES_FAVORITAS_INI);

  if not TFile.Exists(LCaminhoIni) then
  begin
    Exit;
  end;

  LArquivoIni := nil;
  LListaBranches := nil;
  try
    LListaBranches := TStringList.Create;
    LArquivoIni := TIniFile.Create(LCaminhoIni);

    PListaVersoes.Clear;
    LArquivoIni.ReadSectionValues(PTipoVersao, LListaBranches);

    for I := 0 to LListaBranches.Count - 1 do
    begin
      // LValores.ValueFromIndex[I] pega diretamente o valor após o '='
      LValorBranch := LListaBranches.ValueFromIndex[I];

      if LValorBranch <> EmptyStr then
        PListaVersoes.Add(LValorBranch);
    end;
  finally
    LListaBranches.Free;
    LArquivoIni.Free;
  end;
end;

procedure TAtualizadorRepository.Conectar(PNomeDatabase: string);
begin
  FConnection.close;
  FConnection.Params.Clear;
  FConnection.DriverName := 'PG';
  FPgDriver.VendorLib  := ExtractFilePath(ParamStr(0)) + 'libpq.dll';
  FConnection.Params.Values['Server'] := 'localhost';
  FConnection.Params.Values['Port'] := '5432';
  FConnection.Params.Values['User_Name'] := 'postgres';
  FConnection.Params.Values['Password'] := '#abc123#';
  FConnection.Params.Values['Database'] := PNomeDatabase;
  FConnection.Params.Values['CharacterSet'] := 'UTF8';
  FConnection.LoginPrompt := False;
  FConnection.Params.Values['SSLMode'] := 'disable';
  FConnection.Open;
end;

procedure TAtualizadorRepository.InstanciarComponetesDb;
begin
  FPgDriver := TFDPhysPgDriverLink.Create(nil);
  FWaitCursor := TFDGUIxWaitCursor.Create(nil);
  FConnection := TFDConnection.Create(nil);
end;

procedure TAtualizadorRepository.DestruirComponentesDb;
begin
  if Assigned(FConnection) then
    FreeAndNil(FConnection);
  if Assigned(FWaitCursor) then
    FreeAndNil(FWaitCursor);
  if Assigned(FPgDriver) then
    FreeAndNil(FPgDriver);
  inherited;
end;

procedure TAtualizadorRepository.GravarConfiguracoes(PSecao, PChave: string; PValor: Boolean);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), VERSOES_FAVORITAS_INI);
  LArquivoIni := nil;
  try
    LArquivoIni := TIniFile.Create(LCaminhoIni);
    LArquivoIni.WriteBool(PSecao, PChave, PValor);
  finally
    LArquivoIni.Free;
  end;
end;

procedure TAtualizadorRepository.GravarVersoesFavoritas(PTipoVersao, PCompilacao: string; PListaVersoes: TStrings);
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
  I: Integer;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), VERSOES_FAVORITAS_INI);
  LArquivoIni := nil;
  try
    LArquivoIni := TIniFile.Create(LCaminhoIni);
    LArquivoIni.EraseSection(PTipoVersao);

    for I := 0 to PListaVersoes.Count -1 do
      LArquivoIni.WriteString(PTipoVersao, PCompilacao + '_' + I.ToString, PListaVersoes[I]);
  finally
    LArquivoIni.Free;
  end;
end;

procedure TAtualizadorRepository.ListarDatabases(PListaDatabases: TStringList);
var
  LQuery: TFDQuery;
begin
  LQuery := Nil;

  try
    LQuery := TFDQuery.Create(nil);
    LQuery.Connection := FConnection;
    LQuery.Sql.Add('SELECT d.datname');
    LQuery.Sql.Add('FROM pg_database d');
    LQuery.Sql.Add('JOIN pg_roles r ON d.datdba = r.oid');
    LQuery.Sql.Add('WHERE d.datistemplate = false');
    LQuery.Sql.Add('AND d.datname <> ''postgres''');
    LQuery.Sql.Add('ORDER BY d.datname');
    LQuery.Open;
    LQuery.First;

    while not LQuery.Eof do
    begin
      PListaDatabases.Add(LQuery.FieldByName('datname').AsString);
      LQuery.Next;
    end;
  finally
    if Assigned(LQuery) then
      FreeAndNil(LQuery);
  end;
End;

procedure TAtualizadorRepository.TruncarModulos(PSistema: string);
begin
  FConnection.ExecSQL(Format('truncate %s.modulo_%s', [PSistema, PSistema]));
end;

function TAtualizadorRepository.CarregarConfiguracoes(PSecao, PChave: string; PPadrao: Boolean = False): Boolean;
var
  LArquivoIni: TIniFile;
  LCaminhoIni: string;
begin
  LCaminhoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), VERSOES_FAVORITAS_INI);
  LArquivoIni := nil;
  try
    LArquivoIni := TIniFile.Create(LCaminhoIni);
    Result := LArquivoIni.ReadBool(PSecao, PChave, PPadrao);
  finally
    LArquivoIni.Free;
  end;
end;

end.
