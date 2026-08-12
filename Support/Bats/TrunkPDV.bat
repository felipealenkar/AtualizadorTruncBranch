@echo off
chcp 65001 > nul
title Atualização da Trunk PDV com Robocopy
color 0A

:: -------------------------------------------------------------------------
:: VALIDAÇÃO DO PARÂMETRO DA LIB SHOP
:: -------------------------------------------------------------------------
if "%~1"=="" (
    color 0C
    echo ====================================================================================================
    echo ❌ ERRO: NOME DA LIB SHOP NAO FOI INFORMADO!
    echo ====================================================================================================
    echo.
    echo Uso: TrunkPDV.bat "NomeLib"
    echo.
    pause >nul
    exit /b 1
)
set "NOME_LIB=%~1"

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
    echo 2. Clique com o BOTAO DIREITO no arquivo "TrunkPDV.bat".
    echo 3. Escolha a opcao "Executar como Administrador".
    echo.
    pause >nul
    exit /b
)

echo ========================================================================================================
echo             INICIANDO ATUALIZAÇÃO DA TRUNK PDV
echo ========================================================================================================
echo.

:: CONFIGURAÇÃO DOS CAMINHOS

set "ORIGEM1=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\ACE"
set "DESTINO1=C:\Program Files (x86)\Alterdata\Concentrador"

set "ORIGEM2=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\ACE"
set "DESTINO2=C:\Program Files (x86)\Alterdata\PDV Alterdata"

set "ORIGEM3=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Alexandria\PDV"
set "DESTINO3=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM4=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Alexandria\PDV\PLUGIN"
set "DESTINO4=C:\Program Files (x86)\Alterdata\PDV Alterdata\MODPDV"

set "ORIGEM5=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\DLL"
set "DESTINO5=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM6=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\DLL\tokyo"
set "DESTINO6=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM7=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\DLL\Alexandria"
set "DESTINO7=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM8=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Especificos\Exe"
set "DESTINO8=C:\Program Files (x86)\Alterdata\PDV Alterdata"

set "ORIGEM9=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Exe\Alexandria"
set "DESTINO9=C:\Program Files (x86)\Alterdata\Concentrador"

set "ORIGEM10=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Exe\Alexandria"
set "DESTINO10=C:\Program Files (x86)\Alterdata\Concentrador\Exe\IntegradorPDV"

set "ORIGEM11=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Exe\Alexandria"
set "DESTINO11=C:\Program Files (x86)\Alterdata\PDV Alterdata"

set "ORIGEM12=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Exe\Alexandria"
set "DESTINO12=C:\Program Files (x86)\Alterdata\PreVenda"

set "ORIGEM13=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Lays\Alexandria"
set "DESTINO13=C:\Program Files (x86)\Alterdata\PDV Alterdata\Lays"

set "ORIGEM14=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Lays\Alexandria\Rtm_NFCe"
set "DESTINO14=C:\Program Files (x86)\Alterdata\PDV Alterdata\Lays\DanfeNFCe"

set "ORIGEM15=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\PdvAlterdata\Lays\Alexandria\Rtm_Venda_Futura"
set "DESTINO15=C:\Program Files (x86)\Alterdata\PDV Alterdata\Lays\VendaFutura"

:: -------------------------------------------------------------------------
:: CAMINHOS CONDICIONAIS - (dependem do parâmetro da branch)
:: -------------------------------------------------------------------------

if /I "%NOME_LIB%"=="Trunk" (
    set "ORIGEM_OP1=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Tokyo\Alterdata"
    set "DESTINO_OP1=C:\Program Files (x86)\Alterdata\Biblioteca"

    set "ORIGEM_OP2=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Tokyo\SHOP"
    set "DESTINO_OP2=C:\Program Files (x86)\Alterdata\Biblioteca"
) else (
    set "ORIGEM_OP1=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_LIB%\BPL\Tokyo\Alterdata"
    set "ORIGEM_OP1_FULL=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_LIB%_FULL\BPL\Tokyo\Alterdata"
    set "DESTINO_OP1=C:\Program Files (x86)\Alterdata\Biblioteca"

	set "ORIGEM_OP2=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_LIB%\BPL\Tokyo\Shop"
    set "ORIGEM_OP2_FULL=G:\ALTERDAT\Versoes\wshop\Hudson\branches\%NOME_LIB%_FULL\BPL\Tokyo\Shop"
    set "DESTINO_OP2=C:\Program Files (x86)\Alterdata\Biblioteca"
)

