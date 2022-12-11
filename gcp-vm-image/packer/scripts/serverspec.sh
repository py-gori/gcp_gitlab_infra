#!/bin/bash

# env
case "${role}" in
  "wordpress" )
    spec_type=wordpress ;;
  "gitlab" )
    spec_type=gitlab ;;
  "python-minimum" )
    spec_type=python-minimum ;;
esac

export PATH=$PATH:/usr/local/bin/

yum install rubygems build-essential -y
gem install net-ssh --version "=4.2.0"
gem install serverspec --version "=2.41.5"
gem install rake --version "=12.3.1"
cd /tmp/serverspec

count_error=0

rake spec:base | tee serverspec_base.tmp
result_failures_base=$(cat serverspec_base.tmp | grep "0 failures" | wc -l)
result_error_base=$(cat serverspec_base.tmp | grep "error" | grep "occurred outside of examples" | wc -l)
if [ "${result_failures_base}" -ne 1 ] || [ "${result_error_base}" -ne 0 ]; then
  count_error=$((count_error += 1))
fi

rake spec:${spec_type} | tee serverspec.tmp
result_failures=$(cat serverspec.tmp | grep "0 failures" | wc -l)
result_error=$(cat serverspec.tmp | grep "error" | grep "occurred outside of examples" | wc -l)
if [ "${result_failures}" -ne 1 ] || [ "${result_error}" -ne 0 ]; then
  count_error=$((count_error += 1))
fi


if [ "${count_error}" -ne 0 ]; then
  echo -e "\e[31mServerspec is failure\e[m"
  exit 1
else
  echo -e "\e[32mServerspec is success\e[m"
  rm -rf /tmp/serverspec
  exit 0
fi
