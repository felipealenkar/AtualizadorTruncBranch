program AtualizadorTrunkBranch;

uses
  Vcl.Forms,
  View.Principal in 'src\View\View.Principal.pas' {FrmPrincipal},
  Dm.Imagens in 'src\DataModule\Dm.Imagens.pas' {DmImagens: TDataModule},
  View.Versoes in 'src\View\View.Versoes.pas' {FrmVersoes},
  Repository.Atualizador in 'src\Repository\Repository.Atualizador.pas',
  Service.Atualizador in 'src\Service\Service.Atualizador.pas',
  Model.Atualizador in 'src\Model\Model.Atualizador.pas',
  View.Funcoes in 'src\View\View.Funcoes.pas' {FrmFuncoes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  DmImagens := TDmImagens.Create(nil);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
  DmImagens.Free;
end.
