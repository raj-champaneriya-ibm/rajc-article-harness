@REQ-DRF @worker-drafter @phase-1
Feature: Draft from my answers
  As the writer
  I want a draft built from what I said in the issue
  So that I edit my own thinking instead of generic prose

  Background:
    Given article issue #12 is at stage "interviewing"
    And I have answered the interview prompts on issue #12

  @REQ-DRF-01
  Scenario: The drafter opens a draft pull request
    When I comment "/draft"
    Then a draft pull request opens against "experiment/mobile-native"
    And its branch name starts with "article/12-"
    And the pull request links to issue #12
    And issue #12 moves to stage "drafted"

  @REQ-DRF-02
  Scenario: The draft lands where the site expects posts
    When I comment "/draft"
    Then the pull request adds one file under "hugo-site/content/blog/<year>/<month>/"
    And the file front matter has "draft: true"
    And the front matter has a title, date, tags, categories and summary

  @REQ-DRF-03
  Scenario: Gaps are marked instead of invented
    Given my answers give no example for the second section
    When I comment "/draft"
    Then the second section contains a "[TK: ...]" marker
    And the pull request description lists every open "[TK]" marker

  @REQ-DRF-04
  Scenario: The draft follows the voice guide
    Given "style/voice.md" says "Open with the business outcome"
    When I comment "/draft"
    Then the first paragraph of the draft states a business outcome

  @REQ-DRF-05
  Scenario: Provenance stays visible
    When I comment "/draft"
    Then the pull request description names the parts that came from my answers
    And it names the parts the model supplied
