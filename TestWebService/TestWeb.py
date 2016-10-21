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
        """Returns status code after successful or unsuccessful authorization

        Arguments:
        user_expected -- user name specified in URL
        password_expected -- password specified in URL
        user_actual -- user name entered into prompt window
        password_actual -- password entered into prompt window
        """
        request_url = self.url + "/basic-auth/" + user_expected + "/" + password_expected
        auth_response = requests.get(request_url, auth=(user_actual, password_actual))
        return auth_response

    def get_request(self):
        """Returns status code and content of the page"""

        get_response = requests.get(self.url + "/get")
        get_content = get_response.content
        return get_response, get_content

    def stream_request(self, lines_number):
        """Returns status code and content of the page
        as well as request information to be logged

        Arguments:
        n -- number of lines to be shown
        """

        stream_log = requests.get(self.url + "/stream/1")
        stream_response = requests.get(self.url + "/stream/" + str(lines_number))

        str_content = stream_response.content
        return stream_log, stream_response, str_content
