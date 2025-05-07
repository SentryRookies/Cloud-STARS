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
  
# 프로메테우스 쿼리
- 각 노드들 cpu 사용량 백분율
  - 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

- 각 노드들 메모리 사용량 백분율
  - (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

## value 설정 (prometheus)
- alertmanager 자동 생성 해제
  - 알트 매니저 자동 생성하면 매니저에서 pvc 연결이 어려워서 따로 helm으로 설치
    ```angular2html
    alertmanager: # 알트매니저는 따로 설치해서 pvc 지정해줄거임
      enabled: false
    ```
  - persistentVolume
    - 수집한 로그 저장하는 경로 마운트
    - efs의 pvc로 저장하기 위해서 pvc 지정
    ```angular2html
      persistentVolume:
        enabled: true
        existingClaim: "prometheus-pvc"
    ```
    - 마운트 경로를 지정하지 않는다면 기본 경로는 /data로 지정됨

  - server.service
    - 포트 설정
      - servicePort: 980

## value 설정 (alertmanager)
- persistence
  - 이거 true로 설정되어 있으면, 자동으로 pvc 만들어서 마운트 시킴
  - 기존의 pvc를 사용하려면 이를 false 설정해야 함

- extraVolume
  - 여기서 기존의 pvc 사용 가능하게 설정
  ```angular2html
  extraVolumes:
    - name: alert-volume
      persistentVolumeClaim:
        claimName: prometheus-alert-pvc
  ```
- extraVolumeMount
  - 볼륨에서 설정한 pvc 실제 컨테이너에 마운트
  ```angular2html
  extraVolumeMounts:
    - name: alert-volume
      mountPath: /data
  ```