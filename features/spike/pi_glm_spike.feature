@manual @spike
Feature: Spike - Pi on GLM Coding Plan inside GitHub Agentic Workflows
  Prove the riskiest assumptions of option B in one run before building workers.
  Each scenario maps to one hypothesis in docs/spike.md.
  If H0, H1 or H2 fails on both routes, fall back to option A (plain Actions + pi CLI).

  @H0
  Scenario: The workflow compiles with the Pi engine on a Z.ai route
    Given ".github/workflows/spike-pi-glm.md" uses engine "pi" with a Z.ai base URL
    When I run "gh aw compile spike-pi-glm"
    Then compilation succeeds
    And the lock file does not route inference to Copilot

  @H1
  Scenario: Pi reaches the Z.ai endpoint through the firewall
    Given the repository secret "ZAI_API_KEY" holds a GLM Coding Plan key
    When I comment "/spike" on the test issue
    Then the firewall log shows allowed requests to "api.z.ai"
    And the firewall log shows no blocked inference request

  @H2
  Scenario: The GLM model answers and calls tools
    Given the repository secret "ZAI_API_KEY" holds a GLM Coding Plan key
    When I comment "/spike" on the test issue
    Then the agent log shows responses from a GLM model
    And the agent log shows at least one successful tool call

  @H3
  Scenario: Pi follows the vendored Clarity skill
    Given the repository contains ".agents/skills/clarity/SKILL.md"
    When I comment "/spike" on the test issue
    Then the agent log shows a read of ".agents/skills/clarity/references/interview.md"
    And the harness comment contains interview prompts and no article prose

  @H4
  Scenario: Prompts arrive as one issue comment
    Given the repository secret "ZAI_API_KEY" holds a GLM Coding Plan key
    When I comment "/spike" on the test issue
    Then the harness posts exactly one comment on the test issue

  @H5
  Scenario: Notes reach a draft pull request without local state
    Given the repository secret "ZAI_API_KEY" holds a GLM Coding Plan key
    When I comment "/spike" on the test issue
    Then a draft pull request opens with the title prefix "[spike] "
    And it adds only "spike/notes/<issue number>.md"

  @H6
  Scenario: The run fits the time and quota budget
    Given the repository secret "ZAI_API_KEY" holds a GLM Coding Plan key
    When I comment "/spike" on the test issue
    Then the run finishes within 15 minutes
    And the Z.ai usage page counts the calls against the Coding Plan quota
