require 'serverspec'
require 'yaml'

# properties = YAML.load_file('./yaml/properties.yml')
# set_property properties

set :backend, :exec
set :path, '/usr/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH'
