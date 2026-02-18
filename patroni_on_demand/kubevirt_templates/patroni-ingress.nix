{ cluster, ... }:

let
  ingressName = "ingress-${cluster.name}-${index}";

  yamlContent = ''
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: ${ingressName}
    spec:
      rules:
        - host: ${ingressName}.example.com
          http:
            paths:
              - path: /
                pathType: Prefix
                backend:
                  service:
                    name: ${ingressName}
                    port:
                      number: 80
  '';

in yamlContent # send back the yaml content
