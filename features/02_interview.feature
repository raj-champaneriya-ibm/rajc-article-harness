@REQ-INT @worker-interviewer @phase-1
Feature: Interview before drafting
  As the writer
  I want the harness to ask me questions before it writes anything
  So that the article carries my experience instead of invented detail

  Background:
    Given article issue #12 is titled "Why stateless agents beat long-lived sessions"

  @REQ-INT-01
  Scenario: The interviewer asks for my own material
    Given issue #12 is at stage "idea"
    When I comment "/interview"
    Then the harness posts one comment on issue #12
    And the comment asks me for one unorganised take on the idea
    And the comment offers at most 7 prompts
    And every prompt asks for something only I can supply
    And issue #12 moves to stage "interviewing"

  @REQ-INT-02
  Scenario: The interviewer writes no article prose
    Given issue #12 is at stage "idea"
    When I comment "/interview"
    Then no pull request is opened
    And no branch changes

  @REQ-INT-03
  Scenario: Follow-up questions cover only what my answers left open
    Given issue #12 is at stage "interviewing"
    And I have described the reader and the outcome in my answers
    When I comment "/interview"
    Then the new prompts do not ask about the reader or the outcome
    And the new prompts ask at most 3 questions
