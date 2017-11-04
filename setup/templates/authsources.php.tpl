<?php

$config = array(
	// This is a authentication source which handles admin authentication.
	'admin' => array(
		// The default is to use core:AdminPassword, but it can be replaced with
		// any authentication source.
		'core:AdminPassword',
	),

  'example-userpass' => array(
    'exampleauth:UserPass',
    {{ range $user := .users }}
      '{{ $user.uid }}:{{ $user.password }}' => array(
        'uid' => array('{{ $user.uid }}'),
        'email' => array('{{ $user.email }}'),
        'first_name' => array('{{ $user.first_name }}'),
        'last_name' => array('{{ $user.last_name }}'),
        'role' => array('{{ $user.role }}'),
      ),
    {{ end }}
  ),
);
