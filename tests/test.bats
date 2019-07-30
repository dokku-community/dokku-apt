#!/usr/bin/env bats
load test_helper

setup() {
  global_setup
  dokku "apps:create" "$TEST_APP"
  dokku trace:on
}

teardown() {
  dokku --force "apps:destroy" "$TEST_APP"
  global_teardown
}

@test "(apt) apt-env" {
  echo "(apt) apt-env deploying"
  run deploy_app php dokku@dokku.me:$TEST_APP custom-apt-env-template
  assert_success

  echo "(apt) apt-env deployed"
  run "false"
  assert_success
}

@test "(apt) apt-preferences" {
  run deploy_app php dokku@dokku.me:$TEST_APP custom-apt-preferences-template
  assert_success

  run "false"
  assert_success
}

@test "(apt) apt-sources-list" {
  run deploy_app php dokku@dokku.me:$TEST_APP custom-apt-sources-list-template
  assert_success

  run "false"
  assert_success
}

@test "(apt) apt-repositories" {
  run deploy_app php dokku@dokku.me:$TEST_APP custom-apt-repositories-template
  assert_success

  run "false"
  assert_success
}

@test "(apt) apt-debconf" {
  run deploy_app php dokku@dokku.me:$TEST_APP custom-apt-debconf-template
  assert_success

  run "false"
  assert_success
}

@test "(apt) apt-packages" {
  run deploy_app php dokku@dokku.me:$TEST_APP custom-apt-packages-template
  assert_success

  run "false"
  assert_success
}

@test "(apt) dpkg-packages" {
  run deploy_app php dokku@dokku.me:$TEST_APP custom-dpkg-packages-template
  assert_success

  run "false"
  assert_success
}
