<?php
/**
 * SAML 2.0 remote IdP metadata for simpleSAMLphp.
 *
 * Remember to remove the IdPs you don't use from this file.
 *
 * See: https://simplesamlphp.org/docs/stable/simplesamlphp-reference-idp-remote
 */

{{ range $metadata := .metadata }}
$metadata['{{ $metadata.entityid }}'] = array (
    'metadata-set' => '{{ $metadata.metadata_set }}',
    'entityid' => '{{ $metadata.entityid }}',
    'SingleSignOnService' =>
    array (
        0 => array (
            'Binding' => '{{ $metadata.ssos.binding }}',
            'Location' => '{{ $metadata.ssos.location }}',
        ),
    ),
    'SingleLogoutService' =>
    array (
        0 =>
        array (
            'Binding' => '{{ $metadata.slo.binding }}',
            'Location' => '{{ $metadata.slo.location }}',
        ),
    ),
    'certData' => '{{ $metadata.certdata }}',
    'NameIDFormat' => '{{ $metadata.name_id_format }}',
);
{{ end }}
