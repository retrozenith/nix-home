{ ... }:

{
  # Node Exporter - system metrics
  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    # port 9100 by default
    enabledCollectors = [
      "cpu"
      "diskstats"
      "filesystem"
      "loadavg"
      "meminfo"
      "netdev"
      "netstat"
      "stat"
      "time"
      "vmstat"
      "systemd"
      "processes"
      "hwmon"
      "thermal_zone"
    ];
  };

  # Prometheus - metrics collection
  services.prometheus = {
    enable = true;
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "localhost:9100" ];
        }];
      }
    ];
  };

  # Grafana - dashboards
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3000;
        http_addr = "0.0.0.0";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 9090 ];
}
