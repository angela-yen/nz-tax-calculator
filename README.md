# README - NZ Tax Calculator

This app is designed as a simple yet effective New Zealand tax calculator, helping users estimate their tax amount based on their annual income.

## Prerequisites

Before running the app, ensure that you have the following software installed:

- **Ruby version**: 3.0.0
- **Rails version**: 7.0.3

## Setup

To install and set up this app, follow these steps:

1. Clone the repository to your local machine:
  `git clone https://github.com/angela-yen/nz-tax-calculator.git`
2. Navigate into the project directory:
  `cd nz-tax-calculator`
3. Install the required Ruby gems using Bundler:
  `bundle install`
4.	Start the Rails server:
  `bin/rails server`
5. 	Open your browser and go to http://localhost:3000 to use the app.

## Test Suite

Tests are written using RSpec.
- To run all tests: `bundle exec rspec`
- To run specific test: `bundle exec rspec path/to/test_file.rb`
- To run specific block of tests, specify line number e.g.: `bundle exec rspec path/to/test_file.rb:10`


## Development Process
1. Researched and made notes on current Tax calculate (pros & cons)
    - Pros:
      -- Printable
      -- Simple to use
      -- Specific criterias to match what the user needs
      -- Breakdown table
    - Cons:
      -- Too word
      -- Multiple pages, needing to go back and forwards between pages
    Cons:
2. Wrote out the expected requrirements:
    - Targeted users: Leads and Support Teams (internal tool)
    - Calculate the correct tax amount
    - Simple and user friendly
    - Test cases
3. Created a boiler plate RoR app
4. Created basic controller, views and routes to load the app
5. Wrote some sudo code to help understand how the tax is calculated
6. Wrote out initial logic into the code
7. Tested the code to ensure the calculated values were correct
8. Refactored the calculation methods to be more efficient and clean (DRY). Also refactored views out to seperate partitions. 
9. Added basic Tailwind CSS to make the UI more readible
10. Added Tax breakdown (not required, but it helped with understanding how the tax brackets worked)
11. Wrote RSpec Unit tests to ensure we covered the test cases and code is working as required
