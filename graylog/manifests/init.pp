class graylog {
exec {'yum update -y':
path => '/usr/bin',
}
service {'firewalld.service':
ensure => running,
}
package {'java-1.8.0-openjdk-headless.x86_64':
ensure => present,
}
package {'epel-release':
ensure => present,
}
package{'pwgen':
ensure => present,
}
file {'/etc/yum.repos.d/mongodb-org-3.2.repo':
ensure => present,
source => "puppet:///modules/graylog/mongodbrepo", 
}
package {'mongodb-org':
ensure => present,
}
exec {'chkconfig --add mongod':
path => '/sbin',
}
exec {'systemctl daemon-reload':
path => '/bin',
}
exec {'systemctl enable mongod.service':
path => '/bin',
}
service {'mongod.service':
ensure => running,
hasrestart => true,
}
exec {'rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch':
path => '/bin',
}
file {'/etc/yum.repos.d/elasticsearch.repo':
ensure => present,
source => 'puppet:///modules/graylog/elasticsearch',
}
package {'elasticsearch':
ensure => present,
}
file {'/etc/elasticsearch/elasticsearch.yml':
ensure => present,
source => 'puppet:///modules/graylog/elasticsearch.yml',
}
exec {'chkconfig --add elasticsearch':
path => '/sbin',
}
exec {'systemctl enable elasticsearch.service':
path => '/bin',
}
service {'elasticsearch.service':
ensure => running,
hasrestart => true,
}
exec {'rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.rpm && touch /tmp/flaggraylogrepo':
path => '/bin',
creates => '/tmp/flaggraylogrepo',
}
package {'graylog-server':
ensure => present,
}
file {'/etc/graylog/server/server.conf':
ensure => present,
source => 'puppet:///modules/graylog/server.conf',
}
exec {'chkconfig --add graylog-server':
path => '/sbin',
}
exec {'systemctl enable graylog-server.service':
path => '/bin',
}
service {'graylog-server.service':
ensure => running,
hasrestart => true,
}
exec {'firewall-cmd --permanent --zone=public --add-port=9000/tcp':
path => '/bin',
}
exec {'firewall-cmd --permanent --zone=public --add-port=12900/tcp':
path => '/bin',
}
exec {'firewall-cmd --permanent --zone=public --add-port=1514/tcp':
path => '/bin',
}
exec {'firewall-cmd --reload':
path => '/bin',
}
package {'policycoreutils-python':
ensure => present,
}
exec {'setsebool -P httpd_can_network_connect 1':
path => '/sbin',
}
exec {'semanage port -a -t mongod_port_t -p tcp 27017 && touch /tmp/flagfile1':
path => '/sbin',
creates => '/tmp/flagfile1',
}
exec {'semanage port -a -t http_port_t -p tcp 9200 && touch /tmp/flagfile2':
path => '/sbin',
creates => '/tmp/flagfile2',
}
exec {'semanage port -a -t http_port_t -p tcp 9000 && touch /tmp/flagfile3':
path => '/sbin',
creates => '/tmp/flagfile3',
}
}
