<?php

{{ range $sp := .service_providers }}
$metadata['{{ $sp.base_url }}/sp/metadata'] = array(
  'name' => '{{ $sp.name }}',
  'NameIDFormat' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
  'simplesaml.nameidattribute' => 'uid',
  'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
  'AssertionConsumerService' => '{{ $sp.base_url }}/sp/consume',
  {{/* 'SingleLogoutService' => '{{ $sp.base_url }}/sp/logout', */}}
  'SingleLogoutService' => array(
    0 => array(
      'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
      'Location' => '{{ $sp.base_url }}/sp/logout',
    ),
  ),
  {{/* 'SingleLogoutServerResponse' => '{{ $sp.base_url }}/sp/logout', */}}
  'sign.logout' => true,
  'validate.authnrequest' => true,
  /* 'validate.logout' => true, */
  'certificate' => '{{ $sp.certificate }}',
  {{/* 'certData' => '{{ $sp.cert_data }}', */}}
);
{{ end }}
