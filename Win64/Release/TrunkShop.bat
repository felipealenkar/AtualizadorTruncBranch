@echo off
chcp 65001 > nul
title Atualização da Trunk Shop com Robocopy
color 0A

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
    echo 2. Clique com o BOTAO DIREITO no arquivo "TrunkShop.bat".
    echo 3. Escolha a opcao "Executar como Administrador".
    echo.
    pause >nul
    exit /b
)

echo ========================================================================================================
echo            INICIANDO ATUALIZAÇÃO DA TRUNK SHOP
echo ========================================================================================================
echo.

:: CONFIGURAÇÃO DOS CAMINHOS

set "ORIGEM1=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\ACE"
set "DESTINO1=C:\Program Files (x86)\Alterdata\Shop"

set "ORIGEM2=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Alexandria\Nota_Facil\PDV"
set "DESTINO2=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM3=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Tokyo\Alterdata"
set "DESTINO3=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM4=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\BPL\Tokyo\SHOP"
set "DESTINO4=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM5=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Java"
set "DESTINO5=C:\Alterdata\ServicosWebShop\Integrador_4Middleware\Muven"

set "ORIGEM6=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Java"
set "DESTINO6=C:\Program Files (x86)\Alterdata\Shop\MinhaEmpresa"

set "ORIGEM7=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\DLL"
set "DESTINO7=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM8=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Especificos"
set "DESTINO8=C:\Program Files (x86)\Alterdata\Shop"

set "ORIGEM9=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Ferramentas"
set "DESTINO9=C:\Program Files (x86)\Alterdata\Biblioteca"

set "ORIGEM10=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Ferramentas"
set "DESTINO10=C:\Program Files (x86)\Alterdata\Modulos"

set "ORIGEM11=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Ferramentas"
set "DESTINO11=C:\Windows\SysWOW64"

set "ORIGEM12=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Geral"
set "DESTINO12=C:\Program Files (x86)\Alterdata\Shop"

set "ORIGEM13=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Shop"
set "DESTINO13=C:\Program Files (x86)\Alterdata\Shop"

set "ORIGEM14=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Suporte"
set "DESTINO14=C:\Program Files (x86)\Alterdata\Shop"

set "ORIGEM15=G:\ALTERDAT\Versoes\wshop\Hudson\trunk\Shop\Suporte"
set "DESTINO15=C:\Program Files (x86)\Alterdata\Biblioteca"

echo ==========================================================================
echo VALIDAÇÃO DAS PASTAS DE ORIGEM
echo ==========================================================================

echo 🔍 [Validando Pastas] Verificando se os diretórios de origem existem no G:\...
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

echo [OK] ☑️ Todas as pastas de origem foram validadas com sucesso!
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

echo 📁 Copiando para Shop...
robocopy "%ORIGEM1%" "%DESTINO1%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "SE"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM2%" "%DESTINO2%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "DCP"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM3%" "%DESTINO3%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "AltShopProc_IntegracaoOrcamentoPDALogicalAFV.exe" /XD "dcp_Alexandria" "dcp" "dcp_Tokyo" "dcus"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM4%" "%DESTINO4%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "dcp_Alexandria" "DCP"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Muven...
robocopy "%ORIGEM5%" "%DESTINO5%" "AltShopProc_IntegradorMuven.exe" "AltShopProc_IntegradorMuven.jar" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo 📁 Copiando para MinhaEmpresa...
robocopy "%ORIGEM6%" "%DESTINO6%" "AltShopProc_IntegradorMinhaEmpresa.exe" "AltShopProc_IntegradorMinhaEmpresa.jar" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM7%" "%DESTINO7%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "AQTime" "DCP"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM8%" "%DESTINO8%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "AltShopProc_ExportadorAccera.exe" "AltShopRelAD_PedidosGrade.exe" "AltShop_MichelinDRE.exe" "AltShop_RelatorioAD_SuplementarGradeFlex.exe" /XD "AD" "Dracena" "Enjoy" "HB" "RaquelCalcados" "ShellBrasil"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM9%" "%DESTINO9%" "AltView.exe" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo 📁 Copiando para Modulos...
robocopy "%ORIGEM10%" "%DESTINO10%" "AltConfigDBDiamond.exe" "AltModuloRegistradorShop.exe" "AltRegModGroupShop.exe" "AltShopProc_RegistraModulo.exe" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo 📁 Copiando para SysWOW64...
robocopy "%ORIGEM11%" "%DESTINO11%" "AltConfigDBDiamond.exe" "AltConfigDBDiamond.cpl" "AltView.exe" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM12%" "%DESTINO12%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "Cenarios" "NFCeINI" "Teste" "AQTime"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM13%" "%DESTINO13%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XD "AQTime" "Student"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Shop...
robocopy "%ORIGEM14%" "%DESTINO14%" /E /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT /XF "AltShopProc_AtualizaFollowUp.dll" "AltShop_ImportadorShop.exe"
if errorlevel 8 goto ERRO

echo 📁 Copiando para Biblioteca...
robocopy "%ORIGEM15%" "%DESTINO15%" "AltShopProc_AtualizaFollowUp.dll" /ZB /R:1 /W:2 /NJH /NJS /NDL /XX /FFT
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
    echo  [OK] Pasta encontrada       📁 "%~2" .
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