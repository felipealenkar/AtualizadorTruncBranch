; Script gerado para o instalador AtualizadorTrunkBranch
; Desenvolvido para o Inno Setup

#define MyAppName "Atualizador Trunk Branch"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Alterdata"
#define MyAppExeName "AtualizadorTrunkBranch.exe"
#define SourceDir "C:\Projects\AtualizadorTrunkBranch\Win64\Release"

; Caminho do ícone do instalador
#define InstallerIcon "C:\Projects\AtualizadorTrunkBranch\Support\Imagens\Instalar.ico"

[Setup]
; Informações básicas do aplicativo
AppId={{E1F8C934-1234-4A8B-9123-56789ABCDEF0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}

; ÍCONE DO INSTALADOR (Arquivo .exe do setup)
SetupIconFile={#InstallerIcon}

; Pasta de instalação fixa (C:\Program Files (x86)\Alterdata\AtualizadorTrunkBranch)
DefaultDirName={autopf32}\Alterdata\AtualizadorTrunkBranch
DisableDirPage=yes
UsePreviousAppDir=no

; Pasta do grupo do Menu Iniciar fixa
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes

; Onde o arquivo .exe do INSTALADOR final será gerado
OutputDir=C:\Projects\AtualizadorTrunkBranch\Support\Instaladores\Output
OutputBaseFilename=Setup_AtualizadorTrunkBranch

; Configurações adicionais
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern

; Exige privilégios de Administrador
PrivilegesRequired=admin

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; Copia todos os arquivos da pasta Release para o diretório de destino {app}
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Atalho no Menu Iniciar (Usa o ícone nativo do .exe)
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

; Atalho para Desinstalar
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

; Atalho na Área de Trabalho OBRIGATÓRIO (Usa o ícone nativo do .exe do Delphi)
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
; Opção para executar o aplicativo ao finalizar a instalação
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
procedure ExcluirAtalhoDeTodosUsuarios(const NomeAtalho: String);
var
  FindRec: TFindRec;
  sUsersDir: String;
  sDesktopPath: String;
  sAtalhoCompleto: String;
begin
  sUsersDir := ExpandConstant('{sd}\Users');

  if FindFirst(sUsersDir + '\*', FindRec) then
  begin
    try
      repeat
        if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and
           (FindRec.Name <> '.') and (FindRec.Name <> '..') then
        begin
          sDesktopPath := sUsersDir + '\' + FindRec.Name + '\Desktop';
          sAtalhoCompleto := sDesktopPath + '\' + NomeAtalho;

          if FileExists(sAtalhoCompleto) then
          begin
            DeleteFile(sAtalhoCompleto);
          end;
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  sInstallDirAntigo: String;
begin
  if CurStep = ssInstall then
  begin
    sInstallDirAntigo := ExpandConstant('{autopf32}\Alterdata\AtualizadorTruncBranch');
    if DirExists(sInstallDirAntigo) then
      DelTree(sInstallDirAntigo, True, True, True);

    // Apaga o atalho antigo de TODOS os perfis de usuário (incluindo Public)
    ExcluirAtalhoDeTodosUsuarios('Atualizador Trunc Branch.lnk');
  end;
end;