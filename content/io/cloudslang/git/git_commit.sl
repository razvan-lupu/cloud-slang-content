# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a git command to commit staged files to a local repository.
#
# Inputs:
#   - host - hostname or IP address
#   - port - optional - port number for running the command
#   - username - username to connect as
#   - password - optional - password of user
#   - sudo_user - optional - true or false, whether the command should execute using sudo - Default: false
#   - private_key_file - optional - absolute path to private key file
#   - git_repository_localdir - optional - target directory where a git repository exists - Default: /tmp/repo.git
#   - git_commit_files - optional - files to commit - Default: "-a"
#   - git_commit_message - optional - message for commit
# Outputs:
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - command - git command
####################################################
namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: git_commit

  inputs:
      - host
      - port:
          required: false
      - username
      - password:
          required: false
      - sudo_user:
          default: false
          required: false
      - private_key_file:
          required: false
      - git_repository_localdir: "/tmp/repo.git"
      - git_commit_files:
          default: "-a"
          required: false
      - git_commit_message:
          required: false

  workflow:
      - git_commit:
          do:
            ssh.ssh_flow:
              - host
              - port
              - username
              - password
              - private_key_file
              - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
              - git_files: ${ ' git commit ' + git_commit_files }
              - git_message: ${ ' -m ' + git_commit_message if git_commit_message else '' }
              - command: ${ sudo_command + 'cd ' + git_repository_localdir + ' && ' + git_files + git_message + ' && echo GIT_SUCCESS' }

          publish:
            - standard_err
            - standard_out
            - command

      - check_result:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${ standard_out }
              - string_to_find: "GIT_SUCCESS"

  outputs:
    - standard_err
    - standard_out
    - command
