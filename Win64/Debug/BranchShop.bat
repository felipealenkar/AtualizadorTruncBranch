@echo off
chcp 65001 > nul
title Atualização da Branch Shop com Robocopy
color 0A

:: -------------------------------------------------------------------------
:: VALIDAÇÃO DO PARÂMETRO DA BRANCH
:: -------------------------------------------------------------------------
if "%~1"=="" (
    color 0C
    echo ====================================================================================================
    echo ❌ ERRO: NOME DA BRANCH NAO FOI INFORMADO!
    echo ====================================================================================================
    echo.
    echo Uso: BranchShop.bat "NomeBranch" "VersaoBranch"
    echo.
    pause >nul
    exit /b 1
)

if "%~2"=="" (
    color 0C
    echo ====================================================================================================
    echo ❌ ERRO: VERSAO DA BRANCH NAO FOI INFORMADA!
    echo ====================================================================================================
    echo.
    echo Uso: BranchShop.bat "NomeBranch" "VersaoBranch"
    echo.
    pause >nul
    exit /b 1
)
set "NOME_BRANCH=%~1"
set "VERSAO_BRANCH=%~2"

:: -------------------------------------------------------------------------
:: VERIFICAÇÃO RIGOROSA DE ADMINISTRADOR
:: -------------------------------------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ====================================================================================================
    echo ❌ ERRO: ESTE SCRIPT PRECISA SER EXECUTADO COMO ADMINISTRADOR!
    echo ====================================================================================================
    echo.
    echo Como a sua empresa possui bloqueios de rede, siga estes passos:
    echo.
    echo 1. Feche esta janela preta.
    echo 2. Clique com o BOTAO DIREITO no arquivo "BranchShop.bat".
    echo 3. Escolha a opcao "Executar como Administrador".
    echo.
    pause >nul
    exit /b
)

echo ========================================================================================================
echo            INICIANDO ATUALIZAÇÃO DA BRANCH SHOP: %NOME_BRANCH%
echo ========================================================================================================
echo.

:: CONFIGURAÇÃO DOS CAMINHOS

set "ORIGEM1=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\ACE"
set "DESTINO1=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%"

set "ORIGEM2=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\BPL\Alexandria\Nota_Facil\PDV"
set "DESTINO2=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM3=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\BPL\Tokyo\Alterdata"
set "DESTINO3=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM4=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\BPL\Tokyo\Shop"
set "DESTINO4=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM5=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Java"
set "DESTINO5=C:\Alterdata\ServicosWebShop\Integrador4Middleware %VERSAO_BRANCH%\Muven"

set "ORIGEM6=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\DLL\Alexandria\Nota_Facil"
set "DESTINO6=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM7=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Exe\Alexandria\Nota_Facil"
set "DESTINO7=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%"

set "ORIGEM8=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Lays\Alexandria\Nota_Facil"
set "DESTINO8=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%\Lays"

set "ORIGEM9=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Lays\Alexandria\Spice\Rtm_NFCe"
set "DESTINO9=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%\Lays\DanfeNFCe"

set "ORIGEM10=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Dll"
set "DESTINO10=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM11=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Especificos"
set "DESTINO11=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%"

set "ORIGEM12=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Ferramentas"
set "DESTINO12=C:\Program Files (x86)\Alterdata\Modulos %VERSAO_BRANCH%"

set "ORIGEM13=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Ferramentas"
set "DESTINO13=C:\Windows\SysWOW64"

set "ORIGEM14=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Geral"
set "DESTINO14=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%"

set "ORIGEM15=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Shop"
set "DESTINO15=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%"

set "ORIGEM16=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\Shop\Suporte"
set "DESTINO16=C:\Program Files (x86)\Alterdata\Shop %VERSAO_BRANCH%"

:: -------------------------------------------------------------------------
:: VALIDAÇÃO DAS PASTAS DE ORIGEM
:: -------------------------------------------------------------------------

echo [Validando Pastas] Verificando se os diretórios de origem existem no G:\...
echo.

set "ERRO_PASTA=0"

