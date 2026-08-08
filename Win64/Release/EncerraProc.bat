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
echo Iniciando encerramento dos processos...
echo -------------------------------------------------------------------------

:: LISTA DE PROCESSOS: Adicione ou remova os .exe aqui dentro dos parênteses, separados por ESPAÇO.
for %%P in (
    AdminEmissaoOtimizada.exe
    AltShopConfCegaPDV.exe
    AltShop_ConfigBasePadrao.exe
    AltShopConfigSrvPDV.exe
    AltShopProc_AlinhamentoTransacaoPendenteIShop.exe
    AltShopProc_AlinhamentoTransacaoPendenteWShop.exe
    AltShopProc_AtualizarDocNFeWshop.exe
    AltShopProc_AuditorEventos.exe
    AltShopProc_CadastroProdutos.exe
    altshopproc_financeiro.exe
    altshopproc_movestoqueotimizado.exe
    AltShop_AgenteTerminalPreVenda.exe
    AltShop_GerenciadorNotas.exe
    AltShop_GerenteEletronico.exe
    AltShop_ImpressaoEtiquetasOffLine.exe
    AltShop_IntegradorSpice.exe
    AltShopServicePDV.exe
    AltShop_SpiceDelivery.exe
    AltShopProcExtratorXML.exe
    ConcentradorGuardian.exe
    ExpOffLine.exe
    IAdminEmissaoOtimizada.exe
    IAgendaAdmin.exe
    ImpOffLine.exe	
    IntegradorPreVendaPDV.exe
    IntegradorSpiceGuardian.exe
    IOrcAdmin.exe
    Ishop.exe
    LiberaECF.exe
    Mofo.exe
    MonitorIntegracao.exe
    OrdemServicoIshop.exe
    OSAdmin.exe
    PDVAlterdata.exe
    ServidorOffLine.exe
    ServidorOffLineGuardian.exe
    Shell.exe
    Spice.exe
    TotenMarket.exe
    WAgendaAdmin.exe
    wcash.exe
    WorcAdmin.exe
    worc_2005.exe
    WSched.exe
    Wshop.exe
    WShopSE.exe
    WToten.exe
    
) do (
    echo Encerrando: %%P
    taskkill /F /IM "%%P" 2>nul
    echo -------------------------------------------------------------------------
)

echo.
echo Processos validados.
exit