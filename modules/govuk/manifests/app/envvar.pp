# govuk::app::envvar
#
# Defines an app-specific environment variable to be exported when the app is
# run using govuk_spinup or govuk_setenv.
#
# Unlike govuk_envvar, the dependency between the govuk::app::envvar and the
# application is explicitly encoded, so changing a govuk::app::envvar should
# automatically restart the relevant application.
#
# We use envdir to read the files we place in env.d and this only reads the
# first line of the file.  To deliver multiline values we have to convert
# newlines into null characters.  Envdir will then do the reverse when it
# reads the value out of the file and makes it available in the environment.

define govuk::app::envvar (
  # Name of the application with which this env var is associated
  $app,
  # Value of the environment variable
  $value,
  $envdir  = "/etc/govuk/${app}/env.d",
  $varname = $title,
  $notify_service  = true,
) {
  validate_string($value)

  $nulls_for_newlines_value = inline_template('<%= @value.encode(
    @value.encoding,
    universal_newline: true
  ).gsub(/\n/,"\0") unless @value.nil? %>')

  if $notify_service {
    file { "${envdir}/${varname}":
      ensure  => present,
      content => $nulls_for_newlines_value,
      notify  => [ Govuk::App::Service[$app], Exec['build-composite-env-file'] ],
    }
  } else {
    file { "${envdir}/${varname}":
      ensure  => present,
      content => $nulls_for_newlines_value,
      notify  => Exec['build-composite-env-file'],
    }
  }

  # build a file containing all the envvars for the given application
  exec { 'build-composite-env-file':
    path        => ['/bin', '/usr/bin'],
    command     => "cat `find ${envdir} -type f` > /etc/govuk/${app}-env-file",
    refreshonly => true,
  }

}
