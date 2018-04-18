#!/bin/bash
# Copyright 2016 - 2018 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# remove any existing components of this example

source ${CCPROOT}/examples/common.sh
echo_info "Cleaning up.."

${CCP_CLI?} delete pod restore-pitr
${CCP_CLI?} delete service restore-pitr
cleanup_dir "restore-pitr"

${CCP_CLI?} delete service pitr
${CCP_CLI?} delete pod pitr
${CCP_CLI?} delete job backup-pitr

${CCP_CLI?} delete pvc pitr-pgdata pitr-pgwal backup-pitr-pgdata restore-pitr-pgdata recover-pvc
if [ -z "$CCP_STORAGE_CLASS" ]; then
  ${CCP_CLI?} delete pv pitr-pgdata pitr-pgwal backup-pitr-pgdata restore-pitr-pgdata recover-pv
fi

cleanup_dir "WAL/pitr"
cleanup_dir "pitr"
