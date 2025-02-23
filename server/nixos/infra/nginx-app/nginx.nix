{ config, pkgs, ... }:
 {
   config.virtualisation.oci-containers.containers = {
     nginx-app = {
       image = "nginx:1.27.4";
       ports = ["0.0.0.0:8080:80"];
       volumes = [
         "${toString ./index.html}:/usr/share/nginx/html/index.html"
       ];
     };
   };
 }
