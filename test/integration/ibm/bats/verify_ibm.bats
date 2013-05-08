@test "check for IBM java in $JAVA_HOME" {
  $JAVA_HOME/bin/java -version 2>&1 | grep IBM
}
