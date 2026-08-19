unit Service.Atualizador;

interface

uses
  System.Classes;

type
  TAtualizadorService = class
    private
    public
      procedure DefinirVersaoParaExecucao(const PGravarEmDiretoriosOriginais: Boolean;
        const PSistemaEscolhido, PCompilacaoEscolhida: string; var PNomeVersao, PNumeroVersao: string);
      function ExtrairVersao(const PNomeVersao: string): string;
      function FiltrarVersoesDisponiveis(PPastas: TStrings; PCompilacao: string): TStringList;
  end;

implementation

uses
  Model.Atualizador,
  RegularExpressions, System.StrUtils, System.SysUtils;

{ TFuncoes }

procedure TAtualizadorService.DefinirVersaoParaExecucao(const PGravarEmDiretoriosOriginais: Boolean;
  const PSistemaEscolhido, PCompilacaoEscolhida: string; var PNomeVersao, PNumeroVersao: string);
begin
  if (PCompilacaoEscolhida = COMPILACAO_TRUNK) and (PSistemaEscolhido = SISTEMA_PDV_Alterdata) and
     (PNomeVersao <> COMPILACAO_TRUNK) then
  begin
    PNomeVersao := PREFIXO_WSHOP + '_' + PNomeVersao;
  end;

  if PGravarEmDiretoriosOriginais then
    PNumeroVersao := EmptyStr
  else
  begin
    if (Trim(PNomeVersao) = EmptyStr) then
    begin
      PNumeroVersao := COMPILACAO_TRUNK;
      PNomeVersao := COMPILACAO_TRUNK;
    end
    else
    begin
      if (PSistemaEscolhido = SISTEMA_PDV_Alterdata) and (PCompilacaoEscolhida = COMPILACAO_TRUNK) and
        (PNomeVersao = COMPILACAO_TRUNK) then
        PNumeroVersao := COMPILACAO_TRUNK
      else
        PNumeroVersao := ExtrairVersao(PNomeVersao);
    end;
  end;
end;

function TAtualizadorService.ExtrairVersao(const PNomeVersao: string): string;
var
  LRegex: TRegEx;
  LMatch: TMatch;
begin
  LRegex := TRegEx.Create('^(WSHOP|PDV_ALTERDATA)_(\d[\d.,]*)(_.*)?$', [roIgnoreCase]);
  LMatch := LRegex.Match(PNomeVersao);

  if not LMatch.Success then
    raise Exception.CreateFmt('A versão "%s" está em um formato não reconhecido.' + sLineBreak +
          'Esperado prefixo "WSHOP_" ou "PDV_ALTERDATA_" seguido da versão.', [PNomeVersao]);

  Result := LMatch.Groups[2].Value;
end;

function TAtualizadorService.FiltrarVersoesDisponiveis(PPastas: TStrings; PCompilacao: string): TStringList;
var
  LPasta: string;
  LVersaoExtraida: string;
begin
  Result := TStringList.Create;
  for LPasta in PPastas do
  begin
    if PCompilacao = COMPILACAO_TRUNK then
    begin
      if StartsText(PREFIXO_WSHOP + '_', LPasta) then
      begin
        LVersaoExtraida := StringReplace(ExtrairVersao(LPasta), PREFIXO_WSHOP + '_', EmptyStr, [rfReplaceAll, rfIgnoreCase]);
        if Result.IndexOf(LVersaoExtraida) = -1 then
          Result.Add(LVersaoExtraida);
      end;
    end
    else
      Result.Add(LPasta);
  end;

  if PCompilacao = COMPILACAO_TRUNK then
  begin
    if not Result.Contains(COMPILACAO_TRUNK) then
      Result.Add(COMPILACAO_TRUNK);
  end;
end;

end.
