# @summary Create the required cron job and scripts for sending Puppet Events
#
# This class will create the cron job that executes the event management script.
# It also creates the event management script in the required directory.
#
class common_events::install {
  cron { 'collect_common_events':
    ensure  => 'present',
    command => "${common_events::confdir}/collect_api_events.rb \
    ${common_events::confdir} ${common_events::modulepath} ${common_events::statedir}",
    user    => 'root',
    minute  => '*/2',
    require => [
      File["${common_events::confdir}/collect_api_events.rb"],
      File["${common_events::confdir}/events_collection.yaml"]
    ],
  }

  file { $common_events::confdir:
    ensure  => directory,
    owner   => $common_events::owner,
    group   => $common_events::group,
    recurse => 'remote',
    source  => 'puppet:///modules/common_events/lib',
  }

  file { "${common_events::confdir}/processors.d":
    ensure  => directory,
    owner   => $common_events::owner,
    group   => $common_events::group,
    require => File[$common_events::confdir],
  }

  file { "${common_events::confdir}/events_collection.yaml":
    ensure  => file,
    owner   => $common_events::owner,
    group   => $common_events::group,
    mode    => '0640',
    require => File[$common_events::confdir],
    content => epp('common_events/events_collection.yaml'),
  }

  file { "${common_events::confdir}/collect_api_events.rb":
    ensure  => file,
    owner   => $common_events::owner,
    group   => $common_events::group,
    mode    => '0755',
    require => File[$common_events::confdir],
    source  => 'puppet:///modules/common_events/collect_api_events.rb',
  }
}
