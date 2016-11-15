# End to End Test VM

This is the result of a spike by the Publishing Platform team into approaches
we can use to run end-to-end tests across the publishing platform.

This directory contains the resources to run end-to-end tests through a Vagrant
VM.

Note: This is the purely a proof on concept and is the product of copy+pasting
and hacking stuff together. Use carefully.

## Steps to run:

### 1. Start and Provision VM

`vagrant up --provision`

If you want to test any local changes of applications you can specify these in
this step by setting a variable of SYNC_LOCAL_APPS eg
`SYNC_LOCAL_APPS=publishing-api,specialist-publisher vagrant up --provision`

### 2. Setup, Seed and Start Applications

`vagrant ssh -c "/var/govuk/govuk-puppet/end-to-end-vm/set-up-apps.sh"`

### 3. Run the Tests

`vagrant ssh -c "d /var/govuk/publishing-e2e-tests;bundle exec rspec"
