@REQ-RTR
Feature: Route each request to one worker
  As the writer
  I want every comment to start the right worker or none
  So that I can work from my phone without thinking about plumbing

  Rule: Gate 1 drops events in code before any model runs

    @REQ-RTR-01 @guard @phase-1
    Scenario: Comments from people without write access are ignored
      Given article issue #12 is at stage "idea"
      When a GitHub user without write access comments "/draft"
      Then no worker runs
      And no model is called

    @REQ-RTR-02 @guard @phase-1
    Scenario: The harness ignores its own comments
      Given article issue #12 is at stage "interviewing"
      When the harness posts a comment on issue #12
      Then no worker runs

    @REQ-RTR-03 @guard @phase-1
    Scenario: Issues without the article label are ignored
      Given issue #40 has no label "article"
      When I comment "/draft" on issue #40
      Then no worker runs

    @REQ-RTR-04 @phase-1
    Scenario: One worker at a time per article
      Given the drafter is running for issue #12
      When I comment "/review" on its pull request
      Then the reviewer starts after the drafter finishes

  Rule: Commands route through a fixed table without a model

    @REQ-RTR-05 @phase-1
    Scenario Outline: A command starts its worker
      Given article issue #12 is at stage "<stage>"
      When I comment "<command>"
      Then the <worker> runs
      And no model is used for routing

      Examples:
        | stage        | command    | worker      |
        | idea         | /interview | interviewer |
        | idea         | /draft     | drafter     |
        | interviewing | /interview | interviewer |
        | interviewing | /draft     | drafter     |
        | drafted      | /review    | reviewer    |
        | drafted      | /revise    | reviser     |

    @REQ-RTR-06 @guard @phase-1
    Scenario: A command not allowed at the current stage is explained
      Given article issue #12 is at stage "idea"
      When I comment "/review"
      Then no worker runs
      And the harness replies with the commands allowed at stage "idea"

  Rule: Gate 2 routes free text only to workers the stage allows

    @REQ-RTR-07 @phase-2
    Scenario: Free text picks an allowed worker
      Given article issue #12 is at stage "drafted"
      When I comment "the intro is too long, cut it"
      Then the reviser runs
      And the routing reason is recorded on issue #12

    @REQ-RTR-08 @phase-2
    Scenario: An unsure classification asks instead of acting
      Given article issue #12 is at stage "drafted"
      When I comment "not sure about the title"
      Then no worker runs
      And the harness asks whether I want "/review" or "/revise"

    @REQ-RTR-09 @guard @phase-2
    Scenario: Gate 2 cannot choose a worker outside the stage
      Given article issue #12 is at stage "idea"
      And the classifier suggests the reviser
      When the router checks the suggestion against the stage table
      Then no worker runs
