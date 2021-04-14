# @summary The ufw class
#
# The ufw class controls state of the ufw installation and service in the system.
# It also applies firewall rules.
#
# @example
#   class {'ufw':
#     manage_package => true,
#     package_name   => 'ufw',
#     packege_ensure => 'present',
#     manage_service => 'true',
#     service_name   => 'ufw',
#     service_ensure => 'running',
#     rules          => {
#         'sample rule'              => {
#           'ensure'         => 'present',
#           'action'         => 'allow',
#           'direction'      => 'out',
#           'interface'      => 'eth0',
#           'log'            => 'log',
#           'from_addr'      => '10.1.3.0/24',
#           'from_ports_app' => 3133,
#           'to_addr'        => '10.3.3.3',
#           'to_ports_app'   => 2122,
#         },
#     }
#   }
#
# @param [Boolean] manage_package
#   If the class should manage an ufw package.
# @param [String[1]] package_name
#   Ufw package to manage.
# @param [String[1]] packege_ensure
#   What state the package should be in.
# @param [Boolean] manage_service
#   If the module should manage the ufw service state.
# @param [Stdlib::Ensure::Service] service_ensure
#   Defines the state of the ufw service.
# @param [String[1]] service_name
#   The name of the ufw service to manage.
# @param [Hash[String[1], Hash]] rules
#   Rule definitions to apply.
# @param [Hash[String[1], Hash]] routes
#   Routing definitions to apply.
# @param [Boolean] manage_default_config
#   If the module should manage /etc/default/ufw. Default: true
# @param [String[1]] default_config_content
#   Configuration content to put to /etc/default/ufw. Default is taken from files/default of this module.
# @param [Boolean] manage_logrotate_config
#   If the module should manage /etc/logrotate.d/ufw. Default: true
# @param [String[1]] logrotate_config_content
#   Configuration content to put to /etc/logrotate.d/ufw. Default is taken from files/logrotate of this module.
# @param [Boolean] manage_rsyslog_config
#   If the module should manage /etc/rsyslog.d/20-ufw.conf. Default: true
# @param [String[1]] rsyslog_config_content
#   Configuration content to put to /etc/rsyslog.d/20-ufw.conf. Default is taken from files/ufw of this module.
# @param [Boolean] manage_sysctl_config
#   If the module should manage /etc/ufw/sysctl.conf. Default: true
# @param [String[1]] sysctl_config_content
#   Configuration content to put to /etc/ufw/sysctl.conf. Default is taken from files/sysctl of this module.
# @param [Boolean] manage_before_rules
#   Controls if the module should manage /etc/ufw/before.rules. Default: true
# @param [String[1]] before_rules_content
#   Configuration content to put to /etc/ufw/before.rules. Default is taken from files/before.rules of this module.
# @param [Boolean] manage_before6_rules
#   Controls if the module should manage /etc/ufw/before6.rules. Default: true
# @param [String[1]] before6_rules_content
#   Configuration content to put to /etc/ufw/before6.rules. Default is taken from files/before6.rules of this module.
# @param [Boolean] manage_after_rules
#   Controls if the module should manage /etc/ufw/after.rules. Default: true
# @param [String[1]] after_rules_content
#   Configuration content to put to /etc/ufw/after.rules. Default is taken from files/after.rules of this module.
# @param [Boolean] manage_after6_rules
#   Controls if the module should manage /etc/ufw/after6.rules. Default: true
# @param [String[1]] after6_rules_content
#   Configuration content to put to /etc/ufw/after6.rules. Default is taken from files/after6.rules of this module.
#
class ufw(
  Boolean                    $manage_package              = $ufw::params::manage_package,
  String[1]                  $package_name                = $ufw::params::package_name,
  String[1]                  $packege_ensure              = $ufw::params::package_ensure,
  Boolean                    $manage_service              = $ufw::params::manage_service,
  Stdlib::Ensure::Service    $service_ensure              = $ufw::params::service_ensure,
  String[1]                  $service_name                = $ufw::params::service_name,
  Hash[String[1], Hash]      $rules                       = $ufw::params::rules,
  Hash[String[1], Hash]      $routes                      = $ufw::params::routes,
  Boolean                    $manage_default_config       = $ufw::params::manage_default_config,
  String[1]                  $default_config_content      = $ufw::params::default_config_content,
  Boolean                    $manage_logrotate_config     = $ufw::params::manage_logrotate_config,
  String[1]                  $logrotate_config_content    = $ufw::params::logrotate_config_content,
  Boolean                    $manage_rsyslog_config       = $ufw::params::manage_rsyslog_config,
  String[1]                  $rsyslog_config_content      = $ufw::params::rsyslog_config_content,
  Boolean                    $manage_sysctl_config        = $ufw::params::manage_sysctl_config,
  String[1]                  $sysctl_config_content       = $ufw::params::sysctl_config_content,
  Boolean                    $manage_before_rules         = $ufw::params::manage_before_rules,
  String[1]                  $before_rules_content        = $ufw::params::before_rules_content,
  Boolean                    $manage_before6_rules        = $ufw::params::manage_before6_rules,
  String[1]                  $before6_rules_content       = $ufw::params::before6_rules_content,
  Boolean                    $manage_after_rules          = $ufw::params::manage_after_rules,
  String[1]                  $after_rules_content         = $ufw::params::after_rules_content,
  Boolean                    $manage_after6_rules         = $ufw::params::manage_after6_rules,
  String[1]                  $after6_rules_content        = $ufw::params::after6_rules_content,
) inherits ufw::params {
  include ::ufw::install
  include ::ufw::config
  include ::ufw::service

  $rules.each | $rule, $rule_values | {
    ufw_rule {$rule:
      * => $rule_values,
    }
  }

  $routes.each | $route, $route_values | {
    ufw_route {$route:
      * => $route_values,
    }
  }

  Class['ufw::install']
    -> Class['ufw::config']
    -> Class['ufw::service']
}
