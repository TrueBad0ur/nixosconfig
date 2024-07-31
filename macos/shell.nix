{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  #nativeBuildInputs = with pkgs.buildPackages; [ kubectl ];
  packages = [ pkgs.kubectl ];
  shellHook = ''
    alias ports="lsof -i4TCP -sTCP:LISTEN -n -P +c0"
    alias k="kubectl"
    alias kl="kubectl --kubeconfig ~/k8s/local/config.yaml"
    alias helml="helm --kubeconfig ~/k8s/local/config.yaml"
    source <(kubectl completion zsh)
    source <(docker completion zsh)
    export DOCKER_HOST=unix:///$HOME/.docker/run/docker.sock
  '';
}
