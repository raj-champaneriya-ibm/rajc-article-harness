@REQ-STY @worker-style-learner @phase-2
Feature: Learn my voice from my edits
  As the writer
  I want my edits to teach the drafter how I write
  So that each draft needs less rework than the last

  @REQ-STY-01
  Scenario: Published edits become a voice guide proposal
    Given article #12 was published
    And I rewrote the drafter's opening before publishing
    When the style learner runs after the merge
    Then a pull request proposes changes to "style/voice.md"
    And each proposed rule cites the edit it came from

  @REQ-STY-02 @guard
  Scenario: Unapproved voice changes do not reach the drafter
    Given a voice guide pull request is still open
    When I comment "/draft" on another article issue
    Then the drafter uses "style/voice.md" from the default branch

  @REQ-STY-03 @guard
  Scenario: The style learner never copies facts between articles
    Given article #12 mentions a client migration
    When the style learner runs after the merge
    Then the proposed rules describe style, not content
    And no proposed rule names a client, number or date from article #12
