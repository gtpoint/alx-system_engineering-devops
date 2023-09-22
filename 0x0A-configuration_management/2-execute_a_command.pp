# 2-execute_a_command.pp

exec { 'kill_killmenow':
  command     => 'pkill -f killmenow',
  refreshonly => true,
  onlyif      => 'pgrep -f killmenow',
}
