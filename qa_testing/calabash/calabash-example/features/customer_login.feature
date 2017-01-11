#language: en
#customer_login.feature

@Login
Feature: Login
As a cucumber course user I want to be able to log into the system in order to operate

Background: An existing user in the system
  Given the app is launched

  Scenario: Successful Log in
  When the customer enters telephone "600000006" and password "123456"
  Then the customer is successfully logged in

  Scenario: Unsuccessful Log in
  When the customer enters telephone "700000007" and password "123456"
  Then the customer should see "Wrong telephone or password"