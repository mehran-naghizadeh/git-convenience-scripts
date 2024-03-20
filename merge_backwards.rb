!#/usr/bin/env ruby

require 'io/console'

def pause(message = nil)
  puts message unless message.nil?

  puts 'Press any key to continue...'
  choice = STDIN.getch
end

commit, steps, commit_message = ARGV

steps = [2, steps.to_i].max

newer_commits = `git rev-list #{commit}..HEAD`.split(/\n/)

`git reset --hard HEAD~#{newer_commits.length}`

(1...steps).each do
  `git reset --soft HEAD^`
end

result = `git log -1 --oneline`
hash, *original_commit_message_parts = result.split(' ')

`git reset --soft HEAD^`

commit_message = original_commit_message_parts.join(' ') if commit_message.nil?

`git commit -m "#{commit_message}"`

newer_commits.reverse.each do |hash|
  `git cherry-pick #{hash}`
end
