class UsersController < ApplicationController

  def new
    if !logged_in?()
      if create_fake_user() # creates fake user w/ audiography, saves them, logs them in
        session[:s] = params[:s]
        redirect_to(current_user.audiography.get_url())
      else
        Log::log(nil, nil, Log::ERROR, nil, "Could not create new Playmary.")
        flash[:notice] = "Sorry, a new Playmary could not be created for you."
        redirect_to("/")
      end
    elsif current_user.audiography
      flash[:notice] = "You are already logged in."
      redirect_to(current_user.audiography.get_url())
    else # logged in but no audiography (!)
      flash[:notice] = "You are already logged in, but have no Playmary."
      redirect_to("/")
    end
  end

  def claim
    if logged_in? && current_user.fake == 1 && current_user.audiography
      @title = "Claim my Playmary"
      @audiography_url = current_user.audiography.get_url()
      if request.post?
        if User.email_available?(params[:user][:email]) && Audiography.url_title_available?(params[:audiography][:url_title])
          current_user.fake = 0
          current_user.email = params[:user][:email]
          current_user.password = params[:user][:password]
          current_user.audiography.url_title = params[:audiography][:url_title]

          if current_user.save() && current_user.audiography.save()
            Log::log(current_user, nil, Log::CLAIM, nil, "Success")
            flash[:notice] = "You have claimed your Playmary and logged in."
            redirect_to(current_user.audiography.get_url())
          else
            Log::log(current_user, nil, Log::CLAIM, nil, "Fail")
            flash[:notice] = "Sorry, your claim failed for some unfathomable reason."
          end
        else
          flash[:notice] = "Errors with the data you entered."
        end
      else
        @user_to_claim = current_user
      end
    else
      @title = "There is no Playmary to claim."
    end
  end
  
  def title_monitor
    text = CGI::unescape(Util::parse_js_response(request))
    if text.length > 0 && text.length < 50
      render(:partial => 'monitor_valid')
    else
      render(:partial => 'monitor_invalid')
    end
  end
  
  def address_monitor
    text = CGI::unescape(Util::parse_js_response(request))
    if text.length > 0 && text.match(/^\w+$/)
      if Audiography.url_title_available?(text)
        render(:partial => 'monitor_valid')
      else
        render(:partial => 'monitor_url_title_taken')
      end
    else
      render(:partial => 'monitor_invalid')
    end
  end
  
  def email_monitor
    text = CGI::unescape(Util::parse_js_response(request))    
    empty_str = text == ""
    valid_email = text =~ /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    valid = valid_email

    if valid_email
      if User.find_user(text)
        render(:partial => 'monitor_existing_user')
      else
        render(:partial => 'monitor_valid')
      end
    else
      render(:partial => 'monitor_invalid')
    end
  end
  
  def password_monitor()
    text = CGI::unescape(Util::parse_js_response(request))
    if text.length > 0 && text.length < 101
      render(:partial => 'monitor_valid')
    else
      render(:partial => 'monitor_invalid')
    end
  end
end