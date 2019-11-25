Feature: basic verification for upgrade testing
  # @author geliu@redhat.com
  # @case_id OCP-26204
  @admin
  Scenario: upgrade automation test example upgrade-prepare
    Given I switch to cluster admin pseudo user
    When I run the :new_project client command with:
      | project_name | project-ocp26204 |
    Then the step should succeed
    When I run the :get client command with:
      | resource | project |
    Then the step should succeed
    And the output should contain:
      | project-ocp26204 |

  #@author geliu@redhat.com
  #@case_id OCP-26205
  @admin
  Scenario: upgrade automation test example upgrade-check
    Given I switch to cluster admin pseudo user
    Given I use the "project-ocp26204" project

  # @author geliu@redhat.com
  # @case_id OCP-22606
  @admin
  Scenario: etcd-operator and cluster works well after upgrade 
    Given I switch to cluster admin pseudo user
    When I run the :create client command with:
      | f | https://raw.githubusercontent.com/openshift-qe/v3-testfiles/master/admin/subscription.yaml |
    Then the step should succeed
    When I use the "openshift-operators" project
    Then status becomes :running of exactly 1 pods labeled:
      | name=etcd-operator-alm-owned |
    When I use the "default" project
    Given I download a file from "https://raw.githubusercontent.com/openshift-qe/v3-testfiles/master/admin/etcd-cluster.yaml"
    When I run the :create client command with:
      | f | etcd-cluster.yaml |
    Then the step should succeed
    Then status becomes :running of exactly 3 pods labeled:
      | etcd_cluster=example |
  
  # @author geliu@redhat.com
  # @case_id OCP-26195
  @admin
  Scenario: etcd-operator and cluster works well after upgrade(upgrade-check)
    Given I switch to cluster admin pseudo user
    When I use the "openshift-operators" project
    Then status becomes :running of exactly 1 pods labeled:
      | name=etcd-operator-alm-owned |
    When I use the "default" project
    Then status becomes :running of exactly 3 pods labeled:
      | etcd_cluster=example |

