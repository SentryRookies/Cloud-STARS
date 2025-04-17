# 그라파나 설치
- helm 저장소 설치
    ```angular2html
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    ```
- 설치
  ```angular2html
  helm upgrade --install grafana grafana/grafana `
    --namespace monitoring `
    --create-namespace `
    --values .\values.yaml
  ```
    
- 포트포워딩
  - kubectl port-forward svc/grafana -n monitoring 7080:7080