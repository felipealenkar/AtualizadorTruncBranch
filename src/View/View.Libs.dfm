object FrmBranches: TFrmBranches
  Left = 0
  Top = 0
  Caption = 'Lista de Branches'
  ClientHeight = 613
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object PnlLista: TPanel
    Left = 0
    Top = 0
    Width = 482
    Height = 514
    Align = alTop
    TabOrder = 0
    object chklstBranches: TCheckListBox
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 464
      Height = 496
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      ItemHeight = 17
      TabOrder = 0
      OnDblClick = chklstBranchesDblClick
    end
  end
  object PnlBotoes: TPanel
    Left = 0
    Top = 514
    Width = 482
    Height = 99
    Align = alClient
    TabOrder = 1
    object BtnConcluir: TButton
      AlignWithMargins = True
      Left = 201
      Top = 9
      Width = 80
      Height = 80
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Concluir'
      ImageIndex = 0
      ImageName = 'Atualizar'
      ImageMargins.Left = 8
      ImageMargins.Top = 5
      TabOrder = 0
      OnClick = BtnConcluirClick
    end
  end
end
