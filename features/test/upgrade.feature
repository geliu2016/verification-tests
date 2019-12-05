Feature: basic verification for upgrade testing
  @upgrade-prepare
  @users=upuser1,upuser2
  Scenario: upgrade automation test example - prepare
    #Given I log the message> Hi Prepare!   
    # Given I switch to cluster admin pseudo user
    When I run the :new_project client command with:
      | project_name | project-ocp26204 |
    Then the step should succeed
    When I run the :get client command with:
      | resource | project |
    Then the step should succeed
    And the output should contain:
      | project-ocp26204 |

  #@author geliu@redhat.com
  #@case_id OCP-26204
  @upgrade-check
  @admin
  Scenario: upgrade automation test example
    Given I switch to cluster admin pseudo user
    Given I use the "project-ocp26204" project

