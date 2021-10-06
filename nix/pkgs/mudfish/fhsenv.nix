{ lib, buildFHSUserEnvBubblewrap, writeScript, mudfish }:

# Needs https://github.com/NixOS/nixpkgs/pull/128126 to be merged into nixpkgs
buildFHSUserEnvBubblewrap rec {
  name = "mudfish";
  targetPkgs = pkgs: [ mudfish ];
  runScript = writeScript "mudfish-wrapper.sh" ''
    mkdir -p /opt/mudfish/${mudfish.version}/{bin,etc}

"cap_setpcap,${capabilities}" "$wrapperDir/${program}"
    ln -s ${mudfish}/bin/* /opt/mudfish/${mudfish.version}/bin/
    ln -s ${mudfish}/etc/* /opt/mudfish/${mudfish.version}/etc/

    # ln -s /opt/${mudfish.version}/bin/muddiag $out/bin/muddiag
    # ln -s /opt/${mudfish.version}/bin/mudfish $out/bin/mudfish
    # ln -s /opt/${mudfish.version}/bin/mudflow $out/bin/mudflow
    # ln -s /opt/${mudfish.version}/bin/mudrun $out/bin/mudrun
    # ln -s /opt/${mudfish.version}/sbin/mudovpn $out/bin/mudovpn

    # ln -s /opt/${mudfish.version}/etc/htdocs-lan-${mudfish.version}.tar $out/etc/htdocs-lan-${mudfish.version}.tar
    # ln -s /opt/${mudfish.version}/etc/htdocs-www-${mudfish.version}.tar $out/etc/htdocs-www-${mudfish.version}.tar
    # ln -s /opt/${mudfish.version}/etc/mudrun_cert.pem $out/etc/mudrun_cert.pem
    # ln -s /opt/${mudfish.version}/etc/mudrun_pkey.pem $out/etc/mudrun_pkey.pem

    # ln -s
    bash
  '';
}
