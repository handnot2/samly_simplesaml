<?php

{{ range $sp := .service_providers }}
$metadata['{{ $sp.entity_id }}'] = array(
  'name' => '{{ $sp.name }}',
  'NameIDFormat' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
  'simplesaml.nameidattribute' => 'uid',
  'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
  'AssertionConsumerService' => '{{ $sp.base_url }}{{ $sp.acs }}',
  'SingleLogoutService' => array(
    0 => array(
      'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
      'Location' => '{{ $sp.base_url }}{{ $sp.slo }}',
    ),
  ),
  {{/* 'SingleLogoutServerResponse' => '{{ $sp.base_url }}{{ $sp.slo_response }}', */}}
  'saml20.sign.response' => true,
  'saml20.sign.assertion' => true,
  'assertion.encryption' => true,
  'sign.logout' => true,
  'validate.authnrequest' => true,
  'validate.logout' => false,
  'certificate' => '{{ $sp.certificate }}',
  {{/* 'certData' => '{{ $sp.cert_data }}', */}}
);
{{ end }}
