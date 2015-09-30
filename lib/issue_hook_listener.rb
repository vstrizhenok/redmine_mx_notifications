class MxNotificationsIssueHelper
	def self.notify_users(context={}, messagePostfix)
                channelName = "channel_test";
                channel = ActsAsNotifiableRedmine::Notifications.find_by_id(channelName)
                eventName = 'event1'
                event = channel.events.select{|x| x.name == eventName.to_sym}.first

                issue = context[:issue]
                message = ""
                message << "Issue <a href=\"/issues/#{issue.id}\">#{issue.subject}</a> #{messagePostfix}<br/>"

                #context[:issue].subject += " - " + channel.token

                data = {}
                data[:title] = 'Issue modified'
                data[:message] = message
                data[:image]   = "<img class=\"gritter-image\" src=\"/plugin_assets/redmine_pusher_notifications/images/ok.png\">"

                channels = []
                issue.watchers.each do |watcher|
                        token = channelName + '-' + watcher.user.login
                        channels.push(token)
                        Rails.logger.info 'mx_notifications token ' + token
                end
                channels.push(channelName + '-' + issue.author.login)
                assigned = issue.assigned_to
                if (!assigned.nil?)
                        token = channelName + '-' + assigned.login
                        channels.push(token)
                end

                #channels.push(channel.token)
		 begin
                        #gflash :now, :success => { :value => data[:message], :sticky => event.sticky?, :image => data[:image] }
                        ActsAsNotifiableRedmine::Notifications.send_notification(channels, event.name, data)
                        @message = 'OK!'
                        @error   = false
                        Rails.logger.info 'mx_notifications ' + 'OK'
                rescue => e
                        @message = e.message
                        @error   = true
                        Rails.logger.info 'mx_notifications ' + e.message
                end
        end
end

class IssueHookListener < Redmine::Hook::ViewListener
	def controller_issues_new_before_save(context={})
		MxNotificationsIssueHelper.notify_users(context, "has been created")
	end
	
	def controller_issues_edit_before_save(context={})
		MxNotificationsIssueHelper.notify_users(context, "has been modified")
	end
end