:: Aqui você chama a validação para cada origem do seu script
call :VERIFICAR_PASTA "%ORIGEM1%" "ACE > Shop"
call :VERIFICAR_PASTA "%ORIGEM2%" "PDV > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM3%" "Alterdata > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM4%" "Shop > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM5%" "Java > Muven"
call :VERIFICAR_PASTA "%ORIGEM6%" "Nota_Facil > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM7%" "Nota_Facil > Shop"
call :VERIFICAR_PASTA "%ORIGEM8%" "Nota_Facil > Lays"
call :VERIFICAR_PASTA "%ORIGEM9%" "Rtm_NFCe > DanfeNFCe"
call :VERIFICAR_PASTA "%ORIGEM10%" "Dll > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM11%" "Especificos > Shop"
call :VERIFICAR_PASTA "%ORIGEM12%" "Ferramentas > Modulos"
call :VERIFICAR_PASTA "%ORIGEM13%" "Ferramentas > SysWOW64"
call :VERIFICAR_PASTA "%ORIGEM14%" "Geral > Shop"
call :VERIFICAR_PASTA "%ORIGEM15%" "Shop > Shop"
call :VERIFICAR_PASTA "%ORIGEM16%" "Suporte > Shop"
:: Adicione as outras origens aqui se houver (%ORIGEM5%, %ORIGEM6%, etc.)

:: Se houve algum erro em qualquer pasta, para o script aqui
if "%ERRO_PASTA%"=="1" (
    echo ====================================================================================================
    echo ❌ A ATUALIZAÇÃO FOI INTERROMPIDA!
    echo Verifique se os arquivos estão em outra unidade de disco
    echo ou se o nome da pasta está ligeiramente diferente.
    echo ====================================================================================================
    pause
    exit /b 1
)

echo [OK] Todas as pastas de origem foram validadas com sucesso!
echo.


echo ========================================================================================================
echo            INICIANDO CÓPIA DOS ARQUIVOS
echo ========================================================================================================

echo 📁 Copiando para Shop...
robocopy "%ORIGEM1%" "%DESTINO1%" /E /ZB /R:1 /W:2 /V ❌ /XD "SE"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM2%" "%DESTINO2%" /E /ZB /R:1 /W:2 /V ❌ /XD "DCP"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM3%" "%DESTINO3%" /E /ZB /R:1 /W:2 /V ❌ /XD "dcp_Alexandria"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM4%" "%DESTINO4%" /E /ZB /R:1 /W:2 /V ❌ /XD "DCP"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Muven...
robocopy "%ORIGEM5%" "%DESTINO5%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM6%" "%DESTINO6%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM7%" "%DESTINO7%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Lays...
robocopy "%ORIGEM8%" "%DESTINO8%" /E /ZB /R:1 /W:2 /V ❌ /XD "Rtm_Venda_Futura"
if errorlevel 8 goto ERRO

echo 📁 Copiando para DanfeNFCe...
robocopy "%ORIGEM9%" "%DESTINO9%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM10%" "%DESTINO10%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM11%" "%DESTINO11%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Modulos...
robocopy "%ORIGEM12%" "%DESTINO12%" "AltConfigDBDiamond.exe" "AltModuloRegistradorShop.exe" "AltRegModGroupShop.exe" "AltShopProc_RegistraModulo.exe" /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para SysWOW64...
robocopy "%ORIGEM13%" "%DESTINO13%" "AltConfigDBDiamond.exe" "AltConfigDBDiamond.cpl" /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM14%" "%DESTINO14%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM15%" "%DESTINO15%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM16%" "%DESTINO16%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

:: Se chegou aqui, deu tudo certo!
goto SUCESSO



::FUNÇÕES DECLARADAS - INÍCIO
:ERRO
echo.
echo ❌ ERRO CRITICO: Falha na copia de arquivos! O processo foi interrompido.
pause
exit /b 1


:VERIFICAR_PASTA
if not exist "%~1" (
    echo ❌ ERRO: Pasta não encontrada ❌         ▶️ "%~1"
    set "ERRO_PASTA=1"
) else (
    echo  [OK] Pasta [%~2] encontrada.
)
goto :eof
::FUNÇÕES DECLARADAS - FIM

:FIM

:SUCESSO
echo.
echo ========================================================================================================
echo 🎉 PROCESSO FINALIZADO!
echo ========================================================================================================
echo.
pause >nul