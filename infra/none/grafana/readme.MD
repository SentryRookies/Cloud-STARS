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
  - 프로메테우스
    - kubectl port-forward svc/prometheus-server -n monitoring 980:980

- 데이터 소스 uri
  - 엘라스틱
    - http://elasticsearch-cs.default.svc.cluster.local:9200

## value 설정
- persistence
  - 이거 true로 설정되어 있으면, 자동으로 pvc 만들어서 마운트 시킴
  - 기존의 pvc를 사용하려면 이를 false 설정해야 함

- extraVolume
  - 여기서 기존의 pvc 사용 가능하게 설정
  ```angular2html
  extraVolumes:
     - name: grafana
       existingClaim: grafana-pvc
  ```
- extraVolumeMount
  - 볼륨에서 설정한 pvc 실제 컨테이너에 마운트
  - 그라파나는 마운트 해야 할 폴더가 4개 (대시보드, 데이터소스, ...)
  ```angular2html
  extraVolumeMounts:
     - name: grafana
       mountPath: /data/lib/grafana
     - name: grafana
       mountPath: /data/log/grafana
     - name: grafana
       mountPath: /data/lib/grafana/plugins
     - name: grafana
       mountPath: /data/etc/grafana/provisioning
  ```
- 아이디/비번 설정
  ```angular2html
  adminUser: 아이디
  adminPassword: 비번
  ```
- 포트 설정 (서비스 포트)
  ```angular2html
  service:
    #중략
    port: 7080
  ```
