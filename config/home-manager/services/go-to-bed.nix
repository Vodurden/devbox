{ inputs, config, lib, pkgs, ... }:

let
  schedule = { name, description, when, command }: {
    systemd.user.services."${name}" = {
      Unit = { Description = description; };

      Service = {
        Type = "oneshot";
        ExecStart = command;
      };
    };

    systemd.user.timers."${name}" = {
      Timer = {
        OnCalendar = when;
        Persistent = "true";
      };
      Unit = { Description = description; };
      Install = { WantedBy = ["timers.target"]; };
    };
  };

  warning = id: time: message: (schedule {
    name = "go-to-bed-warning-${id}";
    description = "Go to bed warning (${id})";
    command = ''
      ${pkgs.libnotify}/bin/notify-send \
        --urgency=critical \
        --expire-time=0 \
        "${message}"
    '';
    when = "*-*-* ${time}";
  });
in

lib.mkMerge [
  # Lets add some friction to staying on the computer after 9:00pm
  (warning "30m" "21:00:00" "Night is coming, 30 minutes until meltdown...")
  (warning "15m" "21:15:00" "Night moves closer, 15 minutes until meltdown...")
  (warning "1m" "21:28:00" "Impending doom, 2 minutes until meltdown!")
  (warning "0m" "21:29:00" "You were warned...")

  # Now for _more_ friction! After 9:30pm.
  (schedule {
    name = "go-to-bed-meltdown";
    description = "Go to bed meltdown";
    command = ''
      ${pkgs.libnotify}/bin/notify-send \
        --expire-time=2 \
        "SLEEP!"
    '';
    when = [
      "*-*-* 21:30..59:00/3" # 09:30pm - 10:00pm, every 3 seconds
      "*-*-* 22..23:*:00/3"  # 10:00pm - 23:59pm, every 3 seconds
    ];
  })
]
