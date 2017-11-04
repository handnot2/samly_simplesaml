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

## Customize the Setup Parameters

Edit `setup/params/params.yml` file. Make sure to change the values appropriately.
Especially pay attention to values set as `changeme`. Change the `timezone`
value.

Edit the `users` section with the test users you need. At the least change
the passwords.

> Add the following to your `/etc/hosts` file:
> ```
> 127.0.0.1 samly.idp
> 127.0.0.1 samly.howto
> 127.0.0.1 idp2.samly.howto
> 127.0.0.1 idp3.samly.howto
> ```

## Register the SAML Service Provider

In the same params.yml file, change the values for `service_providers` section.
Each entry that starts with a dash represents a SAML service provider that
needs to interact with the SimpleSAMLPhp IDP provider you are going to create.

The `base_url` should point to the `sso` route in your Elixir Plug/Phoenix
application. Set `name` to the name of your application. Follow the instructions
in [`Samly`](https://github.com/handnot2/samly) to create openssl certificate
and copy that file as `sp/samly_howto/sp.crt` under `setup` directory.

> When using the setup for applications other than `samly_howto`, use
> `sp/<your-app-name>/sp.crt`. Make sure to change the references in
> `setup/params/params.yml`.

The compose setup process will use these parameters and the templates under
`setup/templates` to properly setup a SAML IdP.

## Create SAML IDP

Once the setup is done as described above, just run `docker-compose up -d`.
This should setup a data container with SimpleSAMLPhp bits, launch PHP
in a separate container as an upstream service and start Nginx fronting
access to PHP.

> You need to `docker-compose down` and `docker-compose up -d` again to
> have a functioning service the first time around. This is due to services
> not knowing when some of the setup is completed before starting. Yes, this
> could be addressed down the line. But this workaround is good enough for now.

## Validate the setup

Visit the URL `http://samly.idp:8082/simplesaml`. You should be able to login
as administrator using the password you set for `auth_adminpassword` in
the `setup/params/params.yml` file.

Check out the `Federation` tab. You should see the SAML service provider you
registered.

If there are any errors in the process, you should be able to change the
parameters in `setup/params/params.yml` file, bring down the containers
using `docker-compose down` and re-create using `docker-compose up -d`.

This same process works with you want to make changes/additions to the
service providers.

## Caution

Keep in mind this is meant for development purposes only.
