[![Build Status](https://travis-ci.org/blacksph3re/loginservice.svg?branch=master)](https://travis-ci.org/blacksph3re/loginservice)

# Loginservice

This should be the login server of a microservice application. The login server has at it's core a tiny user db with just username, email and password and a token system. The API can be found [here](https://loginservice.docs.apiary.io/)

## Token system

The token system is based on two types of tokens,

* Short-lived **Access Tokens** which enable access to all services of the ms architecture
* Long-lived **Refresh Tokens** which are only used to obtain new access tokens

An access token with a TTL of about 30 minutes can be verified cryptographically without db access in any service under knowledge of a common secret, which has to be injected into every service. Also it carries the user name and the email as basic user data, which can be used in the UI without the need for contacting a db or any other microservice. After their expiry, the frontend has to renew the session by using the refresh token to obtain a new access token. The refresh token is additionally stored in a db to enable manual revocation and increase the security of that token type. Effectively, revocation thus needs a TTL of an access token until it takes effect.

Aquiring a refresh token is not possible without logging in again, so every week the user will have to input his password again. This could theoretically be modified to enable infinite login, for security purposes we decided against that.

## Registration

Also, the Loginservice provides a registration frontend to unregistered users. For this, we use the notion of recruitment campaigns, where a campaign can be registered with the loginserver including custom questions to the user. After successful registration including email confirmation, a callback stored in the campaign will be triggered to forward registration data to another microservice and enable processing there. Each registration campaign has a custom link, calling the link will trigger questions specific to that registration campaign. Maybe we will provide a default campaign.

After submitting to a registration campaign, an email will be sent to the user where he has to confirm by clicking on a link.

## Password forgotten

By entering your username or email it is possible to send a password reset link. On this link the user will be able to reset his password.