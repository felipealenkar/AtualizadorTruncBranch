@echo off
chcp 65001 > nul
title Atualização da Branch ShopSimples com Robocopy
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
    echo Uso: BranchShopSimples.bat "NomeBranch" "VersaoBranch"
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
    echo Uso: BranchShopSimples.bat "NomeBranch" "VersaoBranch"
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
    echo 2. Clique com o BOTAO DIREITO no arquivo "BranchShopSimples.bat".
    echo 3. Escolha a opcao "Executar como Administrador".
    echo.
    pause >nul
    exit /b
)

echo ========================================================================================================
echo            INICIANDO ATUALIZAÇÃO DA BRANCH SHOP SIMPLES: %NOME_BRANCH%
echo ========================================================================================================
echo.

:: CONFIGURAÇÃO DOS CAMINHOS

set "ORIGEM1=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\ACE\SE"
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

echo 🔍 Verificando se os diretórios de origem existem no G:\
echo.

:: Aqui você chama a validação para cada origem do seu script
call :VERIFICAR_PASTA "%ORIGEM1%" "ORIGEM1"
call :VERIFICAR_PASTA "%ORIGEM2%" "ORIGEM2"
call :VERIFICAR_PASTA "%ORIGEM3%" "ORIGEM3"
call :VERIFICAR_PASTA "%ORIGEM4%" "ORIGEM4"
call :VERIFICAR_PASTA "%ORIGEM5%" "ORIGEM5"
call :VERIFICAR_PASTA "%ORIGEM6%" "ORIGEM6"
call :VERIFICAR_PASTA "%ORIGEM7%" "ORIGEM7"
call :VERIFICAR_PASTA "%ORIGEM8%" "ORIGEM8"
call :VERIFICAR_PASTA "%ORIGEM9%" "ORIGEM9"
call :VERIFICAR_PASTA "%ORIGEM10%" "ORIGEM10"
call :VERIFICAR_PASTA "%ORIGEM11%" "ORIGEM11"
call :VERIFICAR_PASTA "%ORIGEM12%" "ORIGEM12"
call :VERIFICAR_PASTA "%ORIGEM13%" "ORIGEM13"
call :VERIFICAR_PASTA "%ORIGEM14%" "ORIGEM14"
call :VERIFICAR_PASTA "%ORIGEM15%" "ORIGEM15"
call :VERIFICAR_PASTA "%ORIGEM16%" "ORIGEM16"

echo.
echo ☑️ Verificação concluída!
echo.


echo ========================================================================================================
echo            INICIANDO CÓPIA DOS ARQUIVOS
echo ========================================================================================================

:: OPÇÕES DO ROBOCOPY:
:: /NJH -> Oculta o cabeçalho
:: /NJS -> Oculta a tabela do final
:: /NDL -> Não lista diretórios vazios/ignorados
:: /NP  -> Não mostra porcentagem em tempo real
:: /V   -> Mostra Tudo (Modo verboso)
:: /XF  -> Não copia esses arquivos
:: /XD  -> Não copia essas pastas
:: /XX  -> (Exclude Extra): Impede que o Robocopy liste os arquivos que só existem no destino.
:: /FFT -> Tolerância de 2 segundos na comparação de datas. Para casos em que são exibidos arquivos de rede mapeada com milissegundos de diferença.


if "%ORIGEM1_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM1%" 
	echo Destino: "%DESTINO1%"
	robocopy "%ORIGEM1%" "%DESTINO1%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM2_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM2%" 
	echo Destino: "%DESTINO2%"
	robocopy "%ORIGEM2%" "%DESTINO2%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "DCP"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM3_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM3%" 
	echo Destino: "%DESTINO3%"
	robocopy "%ORIGEM3%" "%DESTINO3%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "dcp_Alexandria"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM4_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM4%" 
	echo Destino: "%DESTINO4%"
	robocopy "%ORIGEM4%" "%DESTINO4%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "DCP"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM5_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM5%" 
	echo Destino: "%DESTINO5%"
	robocopy "%ORIGEM5%" "%DESTINO5%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM6_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM6%" 
	echo Destino: "%DESTINO6%"
	robocopy "%ORIGEM6%" "%DESTINO6%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM7_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM7%" 
	echo Destino: "%DESTINO7%"
	robocopy "%ORIGEM7%" "%DESTINO7%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM8_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM8%" 
	echo Destino: "%DESTINO8%"
	robocopy "%ORIGEM8%" "%DESTINO8%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "Rtm_Venda_Futura"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM9_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM9%" 
	echo Destino: "%DESTINO9%"
	robocopy "%ORIGEM9%" "%DESTINO9%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM10_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM10%" 
	echo Destino: "%DESTINO10%"
	robocopy "%ORIGEM10%" "%DESTINO10%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM11_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM11%" 
	echo Destino: "%DESTINO11%"
	robocopy "%ORIGEM11%" "%DESTINO11%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM12_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM12%" 
	echo Destino: "%DESTINO12%"
	robocopy "%ORIGEM12%" "%DESTINO12%" "AltConfigDBDiamond.exe" "AltModuloRegistradorShop.exe" "AltRegModGroupShop.exe" "AltShopProc_RegistraModulo.exe" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM13_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM13%" 
	echo Destino: "%DESTINO13%"
	robocopy "%ORIGEM13%" "%DESTINO13%" "AltConfigDBDiamond.exe" "AltConfigDBDiamond.cpl" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM14_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM14%" 
	echo Destino: "%DESTINO14%"
	robocopy "%ORIGEM14%" "%DESTINO14%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM15_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM15%" 
	echo Destino: "%DESTINO15%"
	robocopy "%ORIGEM15%" "%DESTINO15%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM16_OK%"=="1" (
	echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos
	echo Origem: "%ORIGEM16%" 
	echo Destino: "%DESTINO16%"
	robocopy "%ORIGEM16%" "%DESTINO16%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

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
    echo ⚠️ [IGNORADA] Pasta não encontrada  ▶️ %~1
    set "%~2_OK=0"
) else (
    echo  [OK] Pasta encontrada       📁 %~1
    set "%~2_OK=1"
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