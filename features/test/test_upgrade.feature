Feature: basic verification for upgrade testing

  # note that upuser1 and 2 need to be defined for the environement
  # @author somebody@redhat.com
  @upgrade-prepare
  @users=upuser1,upuser2
  # @case_id OCP-10017
  Scenario: cakephp example works well after migrate
    When I run the :new_project client command with:
      | project_name | project-ocp10017 |
    Then the step should succeed		    
    When I run the :get client command with:
      | resource | project |
    Then the step should succeed
    And the output should contain:  
      | project-ocp10017 |


  @upgrade-check
  @users=upuser1,upuser2
  @case_id OCP-10017
  Scenario: cakephp example works well after migrate
    Given I use the "project-ocp10017" project
  # check MySQL pod

