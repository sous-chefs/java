@test "installs the correct version of the jdk" {
  java -version 2>&1 | grep 1.7
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

@test "install java certificate" {
  source /etc/profile.d/jdk.sh
  run $JAVA_HOME/bin/keytool -list -storepass changeit -keystore $JAVA_HOME/jre/lib/security/cacerts -alias java_certificate_test
  [ "${lines[1]}" = "Certificate fingerprint (SHA1): 9D:9E:EA:E6:5F:D2:C8:34:93:6E:5C:65:EE:00:46:A9:CD:E4:F1:83" ]
}
