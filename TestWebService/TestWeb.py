"""Modules:
   requests - to work with HTTP requests
   config - to import settings for test execution
"""
import requests
import config


class TestWeb(object):
    """Library for web-service testing"""

    def __init__(self):
        pass

    url = config.url

    def authorize(self, user_expected, password_expected,
                  user_actual, password_actual):
        """Returns status code after successful or unsuccessful
        authorization

        Arguments:
        user_expected -- user name specified in URL
        password_expected -- password specified in URL
        user_actual -- user name entered into prompt window
        password_actual -- password entered into prompt window
        """
        request_url = self.url + "/basic-auth/" + user_expected + "/" + password_expected
        auth_stat = requests.get(request_url,
                                 auth=(user_actual, password_actual)).status_code
        return auth_stat

    def get_request(self):
        """Returns status code and content of the page"""

        get_response = requests.get(self.url + "/get")
        get_cont = get_response.content
        get_stat = get_response.status_code
        return get_cont, get_stat

    def stream_request(self, lines_number):
        """Returns status code and content of the page

        Arguments:
        n -- number of lines to be shown
        """

        stream_response = requests.get(self.url + "/stream/" + lines_number)
        str_cont = stream_response.content
        str_stat = stream_response.status_code
        return str_cont, str_stat
