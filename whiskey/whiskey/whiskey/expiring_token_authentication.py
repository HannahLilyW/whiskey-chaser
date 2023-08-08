from rest_framework.authentication import TokenAuthentication
from rest_framework.exceptions import AuthenticationFailed
import datetime


class ExpiringTokenAuthentication(TokenAuthentication):
    def authenticate_credentials(self, key):
        user, token = super().authenticate_credentials(key)
        if (token.created < (datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(hours=12))):
            raise AuthenticationFailed('Token has expired. Please authenticate again.')
        return (user, token)
