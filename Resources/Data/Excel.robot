*** Settings ***
Library    RPA.Excel.Application
Library    RPA.Excel.Files
Library    Collections
Library    ../../utils/Excel/criar_planilha.py
Library    BuiltIn
Library    FakerLibrary    locale=pt_BR

*** Variables ***
${EXCEL_DADOS}            ${CURDIR}../../../../../../Downloads/dados.csv
${EXCEL_DATA_E_NOMES}     ${CURDIR}../../../../../../Downloads/nomes_data_fake.xlsx




*** Keywords ***


Abrindo documento de Excel
    RPA.Excel.Application.Open Workbook    ${EXCEL_DADOS}
    # Defina a planilha ativa
    RPA.Excel.Application.Set Active Worksheet    sheetname=dados
    # Defina a coluna da qual você deseja listar os itens
   

    
Lendo celulas das Colunas C e H
    Listar itens da Coluna C
    Listar itens da Coluna H
    



Listar itens da Coluna C
    ${column_letter}=    Set Variable    3
    ${start_row}=    Set Variable    2  # Assumindo que a primeira linha é o cabeçalho
    ${results_C}    Create List
    
    # Coluna C
    FOR    ${row_index}    IN RANGE    ${start_row}    999
        ${cell_value}=    Read From Cells    row=${row_index}    column=${column_letter}
        Run Keyword If    "${cell_value}" == "None"    Exit For Loop
        Log    ${cell_value}
        Append To List    ${results_C}    ${cell_value}
        
    END
    RETURN    ${results_C}
    

    
Listar itens da Coluna H
    RPA.Excel.Application.Open Workbook    ${EXCEL_DADOS}
    RPA.Excel.Application.Set Active Worksheet    sheetname=dados
    ${column_letter}=    Set Variable    8
    ${start_row}=    Set Variable    2  
    ${results_H}    Create List

    FOR    ${row_index}    IN RANGE    ${start_row}    999
        ${cell_value}=    Read From Cells    row=${row_index}    column=${column_letter}
        Run Keyword If    "${cell_value}" == "None"    Exit For Loop
        Log    ${cell_value}
        Append To List    ${results_H}    ${cell_value}
        
    END
    RETURN    ${results_H}
    
Resultados Colunas C e H
    @{coluna_c}=     Listar itens da Coluna C
    BuiltIn.Log Many    @{coluna_c}
    @{coluna_H}=     Listar itens da Coluna H
    BuiltIn.Log Many   @{coluna_H}

Inserindo nomes e datas de nascimento Faker
    ${linha_index}    Set Variable    2

    # Nomes
       FOR    ${COUNT}    IN RANGE    1    10
        ${nome}     Gerar Nomes
        RPA.Excel.Application.Open Workbook    ${EXCEL_DATA_E_NOMES}
        RPA.Excel.Application.Set Active Worksheet    sheetname=nome_data
        ${linha_index}    Convert To Integer    ${linha_index}
        Write To Cells    worksheet=nome_data   row=${linha_index}   column=2   value=${nome}       
        ${linha_index}=    Set Variable    ${linha_index + 1}  
          
    END

    ${linha_index}    Set Variable    2
# Data nascimento
       FOR    ${COUNT}    IN RANGE    1    10
        ${data_nasc}     Gerar Data Nascimento
        RPA.Excel.Application.Open Workbook    ${EXCEL_DATA_E_NOMES}
        RPA.Excel.Application.Set Active Worksheet    sheetname=nome_data
        ${linha_index}    Convert To Integer    ${linha_index}
        Write To Cells    worksheet=nome_data   row=${linha_index}   column=3   value=${data_nasc}       
        ${linha_index}=    Set Variable    ${linha_index + 1} 
              
    END

    Save Excel As        ${EXCEL_DATA_E_NOMES}

Inserindo Resultados da Coluna C e H na planilha "Nomes e datas de nascimento"
    ${linha_index}    Set Variable    2
    @{coluna_c}=     Listar itens da Coluna C
    @{coluna_H}=     Listar itens da Coluna H

# Coluna C
       FOR    ${COUNT}    IN     @{coluna_c}
        RPA.Excel.Application.Open Workbook    ${EXCEL_DATA_E_NOMES}
        RPA.Excel.Application.Set Active Worksheet    sheetname=nome_data
        ${linha_index}    Convert To Integer    ${linha_index}
        Write To Cells    worksheet=nome_data   row=${linha_index}   column=1   value=${COUNT}       
        ${linha_index}=    Set Variable    ${linha_index + 1}  
        Run Keyword If       "${linha_index}"==9    Exit For Loop      
    END
# Coluna H
    ${linha_index}    Set Variable    2
    
       FOR    ${COUNT}    IN     @{coluna_H}
        RPA.Excel.Application.Open Workbook    ${EXCEL_DATA_E_NOMES}
        RPA.Excel.Application.Set Active Worksheet    sheetname=nome_data
        ${linha_index}    Convert To Integer    ${linha_index}
        Write To Cells    worksheet=nome_data   row=${linha_index}   column=4  value=${COUNT}      
        ${linha_index}=    Set Variable    ${linha_index + 1}   
        Run Keyword If      "${linha_index}"==9   Exit For Loop     
    END
    Save Excel As        ${EXCEL_DATA_E_NOMES}


Gerar Nomes        
    ${Nomes}     FakerLibrary.Name 
    Set Test Variable    ${Nomes}
    [Return]    ${Nomes}
    Log     ${Nomes}


Gerar Data Nascimento    
    ${data_nascimento}    FakerLibrary.Date Of Birth
    [Return]    ${data_nascimento}
    Log    ${data_nascimento}