echo ==========================================================================
echo VALIDAÇÃO DAS PASTAS DE ORIGEM
echo ==========================================================================

echo 🔍 Verificando se os diretórios de origem existem no G:\
echo.

set "ERRO_PASTA=0"

:: Aqui você chama a validação para cada origem do seu script
call :VERIFICAR_PASTA "%ORIGEM1%" "%ORIGEM1%"
call :VERIFICAR_PASTA "%ORIGEM2%" "%ORIGEM2%"
call :VERIFICAR_PASTA "%ORIGEM3%" "%ORIGEM3%"
call :VERIFICAR_PASTA "%ORIGEM4%" "%ORIGEM4%"
call :VERIFICAR_PASTA "%ORIGEM5%" "%ORIGEM5%"
call :VERIFICAR_PASTA "%ORIGEM6%" "%ORIGEM6%"
call :VERIFICAR_PASTA "%ORIGEM7%" "%ORIGEM7%"
call :VERIFICAR_PASTA "%ORIGEM8%" "%ORIGEM8%"
call :VERIFICAR_PASTA "%ORIGEM9%" "%ORIGEM9%"
call :VERIFICAR_PASTA "%ORIGEM10%" "%ORIGEM10%"
call :VERIFICAR_PASTA "%ORIGEM11%" "%ORIGEM11%"
call :VERIFICAR_PASTA "%ORIGEM12%" "%ORIGEM12%"
call :VERIFICAR_PASTA "%ORIGEM13%" "%ORIGEM13%"
call :VERIFICAR_PASTA "%ORIGEM14%" "%ORIGEM14%"
call :VERIFICAR_PASTA "%ORIGEM15%" "%ORIGEM15%"

