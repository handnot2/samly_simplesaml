# SimpleSAMLPhp development setup for working with Samly Elixir Library

This is based on `https://github.com/hcpss-banderson/docker-simplesamlphp`
repo. It has been modified to setup SimpleSAMLPhp as an IDP using the
`example-userpass` authentication module. Template for registering a SAML
service provider is also included (`setup/templates/saml20-sp-remote.php.tpl`).

> This is setup to be an Identity Provider (IdP) for a `samly` demo Phoenix
> application ([`samly_howto`](https://github.com/handnot2/samly_howto)).
> But the usage is not limited to `samly_howto`.

## Building Docker Image

```sh
./build.sh
```

This creates `samlysaml:latest` docker image. Modify the `Dockerfile` if you
want to change the `SimpleSAMLPhp` version. The image is based on the stock
Alpine PHP.

## Update `/etc/hosts`

Add the following to your `/etc/hosts` file:

```
# Change the host names appropriately
127.0.0.1 samly.howto idp2.samly.howto idp3.samly.howto
127.0.0.1 idp1.samly idp2.samly idp3.samly
```

## Create a docker-compose wrapper to manage IdP instance

The instructions here help you setup a data container with SimpleSAMLPhp bits, launch PHP
in a separate container as an upstream service and start Nginx fronting
access to PHP.

### Service Provider Application Certificate for SAML communication

Create a self-signed certificate to be used for signed SAML requests. If you are using
Elixir Phoenix based Service provider application, you can use `mix phx.gen.cert`
command to generate a certificate.

Check [`samly_howto`](https://github.com/handnot2/samly_howto) `README.md`
for instructions. This file should be copied to the `setup/sp` directory.

> This certificate is not the same as the key/certificate for your application's
> HTTPS interaction. It should be used only for SAML requests. 

### IdP for use with `samly` configured in `path_segment` model

```sh
#!/bin/sh
# Save this as idp1-compose.sh

export USE_SUBDOMAIN=0
export TIMEZONE=America/New_York # <<- change this if needed

export SP_DOMAIN=samly.howto # <<- change this, this is same as SP HOST in path_segment model
export SP_PORT=4443 # <<- change this
export SP_ENTITY_ID=urn:${SP_DOMAIN}:samly_sp # <<- change this - should match what is in samly config
export SP_CERT_FILE=samly_sp.pem # <<- change this - this should be present in ./setup/sp folder

export PSWD=changeme1 # <<- change this - password for all demo users in ./setup/templates/params.tpl

export IDP_ID=idp1 # <<- change this
export IDP_HOST=${IDP_ID}.samly
export IDP_PORT=9091 # <<- change this

sudo -E ./compose.sh $*
```

Once saved with appropriate updated values, you can use this newly created script to manage the IdP.
This is a simple wrapper around `docker-compose`. You can start IdP using the following command:

```sh
./idp1-compose.sh up -d
./idp1-compose.sh down
./idp1-compose.sh up -d
```

You might be prompted for sudo password.

> You need to `docker-compose down` and `docker-compose up -d` again to
> have a functioning service the first time around. This is due to services
> not knowing when some of the setup is completed before starting. Yes, this
> could be addressed down the line. But this workaround is good enough for now.

You can use the following to get information about the IdP setup with the following command:

```sh
./idp1-compose.sh info
```

This will display something like the following:

```
----------------------------------------------------
IDP Metadata URL = https://idp1.samly:9091/simplesaml/saml2/idp/metadata.php
Assertion Consumer Service URL (ACS) = https://samly.howto:4443/sso/sp/consume/idp1
Single Logout URL (SLO) = https://samly.howto:4443/sso/sp/logout/idp1
SP Base URL = https://samly.howto:4443/sso
SP Entity ID = urn:samly.howto:samly_sp
SP Certificate file = samly_sp.pem
----------------------------------------------------
```

### IdPs for use with `samly` configured in `sub_domain` model

```sh
#!/bin/sh
# Save this as idp2-compose.sh

export USE_SUBDOMAIN=1
export TIMEZONE=America/New_York # <<- change this if needed

export SP_DOMAIN=samly.howto # <<- change this
export SP_PORT=4443 # <<- change this
export SP_ENTITY_ID=urn:${SP_DOMAIN}:samly_sp # <<- change this - should match what is in samly config
export SP_CERT_FILE=samly_sp.pem # <<- change this - this should be present in ./setup/sp folder

export PSWD=changeme2 # <<- change this - password for all demo users in ./setup/templates/params.tpl

export IDP_ID=idp2 # <<- change this
export IDP_HOST=${IDP_ID}.samly
export IDP_PORT=9092 # <<- change this

sudo -E ./compose.sh $*
```

Once saved with appropriate updated values, you can use this newly created script to manage the IdP.
This is a simple wrapper around `docker-compose`. You can start IdP using the following command:

```sh
./idp2-compose.sh up -d
./idp2-compose.sh down
./idp2-compose.sh up -d
```

You might be prompted for sudo password.

You can run the following command to get information about the IdP set with the following command:

```sh
./idp2-compose.sh info
```

This shows out similar to:

```
----------------------------------------------------
IDP Metadata URL = https://idp2.samly:9092/simplesaml/saml2/idp/metadata.php
Assertion Consumer Service URL (ACS) = https://idp2.samly.howto:4443/sso/sp/consume
Single Logout URL (SLO) = https://idp2.samly.howto:4443/sso/sp/logout
SP Base URL = https://idp2.samly.howto:4443/sso
SP Entity ID = urn:samly.howto:samly_sp
SP Certificate file = samly_sp.pem
----------------------------------------------------
```

> You can create another instance of an IdP for use with your sub-domain based Phoenix application
> by simply copying this newly created script as `idp3-compose.sh` and changing the values of
> `IDP_ID`, `IDP_PORT` and password.

## Validate the setup

Visit the URL `https://${IDP_HOST}:${IDP_PORT}/simplesaml`. You should be able to login
as administrator using the password you set in your compose script.

Check out the `Federation` tab. You should see the SAML service provider.

If there are any errors in the process, you should be able to change the
variables in your compose script file, bring down the containers
using `./idp1-compose.sh down` and re-create using `./idp1-compose.sh up -d`.

## Caution

> Keep in mind this is meant for development purposes only.
