# -*- coding: utf-8 -*-

=begin
$ # setup
$ defaults write com.apple.screencapture location ~/Dropbox/Public
$ killall SystemUIServer
=end

YOUR_DROPBOX_ID = 0000000


require 'fileutils'
require 'digest/md5'

include FileUtils

links = (ARGV || []).map {|p|
  dirname  = File.dirname p
  filename = File.basename p
  extname  = File.extname p

  next unless extname =~ /\A\.png\Z/i

  filename = "#{Digest::MD5.hexdigest(p + rand.to_s)}#{extname}"

  mv p, "#{dirname}/#{filename}"

  "http://dl.dropbox.com/u/#{YOUR_DROPBOX_ID}/#{filename}"
}.join("\n")


IO.popen('pbcopy', 'w').print links

begin
  require 'rubygems'
  require 'notify'
  Notify.notify('Copied!', links)
rescue LoadError
  system "which growlnotify >/dev/null 2>&1 && growlnotify -m '#{links}' -t 'Copied!'"
end

