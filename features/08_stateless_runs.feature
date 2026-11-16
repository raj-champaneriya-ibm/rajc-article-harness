@manual @REQ-STL @phase-1
Feature: Workers keep no state between runs
  GitHub holds the conversation, the draft and the voice guide.
  Each worker run starts from a fresh checkout and keeps nothing on the runner.
  This replaces the local worktree that made rajc-mate lose and desync changes.

  @REQ-STL-01
  Scenario: A worker starts from the latest article branch
    Given the article branch for issue #12 has a commit I made on GitHub
    When the reviser runs on a fresh runner
    Then the reviser reads the draft that includes my commit

  @REQ-STL-02
  Scenario: A content change always reaches GitHub
    Given the drafter produced a draft for issue #12
    When the drafter run finishes
    Then the draft exists on the remote article branch
    And nothing from the run is kept on the runner

  @REQ-STL-03
  Scenario: A failed run leaves no partial draft
    Given the drafter fails before it finishes
    When the drafter run ends
    Then the article branch has no new commit
    And the harness comments on issue #12 with a link to the failed run

  @REQ-STL-04 @guard
  Scenario: Workers write to GitHub only through declared outputs
    Given a worker run for issue #12
    When the worker tries to push with git directly
    Then the push is refused
    And only the outputs declared in the workflow reach the repository
