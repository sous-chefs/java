@test "installs the correct version of the jdk" {
  # When:
  run java -version 2>&1

  # Then:
  [[ "${lines[0]}" =~ $(echo 'java version "1\.8\.[0-9_]+"') ]] && true || false
}

@test "installs JAVA 8" {
  # When:
  run /usr/libexec/java_home -v '1.8*' > /dev/null 2>&1

  # Then:
  [ "$status" -eq 0 ]
}

@test "does not install JAVA 7" {
  # When:
  run /usr/libexec/java_home -v '1.7*' > /dev/null 2>&1

  # Then:
  [ "$status" -eq 2 ]
}

@test "enables JAVA_HOME to be properly set with the java_home util" {
  # When:
  run /usr/libexec/java_home -v '1.8*'

  # Then:
  [ -n "$output" ]
}

@test "properly links jar" {
  # Expect:
  [ -L /usr/bin/jar ]
}

@test "does not installs JCE" {
  # When:
  run java -jar /tmp/UnlimitedSupportJCETest.jar

  # Then:
  [ "$output" = "isUnlimitedSupported=FALSE, strength: 128" ]
}
