#!/usr/bin/env ruby

require 'io/console'

commit, branch = ARGV

hashes = `git rev-list #{commit}..HEAD`.split(/\n/)

puts 'fetching 1'
fetch = `git fetch`

puts 'fetching 2'
fetch = `git fetch`

puts 'fetching 3'
fetch = `git fetch`

puts 'resetting'
reset = `git reset --hard origin/#{branch}`

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
      puts 'Did you fix the merge conflicts and commit like you would for a normal cherry-pick? (y/n): '
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
the merge conflixts
