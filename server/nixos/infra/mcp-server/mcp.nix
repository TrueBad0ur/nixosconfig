{ config, pkgs, lib, ... }:
let
  mcpSrc = pkgs.fetchFromGitHub {
    owner = "TrueBad0ur";
    repo = "mcp-simple-server";
    rev = "main";
    hash = "sha256-kwZCwJn+9cnfPEoCg1csVrvtrpdAiaeztP4fiynF26c=";
  };

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    fastapi
    uvicorn
    mcp
    pytz
  ]);

  mcp-server = pkgs.stdenv.mkDerivation {
    name = "mcp-server";
    src = mcpSrc;

    buildInputs = [ pythonEnv ];

    installPhase = ''
      mkdir -p $out
      cp app/*.py $out/
      chmod +x $out/server.py
    '';
  };

  mcpUser = "mcp-server";
  mcpGroup = "mcp-server";
in
{
  config.users.users.${mcpUser} = {
    isSystemUser = true;
    group = mcpGroup;
    description = "MCP Server user";
    home = "/var/lib/mcp-server";
    createHome = false;
  };

  config.users.groups.${mcpGroup} = {};

  config.systemd.services.mcp-server = {
    description = "MCP Server Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = mcpUser;
      Group = mcpGroup;

      StateDirectory = "mcp-server";
      StateDirectoryMode = "0750";

      LogsDirectory = "mcp-server";
      LogsDirectoryMode = "0750";

      WorkingDirectory = "/var/lib/mcp-server";

      Environment = [
        "PATH=${pythonEnv}/bin:${pkgs.coreutils}/bin"
        "MCP_API_KEY=your-secure-api-key-here"
        "PYTHONPATH=${mcp-server}"
      ];

      ExecStart = "${pythonEnv}/bin/python ${mcp-server}/server.py";

      Restart = "always";
      RestartSec = 3;

      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      RestrictRealtime = true;
      MemoryDenyWriteExecute = true;
      InaccessiblePaths = [
        "/home"
        "/root"
        "/etc/shadow"
	"/etc/passwd"
      ];

      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
      ];

      UMask = "0077";  # Files created with 600 permissions
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];  # Only network access

      BindReadOnlyPaths = [
        "/nix/store"
      ];

      LimitNOFILE = 1024;
      LimitNPROC = 64;

      CPUQuota = "50%";  # Limit to 50% of one CPU core

      StandardOutput = "journal";
      StandardError = "journal";
    };

    postStart = ''
      # Create symlink for logs directory after directories are created
      ln -sf /var/log/mcp-server /var/lib/mcp-server/logs
    '';
  };

  config.networking.firewall.allowedTCPPorts = [ 8000 ];
}