call :VERIFICAR_PASTA_OPCIONAL "%ORIGEM_OP1%" "ORIGEM_OP1"
call :VERIFICAR_PASTA_OPCIONAL "%ORIGEM_OP2%" "ORIGEM_OP2"
if defined ORIGEM_OP1_FULL call :VERIFICAR_PASTA_OPCIONAL "%ORIGEM_OP1_FULL%" "ORIGEM_OP1_FULL"
if defined ORIGEM_OP2_FULL call :VERIFICAR_PASTA_OPCIONAL "%ORIGEM_OP2_FULL%" "ORIGEM_OP2_FULL"

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

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM1%" 
echo Destino: "%DESTINO1%"
robocopy "%ORIGEM1%" "%DESTINO1%" "ISHOP_Ribbon.ACE" "WSHOP_Ribbon.ACE" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM2%" 
echo Destino: "%DESTINO2%"
robocopy "%ORIGEM2%" "%DESTINO2%" "ISHOP_Ribbon.ACE" "WSHOP_Ribbon.ACE" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM3%" 
echo Destino: "%DESTINO3%"
robocopy "%ORIGEM3%" "%DESTINO3%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "DCP" "PLUGIN" 
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM4%" 
echo Destino: "%DESTINO4%"
robocopy "%ORIGEM4%" "%DESTINO4%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "ERP" 
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM5%" 
echo Destino: "%DESTINO5%"
robocopy "%ORIGEM5%" "%DESTINO5%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "AltMarketCliente_900.dll" "AltMarketProduto_900.dll" "AltMarketValidacaoBase_900.dll" "ImpressaoOrcOffline_900.dll" /XD "tokyo" "Alexandria"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM6%" 
echo Destino: "%DESTINO6%"
robocopy "%ORIGEM6%" "%DESTINO6%" /E /ZB /R:1 /NJH /NJS /NDL /XX /FFT /W:2 /XF "AltLibTefCertificadas_900.dll" "AltMarketProduto_900.dll"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM7%" 
echo Destino: "%DESTINO7%"
robocopy "%ORIGEM7%" "%DESTINO7%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM8%" 
echo Destino: "%DESTINO8%"
robocopy "%ORIGEM8%" "%DESTINO8%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /FFT /XX /XF "AltShop_GeradorDeArquivos.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShopProc_AbreDat.exe" "assinatura.txt"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM9%" 
echo Destino: "%DESTINO9%"
robocopy "%ORIGEM9%" "%DESTINO9%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "AltShop_GeradorCargaBalancaPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShopConfCegaPDV.exe" "AltShopConfigSrvPDV.exe" "AltShopProc_AbreDat.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "ConverterDatEmJson.exe" "ImpressaoDanfeNFCe.exe" "IntegradorPreVendaPDV.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "TotenMarket.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM10%" 
echo Destino: "%DESTINO10%"
robocopy "%ORIGEM10%" "%DESTINO10%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "AltShop_ConfigBasePadrao.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopProc_AbreDat.exe" "CertDataControl.ach" "ConverterDatEmJson.exe" "ExpOffLine.exe" "ImpOffLine.exe" "ImpressaoDanfeNFCe.exe" "IntegradorPreVendaPDV.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "ServidorOffLine.exe" "ServidorOffLineGuardian.exe" "ServidorOffLineSvc.exe" "TotenMarket.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM11%" 
echo Destino: "%DESTINO11%"
robocopy "%ORIGEM11%" "%DESTINO11%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_AgenteTerminalPreVenda.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopConfigSrvPDV.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "IntegradorPreVendaPDV.exe" "ServidorOffLineSvc.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM12%" 
echo Destino: "%DESTINO12%"
robocopy "%ORIGEM12%" "%DESTINO12%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "*.AR1" "*.AR2" "AltShop_ConfigBasePadrao.exe" "Altshop_ConfigServidorOffLineCloud.exe" "AltShop_ConfiguradorSchemaPluginPDV.exe" "AltShop_GeradorCargaBalancaPDV.exe" "AltShop_GeradorDeArquivos.exe" "AltShop_GerenciadorNotas.exe" "AltShop_ImpressaoEtiquetasOffLine.exe" "AltShop_InutilizacaoFaixaNFCe.exe" "AltShop_ServidorOFFLineCloud.exe" "AltShopConfCegaPDV.exe" "AltShopConfigSrvPDV.exe" "AltShopProc_AbreDat.exe" "AltShopServicePDV.exe" "CertDataControl.ach" "ConcentradorGuardian.exe" "ConverterDatEmJson.exe" "ExpOffLine.exe" "ImpOffLine.exe" "ImpressaoDanfeNFCe.exe" "LiberaECF.exe" "PDVAlterdata.exe" "PinPadFinder.exe" "RecuperadorSQLite.exe" "ServidorOffLine.exe" "ServidorOffLineGuardian.exe" "ServidorOffLineSvc.exe" "TotenMarket.exe" "WinCertCtrl.ach" /XD "Nota_Facil"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM13%" 
echo Destino: "%DESTINO13%"
robocopy "%ORIGEM13%" "%DESTINO13%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "Nota_Facil" "Rtm_NFCe" "Rtm_Venda_Futura" "Spice"
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM14%" 
echo Destino: "%DESTINO14%"
robocopy "%ORIGEM14%" "%DESTINO14%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo ----------------------------------------------------------------------------------------------------
echo 📁 Copiando arquivos
echo Origem: "%ORIGEM15%" 
echo Destino: "%DESTINO15%"
robocopy "%ORIGEM15%" "%DESTINO15%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo ========================================================================================================
echo            CÓPIA DOS ARQUIVOS DA LIB SHOP COMPATÍVEL
echo ========================================================================================================

