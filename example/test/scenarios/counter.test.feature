Feature: Counter increments smoke test

  Scenario: Set Up
    Given Build our app and trigger a frame
      And Verified that our counter starts at 0

  Scenario Outline: Check increments
    Given Counter value is not <value>
     When Tap the "+" icon
      And Trigger a frame
     Then Counter value is <value>

    Examples:
    | value |
    |     1 |
    |     2 |
    |     3 |
    |     4 |
    |     5 |
    |     6 |
    |     7 |
    |     8 |
    |     9 |
    |    10 |

  Scenario: Tear Down
    Given Counter value is 10
