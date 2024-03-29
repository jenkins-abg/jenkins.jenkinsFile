:: Purpose:         Batch script containing all commands to fix and prepare unittest design.
::                  In case a parameter is missing, it will result to an error and create log file
:: Parameters:      %1 : initial path of ATG IDs
::                  %2 : path where target IDs will be copied
::                  %3 : winams environment
::                  %4 : project component
::                  %5 : project model version
::                  %6 : kanri filename
::                  %7 : keisoku file
:: Requirements:    1. input_param.vbs
::                  2. transfer_target_ids.vbs
::                  3. test_fix.vbs
:: Author:          prdedumo.acn
:: Version:         1.0.1 + Changes argument assignment due to keisoku path
::                  1.0.0 . Initial write
@echo off
setlocal enabledelayedexpansion

::::::::::::::::::::::::::::::::::::::
:: STAGE 1: VARIABLE PREP AND CHECK ::
::::::::::::::::::::::::::::::::::::::
:: create first instance of log file
call %~dp0function\init_log.bat
call %~dp0function\log_with_date.bat "  stage_1_variable_prep_and_check begin..."

::  pass bat parameter values to initialize script-internal variables
set atg_path=%1
set transfer_atg_path=%2
set WINAMS_PATH=%3
set compo=%4
set model_ver=%5
set full_kanri=%6
set keisoku_file=%7

set test_editor=%~dp0..\02_testsheet_editor\testsheet_editor.xlsm
set static_editor=%~dp0..\02_testsheet_editor\テストシート修正マクロ.xlsm

:: checking folder/file path if exists
if not exist %atg_path% (
    call %~dp0function\log_with_date.bat " ATG Path: %atg_path% "
    call %~dp0function\log_with_date.bat " Path is not existing, terminating build..."
    goto error_exit
)
if not exist %transfer_atg_path% (
    call %~dp0function\log_with_date.bat " Transfer Path: %transfer_atg_path% "
    call %~dp0function\log_with_date.bat " Path is not existing, terminating build..."
    goto error_exit
)
if not exist %keisoku_file% (
    call %~dp0function\log_with_date.bat " File: %keisoku_file% "
    call %~dp0function\log_with_date.bat " Path is not existing, terminating build..."
    goto error_exit
)
if not exist %full_kanri% (
    call %~dp0function\log_with_date.bat " File: %full_kanri% "
    call %~dp0function\log_with_date.bat " File is not existing, terminating build..."
    goto error_exit
)
if not exist %test_editor% (
    call %~dp0function\log_with_date.bat " File: %test_editor% "
    call %~dp0function\log_with_date.bat " File is not existing, terminating build..."
:error_exit
    exit /b 1
)

call %~dp0function\log_with_date.bat "   Done."
:: sleep for 5 seconds before proceeding
ping -n 5 127.0.0.1 > nul

::::::::::::::::::::::::::::::::::::
:: STAGE 2: CREATE PARAMETER FILE ::
::::::::::::::::::::::::::::::::::::
call %~dp0function\log_with_date.bat "  stage_2_creating_parameter begin..."
:: create temp csv for output file of paramters
set tmp_csv=%~dp0tmp\tmp.csv

:: transfer param details from to csv
echo:%atg_path%>%tmp_csv%
echo:%transfer_atg_path%>>%tmp_csv%
echo:%compo%>>%tmp_csv%
echo:%model_ver%>>%tmp_csv%
echo:%full_kanri%>>%tmp_csv%
echo:%keisoku_file%>>%tmp_csv%

call %~dp0function\log_with_date.bat "   Done."
:: sleep for 5 seconds before proceeding
ping -n 5 127.0.0.1 > nul

::::::::::::::::::::::::::::::::::::::::
:: STAGE 3: POPULATE TESTSHEET EDITOR ::
::::::::::::::::::::::::::::::::::::::::
call %~dp0function\log_with_date.bat "  stage_3_populate_testeditor begin..."

:: Call input_param.vbs
cscript.exe %~dp0vbs\input_param.vbs %test_editor% %tmp_csv%
:: check if there is an error
if !ERRORLEVEL! NEQ 0 (
    call %~dp0function\log_with_date.bat "  Error in stage_3_populate_testeditor, terminating build..."
    goto error_exit
)
:: loop check if vbs is still running
:whileA
tasklist /fi "imagename eq input_param.vbs" | find ":" > nul
if errorlevel 1 (
    goto :whileA
)
call %~dp0function\log_with_date.bat "   Done."
:: sleep for 5 seconds before proceeding
ping -n 5 127.0.0.1 > nul

::::::::::::::::::::::::::::::::::
:: STAGE 4: TRANSFER TARGET IDS ::
::::::::::::::::::::::::::::::::::
call %~dp0function\log_with_date.bat "  stage_4_transfer_ids begin..."

:: call vbs to transfer ATG to working folder
cscript.exe %~dp0vbs\transfer_target_ids.vbs %test_editor%
:: check if there is an error
if !ERRORLEVEL! NEQ 0 (
    call %~dp0function\log_with_date.bat "  Error in stage_4_transfer_ids, terminating build..."
    goto error_exit
)
:: loop check if vbs is still running
:whileB
tasklist /fi "imagename eq transfer_target_ids.vbs" | find ":" > nul
if errorlevel 1 (
    goto :whileB
)
call %~dp0function\log_with_date.bat "   Done."
:: sleep for 5 seconds before proceeding
ping -n 5 127.0.0.1 > nul

:::::::::::::::::::::::::::::
:: STAGE 5: FIX TEST SHEET ::
:::::::::::::::::::::::::::::
call %~dp0function\log_with_date.bat "  stage_5_test_fix begin..."
:: call vbs to perform testheet fixing
cscript.exe %~dp0vbs\test_fix.vbs %full_kanri% %test_editor% %keisoku_file%
if !ERRORLEVEL! NEQ 0 (
    call %~dp0function\log_with_date.bat "  Error in stage_5_test_fix, terminating build..."
    goto error_exit
)
:: loop check if vbs is still running
:whileC
tasklist /fi "imagename eq test_fix.vbs" | find ":" > nul
if errorlevel 1 (
    goto :whileC
)

set code_path=%~dp0c-source
:: check if there is winAMS environment
if exist %WINAMS_PATH% (
    :: fix for static variables
    call %~dp0find_c.bat
    :: loop check if bat is still running
    :whileD
    tasklist /fi "imagename eq find_c.bat" | find ":" > nul
    if errorlevel 1 (
        goto :whileD
    )

    :: call vbs to perform static fixing
    cscript.exe %~dp0vbs\test_fix_static.vbs %static_editor% %full_kanri% %keisoku_file% %code_path% %transfer_atg_path%
    :: check if there is an error
    if !ERRORLEVEL! NEQ 0 (
        call %~dp0function\log_with_date.bat "  Error in stage_5_static_fix, terminating build..."
        goto error_exit
    )
    :: loop check if vbs is still running
    :whileE
    tasklist /fi "imagename eq test_fix_static.vbs" | find ":" > nul
    if errorlevel 1 (
        goto :whileE
    )
)

call %~dp0function\log_with_date.bat "   Done."

:: sleep for 5 seconds before ending the process
ping -n 5 127.0.0.1 > nul