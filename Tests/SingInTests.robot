
*** Settings ***
Library           SeleniumLibrary
Library           FakerLibrary    locale=pt_BR
Library           BuiltIn
# Test Setup        Set Test Environment    chrome    prod
# Test Teardown     Close All Browsers
Resource          ../Config/Config.robot
Resource          ../Resources/Steps/HomeStep.robot
Resource          ../Resources/Steps/SingInStep.robot
Resource          ../Resources/Helper/FakerHelper.robot
Resource          ../Resources/Steps/CreateAnAccountStep.robot
Resource          ../Resources/Data/Excel.robot


*** Test Cases ***
CT01:Validar o click Sing in
    [Documentation]     Automação Verificar o Sing in
    [Tags]              CT01
    Quando clico no botão Sign in

CT02:Preencher e-mail e criar a conta
    [Documentation]     Automação Verificar o Sing in
    [Tags]              CT02
    ${Email}            Generate Random Email
    ${First_Name}       Generate Random Name
    ${Last_Name}        Generate Random Last Name
    ${Password}         Generate Random Password    
    ${Data}             Generate Random Data

    Quando clico no botão Sign in
    E preencho o campo create e-mail address      ${Email}
    E clico em Create an account
    Então devo informar os meus dados para criar a conta    ${First_Name}    ${Last_Name}   ${Email}    ${Password}    ${Data}

CT03:Validar a mensagem Invalid email address
    [Documentation]     Automação Verificar o Sing in
    [Tags]              CT03
    ${Email_Inválido}       Generate Random Last Name
    Quando clico no botão Sign in
    E preencho um e-mail inválido      ${Email_Inválido}
    E clico em Create an account
    Então verifico a mensagem Invalid email address


CT01: Editando arquivos de Excel
    [Documentation]    Automação cria novo arquivo e insere informações
    [Tags]             CT01
    Abrindo documento de Excel
    Lendo celulas das Colunas C e H
    Resultados Colunas C e H
    Inserindo nomes e datas de nascimento Faker
    Inserindo Resultados da Coluna C e H na planilha "Nomes e datas de nascimento"
    

       