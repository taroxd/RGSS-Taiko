# encoding: utf-8

unless $TEST
  Win32API.new('kernel32', 'AllocConsole', 'v', 'v').call
  $stdout = File.open('CONOUT$', 'w')
  $stdin  = File.open('CONIN$')
  $TEST = true
end
