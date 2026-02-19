{ cluster, index, ... }:

let
  # Utilisation de l'index et du nom du cluster pour créer un nom de VM unique
  vmName = "haproxy-${cluster.name}-${toString index}";

  # Contenu YAML à générer
  yamlContent = ''
    apiVersion: kubevirt.io/v1
    kind: VirtualMachine
    metadata:
      name: ${vmName}
    spec:
      template:
        spec:
          domain:
            devices:
              interfaces: []
          memory: 1024Mi
          vcpu: 2
  '';

in yamlContent
