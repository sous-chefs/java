# frozen_string_literal: true

name 'java'

cookbook 'java', path: '.'
cookbook 'test', path: 'test/fixtures/cookbooks/test'

run_list 'test::base'

named_run_list :base, 'test::base'
named_run_list :openjdk, 'test::openjdk'
named_run_list :openjdk_pkg, 'test::openjdk_pkg'
named_run_list :temurin_pkg, 'test::temurin_pkg'
named_run_list :corretto, 'test::corretto'
named_run_list :java_cert, 'test::java_cert'
