# 프로메테우스
- Prometheus와 alertmanager로 구성
  - 프로메테우스 → 모니터링 & 수집, 알람 생성
  - 알트매니저 → 알람 생성되면 외부로 전달
  - 둘 다 사용해야 프로메테우스가 정상적으로 동작

# 프로메테우스 설치
```
# helm 레포지토리 추가

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
- helm 설치 시 설정 파일 생성
    ```angular2html
    helm show values prometheus-community/prometheus > values.yaml
    ```
- 프로메테우스 본체 설치
    ```angular2html
    helm upgrade --install prometheus prometheus-community/prometheus `
    --namespace monitoring `
    --create-namespace `
    -f .\values.yaml
    ```
- alertmanager 설치
    ```angular2html
    helm upgrade --install alertmanager prometheus-community/alertmanager `
    -n monitoring `
    -f alert_values.yaml
    ```
  
# 프로메테우스는 lb 또는 ingress 이용 X
- 포트 포워딩으로 직접 열어서 확인
  - 프로메테우스
    ```angular2html
    kubectl port-forward svc/prometheus-server -n monitoring 9090:980
    ```
    - 접속
      - http://localhost:9090
  - alertmanager
    ```angular2html
    kubectl port-forward svc/alertmanager -n monitoring 9093:9093
    ```
    - 접속
      - http://localhost:9093
  