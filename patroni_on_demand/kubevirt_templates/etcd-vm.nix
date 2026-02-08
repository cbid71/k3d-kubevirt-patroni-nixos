{ clusterName, index, pkgs, ... }:

let
  # Utilisation de l'index et du nom du cluster pour créer un nom de VM unique
  vmName = "haproxy-${clusterName}-${index}";

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

in yamlContent; 


pkgs.writeTextFile {
  name = "${vmName}.yaml";  # Nom du fichier basé sur clusterName et index
  text = yamlContent;
}
