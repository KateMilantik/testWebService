*** Settings ***
Library    TestWeb
Library	   HttpLibrary.HTTP
Library    String
Library    RequestsChecker
Library    RequestsLogger
Variables  json_paths.py
Variables  status_codes.py
Documentation    Suit for testing /get, /basic-auth and /stream

*** Test Cases ***
Test get header
    [Documentation]    Checks a header in /get response
    ${response} =    Get Request
    ${header_host} =    Get Json Value     ${response.content}    ${header}
    Common Check    ${response}
    Should Contain    ${header_host}    httpbin.org

Test authorization
    [Documentation]    Checks status code while trying to authorize
    ...                using different combinations of credentials
    [Template]    Authorization with valid creds should result in OK status code
    user    pass    user         pass         ${status_ok}
    user    pass    wronguser    pass         ${status_unauth}
    user    pass    user         wrongpass    ${status_unauth}
    user    pass    wronguser    wrongpass    ${status_unauth}
    user    pass    ${EMPTY}     pass         ${status_unauth}
    user    pass    user         ${EMPTY}     ${status_unauth}
    user    pass    ${EMPTY}     ${EMPTY}     ${status_unauth}

Test stream
    [Documentation]    Checks the number of lines in /stream response
    ${lines_num_expected}    Set Variable    5
    ${response} =    Stream Request    ${lines_num_expected}
    ${lines_num_actual} =    Get Line Count    ${response.content}
    Common Check    ${response}
    Should Be Equal As Integers    ${lines_num_actual}    ${lines_num_expected}

*** Keywords ***
Authorization with valid creds should result in OK status code
    [Documentation]    Takes pair of expected credentials and
    ...                pair of actual ones and expected status code
    [Arguments]    ${user1}    ${pass1}    ${user2}    ${pass2}    ${status}
    ${response} =    Authorize    ${user1}    ${pass1}    ${user2}    ${pass2}
    Check Status Code    ${status}    ${response}
