@test "installs the correct version of the jdk" {
  java -version 2>&1 | grep 1.7
}

@test "properly sets JAVA_HOME environment variable" {
  source /etc/profile.d/jdk.sh
  run test -d $JAVA_HOME
  [ "$status" -eq 0 ]
}
