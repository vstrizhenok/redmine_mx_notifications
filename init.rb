require_dependency 'issue_hook_listener'

Redmine::Plugin.register :mx_notifications do
  name 'Mx Notifications plugin'
  author 'Vitaly Strizhenok'
  description 'This is a plugin for pusher notifications'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
