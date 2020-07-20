require 'openshift/project_resource'

module BushSlicer
  class EtcdCluster < ProjectResource
    RESOURCE = "etcdclusters.etcd.database.coreos.com"
  end
end
