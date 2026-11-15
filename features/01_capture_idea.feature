@manual @REQ-CAP @phase-1
Feature: Capture an article idea from anywhere
  As the writer
  I want to drop a rough idea into a GitHub issue from my phone
  So that it waits in one place until I am ready to work on it

  @REQ-CAP-01
  Scenario: A new idea starts at the idea stage
    Given I open an issue from the "Article idea" template
    When the issue is created
    Then the issue carries the label "article"
    And the issue carries the label "stage:idea"

  @REQ-CAP-02
  Scenario: Capturing an idea starts no worker
    Given I open an issue from the "Article idea" template
    When the issue is created
    Then no worker runs
    And the issue has no comment from the harness