if /I "%NOME_LIB%"=="Trunk" (
	if "%ORIGEM_OP1_OK%"=="1" (
		echo ----------------------------------------------------------------------------------------------------
		echo 📁 Copiando arquivos
		echo Origem: "%ORIGEM_OP1%" 
		echo Destino: "%DESTINO_OP1%"
		robocopy "%ORIGEM_OP1%" "%DESTINO_OP1%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "AltShopProc_IntegracaoOrcamentoPDALogicalAFV.exe" /XD "dcp_Alexandria" "dcp" "dcp_Tokyo" "dcus"
		if errorlevel 8 goto ERRO
	)

	if "%ORIGEM_OP2_OK%"=="1" (
		echo ----------------------------------------------------------------------------------------------------
		echo 📁 Copiando arquivos
		echo Origem: "%ORIGEM_OP2%" 
		echo Destino: "%DESTINO_OP2%"
		robocopy "%ORIGEM_OP2%" "%DESTINO_OP2%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "dcp_Alexandria" "DCP"
		if errorlevel 8 goto ERRO
	)
) else (
	call :COPIAR_PURO_FULL "%ORIGEM_OP1%" "%ORIGEM_OP1_FULL%" "%DESTINO_OP1%"
	if errorlevel 8 goto ERRO

	call :COPIAR_PURO_FULL "%ORIGEM_OP2%" "%ORIGEM_OP2_FULL%" "%DESTINO_OP2%"
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
    echo ❌ ERRO: Pasta não encontrada ❌         ▶️ "%~1"
    set "ERRO_PASTA=1"
) else (
    echo  [OK] Pasta encontrada       📁 %~2 .
)
goto :eof

:VERIFICAR_PASTA_OPCIONAL
if not exist "%~1" (
    echo ⚠️ [IGNORADA] Pasta não encontrada       ▶️ %~1
    set "%~2_OK=0"
) else (
    echo  [OK] Pasta encontrada       📁 %~1
    set "%~2_OK=1"
)
goto :eof

:COPIAR_PURO_FULL
:: %1=origem BRANCH (correção, prioridade)  %2=origem FULL  %3=destino
setlocal enabledelayedexpansion
set "P_OP=%~1"
set "P_FULL=%~2"
set "P_DESTINO=%~3"
set "XFLIST="

if exist "%P_OP%" (
    echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos LibShop
    echo Origem: "%P_OP%"
    echo Destino: "%P_DESTINO%"
    robocopy "%P_OP%" "%P_DESTINO%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "AltShopProc_IntegracaoOrcamentoPDALogicalAFV.exe" /XD "dcp_Alexandria" "dcp" "dcp_Tokyo" "DCP" "dcus"
    if errorlevel 8 (
        endlocal
        exit /b 8
    )

    for /R "%P_OP%" %%F in (*) do (
        set "XFLIST=!XFLIST! "%%~nxF""
    )
) else (
    echo ⚠️ [IGNORADA] Pasta BRANCH não encontrada    ▶️ "%P_OP%"
)

if exist "%P_FULL%" (
    echo ----------------------------------------------------------------------------------------------------
	echo 📁 Copiando arquivos LibShop Full
    echo Origem: "%P_FULL%"
    echo Destino: "%P_DESTINO%"
    robocopy "%P_FULL%" "%P_DESTINO%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "dcp_Alexandria" "dcp" "dcp_Tokyo" "DCP" "dcus" /XF "AltShopProc_IntegracaoOrcamentoPDALogicalAFV.exe" !XFLIST!
    if errorlevel 8 (
        endlocal
        exit /b 8
    )
) else (
    echo ⚠️ [IGNORADA] Pasta FULL não encontrada    ▶️ "%P_FULL%"
)

endlocal
exit /b 0
::FUNÇÕES DECLARADAS - FIM

:FIM

:SUCESSO
echo.
echo ========================================================================================================
echo 🎉 PROCESSO FINALIZADO!
echo ========================================================================================================
echo.
pause >nul