#language: en
#login_screen.rb

class LoginScreen < BaseScreen

  trait(:trait)                    { "* id:'#{login_button}'" }

  element(:telephone_field)        { 'telephoneET' }
  element(:password_field)         { 'passwordET' }
  element(:login_button)           { 'loginBtn' }

  value(:not_logged_in?)           { element_exists("* id:'#{login_button}'") }

  action(:touch_telephone_field)   { touch("android.widget.EditText id:'#{telephone_field}'") }
  action(:touch_password_field)    { touch("android.widget.EditText id:'#{password_field}'") }
  action(:touch_login_button)      { touch("android.widget.Button id:'#{login_button}'") }

  def login_with(username, password)  
    await
    touch_telephone_field
    keyboard_enter_text(username)
    touch_password_field
    keyboard_enter_text(password)
    touch_login_button   
  end

end