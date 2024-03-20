!#/usr/bin/env ruby

require 'io/console'

commit, comment1, comment2 = ARGV

if commit == nil || commit.empty? || commit.length > 50
  throw "Commit message is too long: #{commit.length} characters"
end

hashes = `git rev-list #{commit}..HEAD`.split(/\n/)

puts "Throwing #{hashes.length} newer commits away"
reset_hard = `git reset --hard HEAD~#{hashes.length}`

puts 'Removing the target commit'
reset_soft = `git reset --hard HEAD^`

puts 'Putting them back'

hashes.reverse.each_with_index do |hash, index|
  step = index + 1

  puts '-' * 20
  puts "Step #{step} / #{hashes.count}"

  result = `git cherry-pick #{hash}`

  got_conflict = false

  if result.include? 'CONFLICT (content): Merge conflict'
    got_conflict = true

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
