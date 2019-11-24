Feature: etcd related features
	
  # @author geliu@redhat.com
  # @case_id OCP-24280
  @admin
  Scenario: Etcd basic verification
    Given I switch to cluster admin pseudo user
    When I use the "openshift-etcd" project  
    Given 3 pods become ready with labels:
      | k8s-app=etcd |               
    Given evaluation of `@pods[0].name` is stored in the :etcdpod clipboard  
    When I execute on the pod:
      | bash| -c | ETCDCTL_API=3 etcdctl --cert=$(find /etc/ssl/ -name *peer*crt) --key=$(find /etc/ssl/ -name *peer*key) --cacert=/etc/ssl/etcd/ca.crt member list |
    Then the output should contain 3 times:
      | , started, |

  # @author geliu@redhat.com
  # @case_id OCP-19980,OCP-19981,OCP-19982,OCP-19986,OCP-20141
  @admin
  Scenario: etcd operator subscription and destory
    Given I switch to cluster admin pseudo user
    Given I register clean-up steps:
    """
    And I run the :delete client command with:
      | object_type       | csv                             |
      | object_name_or_id | etcdoperator.v0.9.4-clusterwide |
      | n                 | openshift-operators             |
    """
    Given I register clean-up steps:
    """
    And I run the :delete client command with:
      | object_type       | subscriptions       |
      | object_name_or_id | etcd-9.2-test       |
      | n                 | openshift-operators |          
    """
    Given I register clean-up steps:
    """
    And I run the :delete client command with:
      | object_type       | etcdclusters.etcd.database.coreos.com |
      | object_name_or_id | example                               |
      | n                 | default                               |
    """
    Given I register clean-up steps:
    """
    And I run the :delete client command with:
      | object_type | pod                  |
      | l           | etcd_cluster=example |
      | n           | default              | 
    """
    When I run the :create client command with:
      | f | https://raw.githubusercontent.com/openshift-qe/v3-testfiles/master/admin/subscription.yaml |
    Then the step should succeed
    When I use the "openshift-operators" project
    And I wait for the steps to pass:
    """
    Then status becomes :running of exactly 1 pods labeled:
      | name=etcd-operator-alm-owned |
    """
    When I use the "default" project
    Given I download a file from "https://raw.githubusercontent.com/openshift-qe/v3-testfiles/master/admin/etcd-cluster.yaml"
    When I run the :create client command with:
      | f | etcd-cluster.yaml | 
    Then the step should succeed
    Given a pod becomes ready with labels:
      | etcd_cluster=example |
    And evaluation of `pod.name` is stored in the :pod1 clipboard
    And I wait for the steps to pass:
    """
    Then status becomes :running of exactly 3 pods labeled:
      | etcd_cluster=example |
    """
    Given I ensure "<%= cb.pod1 %>" pod is deleted
    And I wait for the steps to pass:
    """
    Then status becomes :running of exactly 3 pods labeled:
      | etcd_cluster=example |
    """
    When I replace lines in "etcd-cluster.yaml": 
      | size: 3 | size: 4 |
    Then I run the :apply client command with:
      | f | etcd-cluster.yaml |
    Then the step should succeed    
    And I wait for the steps to pass:
    """
    Then status becomes :running of exactly 4 pods labeled:
      | etcd_cluster=example |
    """
    When I replace lines in "etcd-cluster.yaml":
      | 3.2.13 | 3.2.3 |
    Then I run the :apply client command with:
      | f | etcd-cluster.yaml |
    Then the step should succeed
    And I wait for the steps to pass:
    """
    When I run the :get client command with:
      | resource | po   |
      | o        | yaml |
    Then the output should match:
      | version: 3.2.3 |
    """
