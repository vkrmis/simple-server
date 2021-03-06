module AdminPage
  module Sessions
    class New < ApplicationPage
      EMAIL_TEXT_BOX = { id: 'admin_email' }
      PASSWORD_TEXT_BOX = { id: 'admin_password' }.freeze
      LOGIN_BUTTON = {css: 'input.btn.btn-primary'}.freeze
      REMEMBER_ME_CHECKBOX = { id: 'admin_remember_me' }.freeze
      FORGOT_PASSWORD_LINK = { xpath: "//a[@href='/admins/password/new']" }.freeze
      UNLOCK_INSTRUCTION_LINK = { xpath: "//a[@href='/admins/unlock/new']" }.freeze
      LOGIN_LINK = { css: '.nav-link'}.freeze
      ERROR_MESSAGE = { css: 'div.alert-warning' }.freeze
      MESSAGE_CROSS_BUTTON = { css: 'button.close'}.freeze
      SUCCESSFUL_LOGOUT_MESSAGE = { css: 'div.alert-primary'}.freeze

      def do_login(emailID, password)
        type(EMAIL_TEXT_BOX, emailID)
        type(PASSWORD_TEXT_BOX, password)
        click(LOGIN_BUTTON)
      end

      def set_email_text_box(emailId)
        type(EMAIL_TEXT_BOX, emailId)
      end

      def set_password_text_box(password)
        type(PASSWORD_TEXT_BOX, password)
      end

      def click_forgot_password_link
        click(FORGOT_PASSWORD_LINK)
      end

      def click_errormessage_cross_button
        click(MESSAGE_CROSS_BUTTON)
        not_present?(ERROR_MESSAGE)
      end

      def is_errormessage_present
        present?(ERROR_MESSAGE)
      end

      def is_successful_logout_message_present
        present?(SUCCESSFUL_LOGOUT_MESSAGE)
        present?(LOGIN_BUTTON)
      end

      def click_successful_message_cross_button
        click(MESSAGE_CROSS_BUTTON)
        not_present?(SUCCESSFUL_LOGOUT_MESSAGE)
      end
    end
  end
end
