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
  deploy_app php dokku@dokku.me:$TEST_APP custom-apt-env-template

  echo "(apt) apt-env deployed"
  run "false"
  assert_success
}

@test "(apt) apt-preferences" {
  deploy_app php dokku@dokku.me:$TEST_APP custom-apt-preferences-template

  run "false"
  assert_success
}

@test "(apt) apt-sources-list" {
  deploy_app php dokku@dokku.me:$TEST_APP custom-apt-sources-list-template

  run "false"
  assert_success
}

@test "(apt) apt-repositories" {
  deploy_app php dokku@dokku.me:$TEST_APP custom-apt-repositories-template

  run "false"
  assert_success
}

@test "(apt) apt-debconf" {
  deploy_app php dokku@dokku.me:$TEST_APP custom-apt-debconf-template

  run "false"
  assert_success
}

@test "(apt) apt-packages" {
  deploy_app php dokku@dokku.me:$TEST_APP custom-apt-packages-template

  run "false"
  assert_success
}

@test "(apt) dpkg-packages" {
  deploy_app php dokku@dokku.me:$TEST_APP custom-dpkg-packages-template

  run "false"
  assert_success
}
