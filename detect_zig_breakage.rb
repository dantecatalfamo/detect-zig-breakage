#!/usr/bin/env ruby

class String
  def black = "\e[30m#{self}\e[0m"
  def red = "\e[31m#{self}\e[0m"
  def green = "\e[32m#{self}\e[0m"
  def brown = "\e[33m#{self}\e[0m"
  def blue = "\e[34m#{self}\e[0m"
  def magenta = "\e[35m#{self}\e[0m"
  def cyan = "\e[36m#{self}\e[0m"
  def gray = "\e[37m#{self}\e[0m"

  def bg_black = "\e[40m#{self}\e[0m"
  def bg_red = "\e[41m#{self}\e[0m"
  def bg_green = "\e[42m#{self}\e[0m"
  def bg_brown = "\e[43m#{self}\e[0m"
  def bg_blue = "\e[44m#{self}\e[0m"
  def bg_magenta = "\e[45m#{self}\e[0m"
  def bg_cyan = "\e[46m#{self}\e[0m"
  def bg_gray = "\e[47m#{self}\e[0m"

  def bold = "\e[1m#{self}\e[22m"
  def italic = "\e[3m#{self}\e[23m"
  def underline = "\e[4m#{self}\e[24m"
  def blink = "\e[5m#{self}\e[25m"
  def reverse_color = "\e[7m#{self}\e[27m"
  # https://stackoverflow.com/a/16363159
end

REPO_SITE = 'github.com'.freeze
REPO_USER = 'dantecatalfamo'.freeze

REPOS_ROOT = File.join(ENV['HOME'], 'src')
REPOS_DIR = File.join(REPOS_ROOT, REPO_SITE, REPO_USER)

repos = Dir.glob("#{REPOS_DIR}/*/")

working = []
broken = []

repos.each do |repo|
  next unless File.exist?(File.join(repo, 'build.zig'))

  Dir.chdir(repo) do |path|
    puts "===> Building #{path}".cyan.bold
    if system('zig build')
      working << path
    else
      broken << path
    end
  end
end

working_ratio = working.length.to_f * 100 / (working.length + broken.length)

puts
puts
puts "Working ratio: #{working.length}/#{working.length + broken.length} (#{working_ratio.round(2)}%)".bold

puts
puts 'Working:'
working.each do |path|
  puts "  - #{path.green.bold}"
end

puts
puts 'Broken:'
broken.each do |path|
  puts "  - #{path.red.bold}"
end
