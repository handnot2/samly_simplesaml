<?php

$metadata['{{ .baseurlpath }}saml2/idp/metadata.php'] = array(
  'host' => '{{ .idp_host }}',
  'metadata-set' => 'saml20-idp-remote',
  'entityid' => '{{ .baseurlpath }}saml2/idp/metadata.php',
  'privatekey' => 'server.pem',
  'certificate' => 'server.crt',
  'auth' => 'example-userpass',
  'sign.logout' => true,
  'validate.authnrequest' => true,
  /* 'validate.logout' => true, */
  'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
  'SingleSignOnServiceBinding' => array(
    'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
    'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
  ),
  'SingleLogoutServiceBinding' => array(
    'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
    'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
  ),
);
