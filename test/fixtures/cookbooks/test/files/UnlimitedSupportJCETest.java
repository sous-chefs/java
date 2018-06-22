# Copyright [2014] [Kyle McGovern]

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;

public class UnlimitedSupportJCETest
{
   public static void main(final String[] args)
   {
   int strength = 0;
   try {
      strength = Cipher.getMaxAllowedKeyLength("AES");
   } catch (NoSuchAlgorithmException e) {
      System.out.println("isUnlimitedSupported=FALSE");
      return;
   }
   if ( strength > 128 ){
      System.out.printf("isUnlimitedSupported=TRUE, strength: %d%n", strength);
   } else {
      System.out.printf("isUnlimitedSupported=FALSE, strength: %d%n", strength);
      }
   }
}