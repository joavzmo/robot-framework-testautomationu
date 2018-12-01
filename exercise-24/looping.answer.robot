*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
Library  String

Resource  ${EXEC_DIR}/resources.robot
Suite Setup  Run Keywords   Navigate To Home Page   Delete Invoice If Exists
Suite Teardown  Run Keywords    Close Browser


*** Test Cases ***
Create an Invoice
    Click Add Invoice
    ${invoiceNumber}=    Create Invoice Number
    Set Suite Variable  ${invoiceNumber}
    Input Text  invoice   ${invoiceNumber}
    Input Text  company   my example company
    Input Text  type   plumbing
    Input Text  price   34.00
    Input Text  dueDate   2018-10-31
    Input Text  comment   Unclogged Drain
    Select From List By Value   selectStatus    Past Due
    Click Button    createButton
    Page Should Contain     ${invoiceNumber}
        ${invoices_ids}=   Get Web Elements    //tbody//tr//a
    log to console  ${invoices_ids}
    :FOR    ${invoice}    IN     ${invoices_ids}
    \    Log To Console     ${invoice}


*** Keywords ***
Navigate To Home Page
    # Requires Chromedriver in Path (See earlier Excercise)
    Set Environment Variable    PATH  %{PATH}:${EXECDIR}/../drivers
    Open Browser    ${SiteUrl}		${Browser}
    Set Selenium Implicit Wait    10 Seconds
    Set Selenium Speed     .25 seconds


Click Add Invoice
    Click Link  Add Invoice
    Page Should Contain Element     invoiceNo_add

Invoice
    [Arguments]  ${invoice_element}
    Click Link  ${invoice_element}
    Click Button    deleteButton

Create Invoice Number
    ${RANUSER}    Generate Random String    10    [LETTERS]
    [Return]    ${RANUSER}

Delete Invoice If Exists
    ${invoice_count}=   Get Element Count    css:[id^='invoiceNo_paulm'] > a
    Run Keyword If      ${invoice_count} > 0    Delete Invoice  css:[id^='invoiceNo_paulm'] > a
