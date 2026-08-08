program AtualizadorTrunkBranch;

uses
  Vcl.Forms,
  View.Principal in 'src\View\View.Principal.pas' {FrmPrincipal},
  Dm.Imagens in 'src\DataModule\Dm.Imagens.pas' {DmImagens: TDataModule},
  View.Branches in 'src\View\View.Branches.pas' {FrmBranches},
  Utils.Funcoes in 'src\Resource\Utils.Funcoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  DmImagens := TDmImagens.Create(nil);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
  DmImagens.Free;
end.
