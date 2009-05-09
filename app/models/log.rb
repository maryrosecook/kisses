class Log < ActiveRecord::Base #nt
  belongs_to :user
  
  CLAIM = "claim"
  SIGN_UP = "sign_up"
  ERROR = "error"
  EVENT = "event"
  API_UNKNOWN_FAIL = "api_unknown_fail"
  API_TIMEOUT = "api_timeout"
  OUT_OF_TIME = "out_of_time"
  LOCATION_GRAB = "location_grab"
  
  EMAIL_ABOUT = [SIGN_UP, CLAIM, ERROR, OUT_OF_TIME]
  
  DO_LOG = true
  DO_NOT_LOG = false
  
  def self.log(user, item, event, exception, message)
    if Linking.production?
      log = Log.new()
      log.user_id = user.id unless !user
      log.item_id = item.id unless !item
      log.item_class = item.class unless !item
      log.event = event
      log.exception_backtrace = exception.backtrace unless !exception
      log.exception_message = exception.message unless !exception
      log.message = message unless !message
      log.time = Time.new()
      log.save()
    
      if EMAIL_ABOUT.include?(log.event)
        Mailing::deliver_log_email(log)
      end
    end
  end
  
  def self.get_all_logs(offset, limit)
    self.find(:all, :order => 'time DESC', :offset => offset, :limit => limit)
  end
end