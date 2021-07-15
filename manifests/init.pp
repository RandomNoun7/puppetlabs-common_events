# @summary Create the required cron job and scripts for sending Puppet Events
#
# This class will create the cron job that executes the event management script.
# It also creates the event management script in the required directory.
#
# @example
#   include common_events
class common_events (
  Optional[String]            $pe_username = undef,
  Optional[Sensitive[String]] $pe_password = undef,
  Optional[String]            $pe_token    = undef,
) {

  # Account for the differences in Puppet Enterprise and open source
  if $facts[pe_server_version] != undef {
    $owner          = 'pe-puppet'
    $group          = 'pe-puppet'
    $confdir        = '/etc/puppetlabs/puppet/common_events'
    $modulepath     = '/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules'
    $statedir       = '/etc/puppetlabs/puppet/common_events/processors.d'
    include common_events::install
  }
  else {
    notify { 'Non-PE':
      message => 'Error: This module is intended for use with Puppet Enterprise only.',
    }
  }

  if (
    ($pe_token == undef)
    and
    ($pe_username == undef or $pe_password == undef)
  ) {
    $authorization_failure_message = @(MESSAGE/L)
    Please set both 'pe_username' and 'pe_password' \
    if you are not using a pre generated PE authorization \
    token in the 'pe_token' parameter
    |-MESSAGE
    fail($authorization_failure_message)
  }
}
