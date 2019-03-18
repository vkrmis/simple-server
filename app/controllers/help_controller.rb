class HelpController < AdminController
  layout false

  def show
    skip_authorization
  end
end
