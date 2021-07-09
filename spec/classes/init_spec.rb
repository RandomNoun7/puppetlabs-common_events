require 'spec_helper'

describe 'common_events' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:params) { { 'pe_token' => 'blah' } }
      let(:facts) do
        facts.merge(pe_server_version: '2019.8.7')
      end

      it {
        is_expected.to contain_file('/etc/puppetlabs/puppet/common_events')
          .with(
          ensure: 'directory',
        )
      }

      it {
        is_expected.to contain_file('/etc/puppetlabs/puppet/common_events/collect_api_events.rb')
          .with(
          ensure: 'file',
          require: 'File[/etc/puppetlabs/puppet/common_events]',
        )
      }

      it {
        is_expected.to contain_file('/etc/puppetlabs/puppet/common_events/events_collection.yaml')
          .with(
          ensure: 'file',
          require: 'File[/etc/puppetlabs/puppet/common_events]',
        )
      }

      it {
        is_expected.to contain_cron('collect_common_events')
          .with_command('/etc/puppetlabs/puppet/common_events/collect_api_events.rb' \
          ' /etc/puppetlabs/puppet/common_events' \
          ' /etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules' \
          ' /etc/puppetlabs/puppet/common_events/processors.d')
      }
    end
  end
end
