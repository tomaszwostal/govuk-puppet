# == Class: govuk_jenkins::job::production_smokey_deploy
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
class govuk_jenkins::job::production_smokey_deploy {
  file { '/etc/jenkins_jobs/jobs/production_smokey_deploy.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/production_smokey_deploy.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
