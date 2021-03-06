module Hello
  module Management
    class ConfirmEmailsController < ApplicationController
      dont_kick_people

      before_actions do
        all { sign_out! }
        only(:confirm) { @credential = ::EmailCredential.where(id: params[:id]).first }
      end

      # GET /hello/emails/1/confirm/:token
      def confirm
        business = Business::Management::ConfirmEmail.new(@credential)

        if business.confirm_with_token(params[:token])
          _sign_in
          flash[:notice] = business.success_message
          redirect_to profile_path
        else
          flash[:alert] = business.alert_message
          redirect_to expired_confirmation_token_emails_path
        end
      end

      # GET /hello/emails/expired_confirmation_token
      def expired_confirmation_token
        render 'hello/management/email_credentials/expired_confirmation_token'
      end

      private

      def _sign_in
        # In RSpec and Capybara (Rails 4.2):
        # when the user gets access, the session of the next request will assume the values it had before,
        # if before you were a guest, you will be redirected as a user, but the following request will be as a guest again
        # if before you were a user1, you will be redirected as a user2, but the following request will be as a user1 again
        access_token = sign_in!(@credential.user, 1.hour.from_now)
      end
    end
  end
end
