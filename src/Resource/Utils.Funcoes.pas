unit Utils.Funcoes;

interface

type
  TFuncoes = class
    private
    public
      class function ExtrairVersao(const PNomeVersao: string): string;
  end;

implementation

uses
  RegularExpressions,
  System.SysUtils;

{ TFuncoes }

class function TFuncoes.ExtrairVersao(const PNomeVersao: string): string;
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

end.
