property :java_home_mode, String,
          default: '0755',
          description: 'The permission for the Java home directory'

property :java_home_owner, String,
          default: 'root',
          description: 'Owner of the Java Home'

property :java_home_group, String,
          default: lazy { node['root_group'] },
          description: 'Group for the Java Home'
