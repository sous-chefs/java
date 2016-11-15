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

@test "install java certificate" {
  source /etc/profile.d/jdk.sh
  run $JAVA_HOME/bin/keytool -list -storepass changeit -keystore $JAVA_HOME/jre/lib/security/cacerts -alias java_certificate_test
  [ "${lines[1]}" = "Certificate fingerprint (MD5): D4:5B:B9:3E:BB:B4:64:4D:E4:A1:78:15:C4:EE:A8:DF" ]
}
