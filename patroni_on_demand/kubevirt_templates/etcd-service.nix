{ clusterName, index, pkgs, lib, ... }:

let
  serviceName = "service-${clusterName}-${index}";

  yamlContent = ''
    apiVersion: v1
    kind: Service
    metadata:
      name: ${serviceName}
    spec:
      selector:
        app: ${serviceName}
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      type: ClusterIP
  '';

in yamlContent  # Send back the yaml content
