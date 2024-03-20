#!/usr/bin/env ruby

require 'io/console'

commit, supplied_commit_message = ARGV

if commit == nil || commit.empty?
  throw 'You should provide a commit hash'
end

def revert(hash, newer_commits_hashes)
  `git reset HEAD --`
  `git cherry-pick #{hash}`
  put_commits_back(newer_commits_hashes)
end

def put_commits_back(hashes)
  puts 'Putting them back'

  hashes.reverse.each_with_index do |hash, index|
    step = index + 1

    puts '-' * 20
    puts "Step #{step} / #{hashes.count}"

    result = `git cherry-pick #{hash}`

    got_conflict = result.include? 'CONFLICT (content): Merge conflict'

    if got_conflict
      puts '... Waiting for you to fix the conflict ...'

      loop do
        puts 'Did you fix it? (y/n): '
        choice = STDIN.getch
        break if choice == 'y'
      end
    end

    print 'Done '

    break if step == hashes.count

    puts
  end
end

newer_commits_hashes = `git rev-list #{commit}..HEAD`.split(/\n/)

puts "Throwing #{newer_commits_hashes.length} newer commits away"
reset_hard = `git reset --hard HEAD~#{newer_commits_hashes.length}`
puts

result = `git log -1 --oneline`
hash, *original_commit_message_parts = result.split(' ')

commit_message = supplied_commit_message
commit_message = original_commit_message_parts.join(' ') if commit_message.nil? || commit_message.empty?

puts 'Opening the target commit'
reset_soft = `git reset --soft HEAD^`

puts 'Please make your edits and press'
puts ' C to commit and continue'
puts ' E to continue without commiting'
puts ' R to revert'

loop do
  choice = STDIN.getch
  if choice.downcase == 'c'
    `git commit -m "#{commit_message}"`
    put_commits_back(newer_commits_hashes)
    break
  elsif choice.downcase == 'e'
    `git reset HEAD --`
    put_commits_back(newer_commits_hashes)
    break
  elsif choice.downcase == 'r'
    revert(hash, newer_commits_hashes)
    break
  end
end
