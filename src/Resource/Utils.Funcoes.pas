unit Utils.Funcoes;

interface

type
  TFuncoes = class
    private
    public
      class function ExtrairVersao(const PNomeBranch: string): string;
  end;

implementation

uses
  RegularExpressions,
  System.SysUtils;

{ TFuncoes }

class function TFuncoes.ExtrairVersao(const PNomeBranch: string): string;
var
  LRegex: TRegEx;
  LMatch: TMatch;
begin
  LRegex := TRegEx.Create('^(WSHOP|PDV_ALTERDATA)_(\d[\d.,]*)(_.*)?$', [roIgnoreCase]);
  LMatch := LRegex.Match(PNomeBranch);

  if not LMatch.Success then
    raise Exception.CreateFmt('A versão "%s" está em um formato não reconhecido.' + sLineBreak +
          'Esperado prefixo "WSHOP_" ou "PDV_ALTERDATA_" seguido da versão.', [PNomeBranch]);

  Result := LMatch.Groups[2].Value;
end;

end.
