{ ... }:

{
  # Node Exporter - system metrics
  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    # port 9100 by default
    enabledCollectors = [
      # Standard collectors
      "arp"
      "bcache"
      "bonding"
      "btrfs"
      "conntrack"
      "cpu"
      "cpufreq"
      "diskstats"
      "dmi"
      "edac"
      "entropy"
      "fibrechannel"
      "filefd"
      "filesystem"
      "hwmon"
      "infiniband"
      "ipvs"
      "loadavg"
      "mdadm"
      "meminfo"
      "netclass"
      "netdev"
      "netstat"
      "nfs"
      "nfsd"
      "nvme"
      "powersupplyclass"
      "pressure"
      "rapl"
      "schedstat"
      "selinux"
      "sockstat"
      "softnet"
      "stat"
      "tapestats"
      "thermal_zone"
      "time"
      "timex"
      "udp_queues"
      "uname"
      "vmstat"
      "watchdog"
      "xfs"
      "zfs"

      # Extra collectors
      "buddyinfo"
      "cgroups"
      "cpu_vulnerabilities"
      "drm"
      "drbd"
      "interrupts"
      "ksmd"
      "lnstat"
      "logind"
      "meminfo_numa"
      "mountstats"
      "network_route"
      "pcidevice"
      "processes"
      "qdisc"
      "slabinfo"
      "softirqs"
      "swap"
      "systemd"
      "wifi"
      "zoneinfo"
    ];
  };

  # Run Node Exporter as root (required for privileged collectors)
  systemd.services.prometheus-node-exporter.serviceConfig = {
    User = "root";
    DynamicUser = false;
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
      {
        job_name = "caddy";
        static_configs = [{
          targets = [ "localhost:2019" ];
        }];
      }
    ];
  };

  # Loki - log aggregation
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server.http_listen_port = 3100;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore.store = "inmemory";
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };

      schema_config.configs = [{
        from = "2024-01-01";
        store = "tsdb";
        object_store = "filesystem";
        schema = "v13";
        index = {
          prefix = "index_";
          period = "24h";
        };
      }];

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/var/lib/loki/tsdb-index";
          cache_location = "/var/lib/loki/tsdb-cache";
        };
        filesystem.directory = "/var/lib/loki/chunks";
      };

      compactor = {
        working_directory = "/var/lib/loki/compactor";
        compaction_interval = "10m";
      };
    };
  };

  # Promtail - log shipper
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };

      positions.filename = "/var/lib/promtail/positions.yaml";

      clients = [{
        url = "http://localhost:3100/loki/api/v1/push";
      }];

      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "andromeda";
            };
          };
          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }
        {
          job_name = "caddy";
          static_configs = [{
            targets = [ "localhost" ];
            labels = {
              job = "caddy";
              host = "andromeda";
              __path__ = "/var/log/caddy/*.log";
            };
          }];
          pipeline_stages = [
            {
              json = {
                expressions = {
                  duration = "duration";
                  status = "status";
                };
              };
            }
            {
              labels = {
                duration = "";
                status = "";
              };
            }
          ];
        }
      ];
    };
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
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:9090";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://localhost:3100";
        }
      ];
    };
  };

  # Ensure promtail can read Caddy logs
  users.users.promtail.extraGroups = [ "caddy" ];
  
  # Ensure directories exist with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0750 caddy caddy -"
    "d /var/lib/promtail 0755 promtail promtail -"
  ];

  networking.firewall.allowedTCPPorts = [ 3000 9090 3100 ];
}
