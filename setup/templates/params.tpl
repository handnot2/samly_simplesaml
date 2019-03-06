---
idp_host:               {{ .idp_host }}
idp_port:               {{ .idp_port }}
baseurlpath:            https://{{ .idp_host}}:{{ .idp_port }}/simplesaml/
certdir:                cert/
datadir:                data/
tempdir:                /tmp/simplesaml
secretsalt:             {{ .secret_salt }}
auth_adminpassword:     {{ .pswd }}
admin_protectindexpage: True
admin_protectmetadata:  False
technicalcontact_name:  Jane Doe
technicalcontact_email: jane.doe@company.com
timezone:               America/New_York
enable_saml20_idp:      True
enable_shib13_idp:      False
enable_adfs_idp:        False
enable_wsfed_sp:        False
enable_authmemcookie:   False
debug:                  True
showerrors:             False
errorreporting:         False
loggin_level:           DEBUG
logging_handler:        file
loggingdir:             /tmp/
debug_validatexml:      True

# Session
session_durration:               28800
session_datastore_timeout:       14400
session_state_timeout:           3600
cookie_name:                     SamlySimpleSAMLSessionID_{{ .idp_id }}
session_cookie_lifetime:         0
session_cookie_domain:           null
session_cookie_secure:           False
session_disable_fallback:        False
enable_http_post:                False
session_phpsession_cookiename:   null
session_phpsession_savepath:     null
session_phpsession_httponly:     True
session_authtoken_cookiename:    SamlySimpleSAMLAuthToken_{{ .idp_id }}
session_rememberme_enable:       False
session_rememberme_checked:      False
session_rememberme_lifetime:     1209600

# Language
language_default:                en
language_parameter_name:         language
language_parameter_setcookie:    True
language_cookie_name:            language
language_cookie_domain:          null
language_cookie_path:            /
language_cookie_lifetime:        77760000

service_providers:
  - base_url: {{ .sp_baseurl }}
    entity_id: {{ .sp_entity_id }}
    idp_id: {{ .idp_id }}
    name: Samly Service Provider 1
    certificate: {{ .sp_cert_file }}
    acs: {{ .sp_acs_uri }}
    slo: {{ .sp_slo_uri }}
    slo_response: {{ .sp_slo_uri }}

authsources:
  - name: example-userpass

users:
  - uid: fred
    first_name: Fred
    last_name: Stone
    roles:
      - skipper
    email: fred@stone.age
    password: {{ .pswd }}
  - uid: wilma
    first_name: Wilma
    last_name: Stone
    roles:
      - admin
    email: wilma@stone.age
    password: {{ .pswd }}
  - uid: dino
    first_name: Dino
    last_name: Stone
    roles:
      - worker
      - joker
      - docker
    email: dino@stone.age
    password: {{ .pswd }}
