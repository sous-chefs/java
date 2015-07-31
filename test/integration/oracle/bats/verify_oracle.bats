@test "installs the correct version of the jdk" {
  java -version 2>&1 | grep 1.6
}

@test "properly sets JAVA_HOME environment variable" {
  source /etc/profile.d/jdk.sh
  run test -d $JAVA_HOME
  [ "$status" -eq 0 ]
}

@test "properly links jar" {
  run test -L /usr/bin/jar
  [ "$status" -eq 0 ]
}

@test "properly installs JCE" {
  run java -jar /tmp/UnlimitedSupportJCETest.jar 
  [ "$output" = "isUnlimitedSupported=TRUE, strength: 2147483647" ]
}
