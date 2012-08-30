Feature: json responses
  As a scraper
  When a get request is made with a url and limit parameter
  I should return a valid json response

  Scenario: response with a failed status
    When I make a GET request to scraper with "invalid.html"
    And I should see the following json response:
    """
      {
        "status": "fail"
      }
    """

  Scenario: valid response with title, description and images
    When I make a GET request to scraper with "valid.html"
    Then I should see the following json response:
    """
      {
       "images": ["/s3.amazonaws.com/images/valid.png"],
       "title": "Valid Title",
       "description": "valid description",
       "status": "ok"
      }
    """

  Scenario: valid response with title, description and images limited by the parameter
    When I make a GET request to scraper with "multiple_images.html" and a limit of 2
    Then I should see the following json response:
    """
      {
       "images": ["/s3.amazonaws.com/images/valid.png", "/s3.amazonaws.com/images/valid_01.png"],
       "title": "Valid Title",
       "description": "valid description",
       "status": "ok"
      }
    """
