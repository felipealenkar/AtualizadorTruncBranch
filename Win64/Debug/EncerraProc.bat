@echo off
:: Altera a codificação do prompt para aceitar acentos
chcp 65001 > nul

:: -------------------------------------------------------------------------
:: VALIDAÇÃO DE PRIVILÉGIOS ADMINISTRATIVOS
:: -------------------------------------------------------------------------
NET SESSION >nul 2>&1
if %errorLevel% == 0 (
    goto :Admin
) else (
    goto :UACPrompt
)

:UACPrompt
    echo Solicitando privilégios de Administrador...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:Admin
    echo Executando com privilégios de Administrador!
    echo.
    goto :EncerrarProcessos

:: -------------------------------------------------------------------------
:: ENCERRAMENTO DOS PROCESSOS
:: -------------------------------------------------------------------------
:EncerrarProcessos
echo =====================================================================
echo            INICIANDO ENCERRAMENTO DOS PROCESSOS ABERTOS
echo =====================================================================
echo.

set "CONTADOR=0"

:: LISTA DE PROCESSOS: Mantenha um por linha para facilitar a manutenção
for %%P in (
    AlterdataManager.exe
    AltShopConfigSrvPDV.exe
    AltShopProc_AlinhamentoTransacaoPendenteIShop.exe
    AltShopProc_AlinhamentoTransacaoPendenteWShop.exe
    AltShopProc_AuditorEventos.exe
    AltShopProc_CadastroProdutos.exe
    altshopproc_financeiro.exe
    Altshop_EnvioCupomFiscal.exe
    AltShop_GerenciadorNotas.exe
    AltShop_GerenteEletronico.exe
    AltShop_ImportadorShop.exe
    AltShop_IntegradorSpice.exe
    AltShopServicePDV.exe
    ConcentradorGuardian.exe
    IntegradorSpiceGuardian.exe
    Ishop.exe
    Mofo.exe
    MonitorIntegracao.exe
    PDVAlterdata.exe
    ServidorOffLine.exe
    ServidorOffLineGuardian.exe
    shel.exe
    Spice.exe
    updaterguardian.exe
    wcash.exe
    Wshop.exe
    worc_2005.exe
	notepad.exe
) do (
    tasklist /FI "IMAGENAME eq %%P" 2>NUL | find /I "%%P" >NUL
    if not errorlevel 1 (
        taskkill /F /IM "%%P" >nul 2>&1
        echo [ENCERRADO] %%P
        set /a CONTADOR+=1
    )
)

echo.
echo =====================================================================
if %CONTADOR% gtr 0 (
    echo 🎉 Processo finalizado! Total de processos encerrados: %CONTADOR%
) else (
    echo ℹ️ Nenhum processo estava aberto. O ambiente já estava limpo!
)
echo =====================================================================
echo.
pause >nul