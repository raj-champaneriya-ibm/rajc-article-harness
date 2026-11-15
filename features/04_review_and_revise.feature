@REQ-REV @phase-1
Feature: Review and revise the draft
  As the writer
  I want feedback and revisions on the same pull request
  So that the article matures in small steps whenever I have a few minutes

  Background:
    Given article issue #12 is at stage "drafted"
    And its draft pull request is open

  Rule: Review gives feedback and never edits

    @REQ-REV-01 @worker-reviewer
    Scenario: The reviewer leaves feedback on the pull request
      When I comment "/review" on the pull request
      Then the harness posts review comments on specific lines
      And it posts one overall diagnosis
      And no commit is added to the article branch

    @REQ-REV-02 @worker-reviewer
    Scenario: Feedback separates errors from taste
      When I comment "/review" on the pull request
      Then each review comment is labelled "error", "improvement" or "taste"
      And each review comment quotes only enough text to locate the issue

  Rule: Revision changes the draft on the same branch

    @REQ-REV-03 @worker-reviser
    Scenario: A revision pushes to the existing pull request
      When I comment "/revise tighten the opening" on the pull request
      Then one new commit is added to the article branch
      And no new pull request is opened
      And the front matter still has "draft: true"

    @REQ-REV-04 @worker-reviser
    Scenario: A reply in a review thread revises only that passage
      Given the reviewer left a comment on the opening paragraph
      When I reply "yes, cut the second sentence" in that review thread
      Then the new commit changes only the opening paragraph
      And the harness resolves that review thread

    @REQ-REV-05 @worker-reviser
    Scenario: My own edits survive the next revision
      Given I edited the draft directly on GitHub
      When I comment "/revise" on the pull request
      Then the revision starts from my edited version
