require 'rspec'
require 'spec_helper'

  describe 'Create defined type', :type => :class do
    let(:param_str) {{
        :user     => 'govuk-backup',
        :env_path => '/etc/env_dir',
        :envname  => 's3_keys',
        :name     => 'aws_access_key',
        :envar    => 'ACCESS_KEY=IAMAKEY1983'
    }}

    let(:title) {'envdir'}

    context 'The following folders should be created' do

      it  { is_expected.to contain_file('/etc/env_dir/').with_ensure('directory') }
      it  { is_expected.to contain_file('/etc/env_dir/s3_keys').with({
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0775',
     })}
    end

    context 'This file should be present once the folders are in place'  do


      it  { is_expected.to contain_file('/etc/env_dir/s3_keys/aws_access_key').with({
        'ensure'  => 'file',
        'owner'   => 'govuk-backup',
        'group'   => 'govuk-backup',
        'content' => 'ACCESS_KEY=IAMAKEY1983',
        'mode'    => '0550',
     })}
    end


end