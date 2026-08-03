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

echo [Validando Pastas] Verificando se os diretórios de origem existem no G:\...
echo.

set "ERRO_PASTA=0"

:: Aqui você chama a validação para cada origem do seu script
call :VERIFICAR_PASTA "%ORIGEM1%" "PDV > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM2%" "PLUGIN > MODPDV"
call :VERIFICAR_PASTA "%ORIGEM3%" "Alexandria > Biblioteca"
call :VERIFICAR_PASTA "%ORIGEM4%" "Alexandria > Concentrador"
call :VERIFICAR_PASTA "%ORIGEM5%" "Alexandria > IntegradorPDV"
call :VERIFICAR_PASTA "%ORIGEM6%" "Alexandria > PDV Alterdata"
call :VERIFICAR_PASTA "%ORIGEM7%" "Alexandria > PreVenda"
call :VERIFICAR_PASTA "%ORIGEM8%" "Alexandria > Lays"
call :VERIFICAR_PASTA "%ORIGEM9%" "Alexandria > DanfeNFCe"
call :VERIFICAR_PASTA "%ORIGEM10%" "Rtm_Venda_Futura > VendaFutura"


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


echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM1%" "%DESTINO1%" /E /ZB /R:1 /W:2 /V ❌ /XD "DCP" "PLUGIN"
if errorlevel 8 goto ERRO

echo 📁 Copiando para MODPDV...
robocopy "%ORIGEM2%" "%DESTINO2%" /E /ZB /R:1 /W:2 /V ❌ /XD "ERP"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM3%" "%DESTINO3%" /E /ZB /R:1 /W:2 /V 
if errorlevel 8 goto ERRO

echo 📁 Copiando para Concentrador...
robocopy "%ORIGEM4%" "%DESTINO4%" /E /ZB /R:1 /W:2 /V ❌ /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "AltShop_GeradorCargaBalancaPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShopConfCegaPDV.exe" "AltShopConfigSrvPDV.exe" "AltShopProc_AbreDat.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "ConverterDatEmJson.exe" "ImpressaoDanfeNFCe.exe" "IntegradorPreVendaPDV.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "TotenMarket.exe" "WinCertCtrl.ach" ❌ /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo 📁 Copiando para ConfiguradorPDV...
robocopy "%ORIGEM5%" "%DESTINO5%" /E /ZB /R:1 /W:2 /V ❌ /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "AltShop_ConfigBasePadrao.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopProc_AbreDat.exe" "CertDataControl.ach" "ConverterDatEmJson.exe" "ExpOffLine.exe" "ImpOffLine.exe" "ImpressaoDanfeNFCe.exe" "IntegradorPreVendaPDV.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "ServidorOffLine.exe" "ServidorOffLineGuardian.exe" "ServidorOffLineSvc.exe" "TotenMarket.exe" "WinCertCtrl.ach" ❌ /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo 📁 Copiando para PDV Alterdata...
robocopy "%ORIGEM6%" "%DESTINO6%" /E /ZB /R:1 /W:2 /V ❌ /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopConfigSrvPDV.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "IntegradorPreVendaPDV.exe" "ServidorOffLineSvc.exe" "WinCertCtrl.ach" ❌ /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo 📁 Copiando para PreVenda...
robocopy "%ORIGEM7%" "%DESTINO7%" /E /ZB /R:1 /W:2 /V ❌ /XF "*.AR1" "*.AR2" "AltShop_ConfigBasePadrao.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_GeradorCargaBalancaPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopConfCegaPDV.exe" "AltShopConfigSrvPDV.exe" "AltShopProc_AbreDat.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "ConverterDatEmJson.exe" "ExpOffLine.exe" "ImpOffLine.exe" "ImpressaoDanfeNFCe.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "ServidorOffLine.exe" "ServidorOffLineGuardian.exe" "ServidorOffLineSvc.exe" "TotenMarket.exe" "WinCertCtrl.ach" ❌ /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Lays...
robocopy "%ORIGEM8%" "%DESTINO8%" /E /ZB /R:1 /W:2 /V ❌ /XD "Rtm_NFCe" "Rtm_Venda_Futura"
if errorlevel 8 goto ERRO

echo 📁 Copiando para DanfeNFCe...
robocopy "%ORIGEM9%" "%DESTINO9%" /E /ZB /R:1 /W:2 /V
if errorlevel 8 goto ERRO

echo 📁 Copiando para VendaFutura...
robocopy "%ORIGEM10%" "%DESTINO10%" /E /ZB /R:1 /W:2 /V
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