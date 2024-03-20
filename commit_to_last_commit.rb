#!/usr/bin/env ruby

require 'io/console'

commit_message_subject = `git log -1 --pretty=%s`.strip
commit_message_body = `git log -1 --pretty=%b`.strip

messages = [commit_message_subject]
messages << commit_message_body unless commit_message_body.length.zero?
messages = messages.map {|m| '-m "' + m + '"'}
message = messages.join()

loop do
  puts 'Have you already staged the desired changes? (y/n)'
  choice = STDIN.getch
  break if choice === 'y'
end

`git reset --soft HEAD^`
`git commit #{message}`
