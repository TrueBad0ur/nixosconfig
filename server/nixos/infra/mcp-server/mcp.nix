{ config, pkgs, lib, mcp-simple-server, ... }:
let
  # Fetch the MCP repository from GitHub
  mcpSrc = pkgs.fetchFromGitHub {
    owner = "TrueBad0ur";
    repo = "mcp-simple-server";
    rev = "main";
    #hash = lib.fakeHash;
    hash = "sha256-kwZCwJn+9cnfPEoCg1csVrvtrpdAiaeztP4fiynF26c=";
  };

  #mcpSrc = mcp-simple-server;

  # Create Python environment with required packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    fastapi
    uvicorn
    mcp
    pytz
  ]);

  # Build the MCP server Docker image
  # - Later redo witout docker
  mcpImage = pkgs.dockerTools.buildImage {
    name = "mcp-server";
    tag = "latest";

    # Use copyToRoot instead of deprecated contents
    copyToRoot = pkgs.buildEnv {
      name = "mcp-server-root";
      paths = [ pythonEnv mcpSrc ];
      pathsToLink = [ "/bin" "/" ];
    };

    # Set working directory and command
    config = {
      WorkingDir = "/app";
      Cmd = [ "python" "server.py" ];
      ExposedPorts = {
        "8000/tcp" = {};
      };
    };
  };
in
{

  # Load the image during system activation
  config.system.activationScripts.load-mcp-image = ''
    echo "Setting up MCP server..."

    # Create log directory
    mkdir -p /var/log/mcp-server
    chown 1000:1000 /var/log/mcp-server 2>/dev/null || true

    # Load and tag image
    echo "Checking MCP server image..."
    if ${pkgs.podman}/bin/podman image exists localhost/mcp-server:latest 2>/dev/null; then
      echo "MCP server image already exists"
    else
      echo "Loading MCP server image..."
      if ${pkgs.podman}/bin/podman load < ${mcpImage}; then
        echo "Tagging image as localhost/mcp-server:latest..."
        ${pkgs.podman}/bin/podman tag mcp-server:latest localhost/mcp-server:latest
        echo "MCP server image loaded and tagged successfully"
      else
        echo "Failed to load MCP server image"
        exit 1
      fi
    fi
  '';

  # OCI container using the loaded image
  config.virtualisation.oci-containers.containers = {
    local-mcp-server = {
      image = "localhost/mcp-server:latest";
      ports = ["0.0.0.0:8000:8000"];
      volumes = [
        "/var/log/mcp-server:/app/logs"
      ];
      environment = {
        MCP_API_KEY = "your-secure-api-key-here";
      };
      autoStart = true;
    };
  };
}

