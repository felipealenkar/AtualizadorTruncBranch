@echo off
chcp 65001 > nul
title Atualização da Branch PDV com Robocopy - Felipe
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
    echo Uso: BranchPDV.bat "NomeBranch" "VersaoBranch"
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
    echo Uso: BranchPDV.bat "NomeBranch" "VersaoBranch"
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
    echo 2. Clique com o BOTAO DIREITO no arquivo "BranchPDV.bat".
    echo 3. Escolha a opcao "Executar como Administrador".
    echo.
    pause >nul
    exit /b
)

echo ========================================================================================================
echo            INICIANDO ATUALIZAÇÃO DA BRANCH PDV: %NOME_BRANCH%
echo ========================================================================================================
echo.

:: CONFIGURAÇÃO DOS CAMINHOS

set "ORIGEM1=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\BPL\Alexandria\PDV"
set "DESTINO1=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM2=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\BPL\Alexandria\PDV\PLUGIN"
set "DESTINO2=C:\Program Files (x86)\Alterdata\PDV Alterdata %VERSAO_BRANCH%\MODPDV"

set "ORIGEM3=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\DLL\Alexandria"
set "DESTINO3=C:\Program Files (x86)\Alterdata\Biblioteca %VERSAO_BRANCH%"

set "ORIGEM4=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Exe\Alexandria"
set "DESTINO4=C:\Program Files (x86)\Alterdata\Concentrador %VERSAO_BRANCH%"

set "ORIGEM5=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Exe\Alexandria"
set "DESTINO5=C:\Program Files (x86)\Alterdata\Concentrador %VERSAO_BRANCH%\Exe\IntegradorPDV"

set "ORIGEM6=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Exe\Alexandria"
set "DESTINO6=C:\Program Files (x86)\Alterdata\PDV Alterdata %VERSAO_BRANCH%"

set "ORIGEM7=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Exe\Alexandria"
set "DESTINO7=C:\Program Files (x86)\Alterdata\PreVenda %VERSAO_BRANCH%"

set "ORIGEM8=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Lays\Alexandria"
set "DESTINO8=C:\Program Files (x86)\Alterdata\PDV Alterdata %VERSAO_BRANCH%\Lays"

set "ORIGEM9=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Lays\Alexandria\Rtm_NFCe"
set "DESTINO9=C:\Program Files (x86)\Alterdata\PDV Alterdata %VERSAO_BRANCH%\Lays\DanfeNFCe"

set "ORIGEM10=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_BRANCH%\PdvAlterdata\Lays\Alexandria\Rtm_Venda_Futura"
set "DESTINO10=C:\Program Files (x86)\Alterdata\PDV Alterdata %VERSAO_BRANCH%\Lays\VendaFutura"


echo ==========================================================================
echo VALIDAÇÃO DAS PASTAS DE ORIGEM
echo ==========================================================================

echo 🔍 [Validando Pastas] Verificando se os diretórios de origem existem no G:\...
echo.

set "ERRO_PASTA=0"

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

echo [OK] ☑️ Validação concluída! Processando cópias...
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
	echo 📁 Copiando para Biblioteca...
	robocopy "%ORIGEM1%" "%DESTINO1%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "DCP" "PLUGIN"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM2_OK%"=="1" (
	echo 📁 Copiando para MODPDV...
	robocopy "%ORIGEM2%" "%DESTINO2%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "ERP"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM3_OK%"=="1" (
	echo 📁 Copiando para Biblioteca...
	robocopy "%ORIGEM3%" "%DESTINO3%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM4_OK%"=="1" (
	echo 📁 Copiando para Concentrador...
	robocopy "%ORIGEM4%" "%DESTINO4%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "AltShop_GeradorCargaBalancaPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShopConfCegaPDV.exe" "AltShopConfigSrvPDV.exe" "AltShopProc_AbreDat.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "ConverterDatEmJson.exe" "ImpressaoDanfeNFCe.exe" "IntegradorPreVendaPDV.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "TotenMarket.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM5_OK%"=="1" (
	echo 📁 Copiando para ConfiguradorPDV...
	robocopy "%ORIGEM5%" "%DESTINO5%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "AltShop_ConfigBasePadrao.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopProc_AbreDat.exe" "CertDataControl.ach" "ConverterDatEmJson.exe" "ExpOffLine.exe" "ImpOffLine.exe" "ImpressaoDanfeNFCe.exe" "IntegradorPreVendaPDV.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "ServidorOffLine.exe" "ServidorOffLineGuardian.exe" "ServidorOffLineSvc.exe" "TotenMarket.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM6_OK%"=="1" (
	echo 📁 Copiando para PDV Alterdata...
	robocopy "%ORIGEM6%" "%DESTINO6%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopConfigSrvPDV.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "IntegradorPreVendaPDV.exe" "ServidorOffLineSvc.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM7_OK%"=="1" (
	echo 📁 Copiando para PreVenda...
	robocopy "%ORIGEM7%" "%DESTINO7%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_ConfigBasePadrao.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_GeradorCargaBalancaPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopConfCegaPDV.exe" "AltShopConfigSrvPDV.exe" "AltShopProc_AbreDat.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "ConverterDatEmJson.exe" "ExpOffLine.exe" "ImpOffLine.exe" "ImpressaoDanfeNFCe.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "ServidorOffLine.exe" "ServidorOffLineGuardian.exe" "ServidorOffLineSvc.exe" "TotenMarket.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM8_OK%"=="1" (
	echo 📁 Copiando para Lays...
	robocopy "%ORIGEM8%" "%DESTINO8%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "Rtm_NFCe" "Rtm_Venda_Futura"
	if errorlevel 8 goto ERRO
)

if "%ORIGEM9_OK%"=="1" (
	echo 📁 Copiando para DanfeNFCe...
	robocopy "%ORIGEM9%" "%DESTINO9%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
	if errorlevel 8 goto ERRO
)

if "%ORIGEM10_OK%"=="1" (
	echo 📁 Copiando para VendaFutura...
	robocopy "%ORIGEM10%" "%DESTINO10%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
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