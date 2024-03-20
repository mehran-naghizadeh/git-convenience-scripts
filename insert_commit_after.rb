!#/usr/bin/env ruby

require 'io/console'

commit, insert_commit = ARGV

if commit.nil? || insert_commit.nil?
  throw 'Yo should provide two commit hashes'
end

hashes = `git rev-list #{commit}..HEAD`.split(/\n/)
hashes << insert_commit

puts 'resetting'
reset = `git reset --hard HEAD~#{hashes.length}`

hashes.reverse.each_with_index do |hash, index|
  step = index + 1

  puts '-' * 20
  puts "Step #{step} / #{hashes.count}"

  got_conflict = false
  result = `git cherry-pick #{hash}`

  if result.include? 'CONFLICT (content): Merge conflict'
    got_conflict = true

    puts '... Waiting for you to fix the conflict ...'

    loop do
      puts 'Did you fix it? (y/n): '
      choice = STDIN.getch
      break if choice == 'y'
    end
  elsif result.include? '(use "git cherry-pick --skip" to skip this patch)'
    puts 'Skipping it'
    skip = `git cherry-pick --skip`
  end

  print 'Done '

  break if step == hashes.count

  puts
end
