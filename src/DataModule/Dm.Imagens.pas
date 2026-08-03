unit Dm.Imagens;

interface

uses
  System.SysUtils, System.Classes, Vcl.BaseImageCollection, Vcl.ImageCollection,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;

type
  TDmImagens = class(TDataModule)
    ImgColImagens: TImageCollection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmImagens: TDmImagens;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
