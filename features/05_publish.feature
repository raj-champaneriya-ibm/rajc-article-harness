@REQ-PUB @worker-publisher @phase-1
Feature: Publish a finished article
  As the writer
  I want one explicit action to publish
  So that nothing reaches rajc.work by accident

  Background:
    Given article issue #12 is at stage "drafted"
    And its draft pull request is open

  @REQ-PUB-01
  Scenario: The ready label publishes the article
    Given the draft has no open "[TK]" markers
    When I add the label "ready-to-publish" to the pull request
    Then the front matter changes to "draft: false"
    And the pull request merges into "experiment/mobile-native"
    And the site deployment workflow starts
    And issue #12 closes with a link to the live article

  @REQ-PUB-02 @guard
  Scenario: Open TK markers block publishing
    Given the draft still contains "[TK: which client?]"
    When I add the label "ready-to-publish" to the pull request
    Then the pull request stays open
    And the harness comments with the list of open "[TK]" markers
    And the label "ready-to-publish" is removed

  @REQ-PUB-03 @guard
  Scenario: Free text never publishes
    When I comment "looks good, ship it" on the pull request
    Then the pull request stays open
    And the harness replies that publishing needs the "ready-to-publish" label

  @REQ-PUB-04 @guard
  Scenario: Publishing uses no model
    Given the draft has no open "[TK]" markers
    When I add the label "ready-to-publish" to the pull request
    Then the publish run makes no model call
