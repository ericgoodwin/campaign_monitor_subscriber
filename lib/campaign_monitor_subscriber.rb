module CampaignMonitorSubscriber

  def self.included(base)
    base.extend ClassMethods  
  end

  module ClassMethods
    def belongs_to_mailinglist
      
      include CampaignMonitorSubscriber::InstanceMethods
      
      after_create  :add_to_mailinglist
      after_destroy :remove_from_mailinglist
    end

  end
  
  module InstanceMethods
    
    def add_to_mailinglist
      return unless email.present?
      begin
        s = Campaigning::Subscriber.new email, login
        s.add! ::CAMPAIGN_MONITOR_LIST_ID
      rescue
      end
    end
    
    def remove_from_mailinglist
      return unless email.present?
      begin
        Campaigning::Subscriber.unsubscribe! email, ::CAMPAIGN_MONITOR_LIST_ID
      rescue
      end
    end
    
  end
  
end

ActiveRecord::Base.extend(CampaignMonitorSubscriber)