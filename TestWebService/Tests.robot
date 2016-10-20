*** Settings ***
Library    TestWeb
Library	   HttpLibrary.HTTP
Library    String
Variables  json_paths.py
Variables  status_codes.py
Documentation    Suit for testing /get, /basic-auth and /stream

*** Test Cases ***
Test get header
    [Documentation]    Checks a header in /get response
    ${response}    ${status} =  Get Request
    ${header_host} =       Get Json Value  ${response}  ${header}
    Should Contain    ${header_host}    httpbin.org
    Should Be Equal As Strings    ${status}    ${status_ok}

Test authorization
    [Documentation]    Checks status code while trying to authorize
    ...                using different combinations of credentials
    [Template]      Authorization with valid creds should result in OK status code
    user   pass   user        pass        ${status_ok}
    user   pass   wronguser   pass        ${status_unauth}
    user   pass   user        wrongpass   ${status_unauth}
    user   pass   wronguser   wrongpass   ${status_unauth}
    user   pass   ${EMPTY}    pass        ${status_unauth}
    user   pass   user        ${EMPTY}    ${status_unauth}
    user   pass   ${EMPTY}    ${EMPTY}    ${status_unauth}

Test stream
    [Documentation]    Checks the number of lines in /stream response
    ${lines_num_expected}    Set Variable    2
    ${content}    ${status} =     Stream Request    ${lines_num_expected}
    ${lines_num_actual} =     Get Line Count   ${content}
    Should Be Equal As Integers   ${lines_num_actual}     ${lines_num_expected}
    Should Be Equal As Strings    ${status}    ${status_ok}

*** Keywords ***
Authorization with valid creds should result in OK status code
    [Documentation]    Takes pair of expected credentials and
    ...                pair of actual ones and expected status code
    [Arguments]    ${user1}    ${pass1}    ${user2}    ${pass2}    ${status}
    ${result} =    Authorize      ${user1}       ${pass1}      ${user2}       ${pass2}
    Should Be Equal As Strings    ${result}       ${status}
