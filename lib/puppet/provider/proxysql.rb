class Puppet::Provider::Proxysql < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # Make sure we find mysql commands on CentOS and FreeBSD
  ENV['PATH'] = ENV['PATH'] + ':/usr/libexec:/usr/local/libexec:/usr/local/bin'

  commands mysql: 'mysql'

  # Optional defaults file
  def self.defaults_file
    mycnf_path = File.read("#{Facter.value(:root_home)}/.proxysql_path_mycnf")
    "--defaults-extra-file=#{mycnf_path}" if File.file?("#{mycnf_path}")
  end

  def defaults_file
    self.class.defaults_file
  end

  def make_sql_value(value)
    if value.nil?
      'NULL'
    elsif value == 'NULL'
      'NULL'
    elsif value.is_a? Integer
      value.to_s
    else
      "'#{value}'"
    end
  end
end
