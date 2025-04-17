# Fluntbit
- eks 내의 파드들의 로그 수집/가공 용도 서비스
- 설치 시 DaemonSet으로 설치되기 때문에 eks 내의 모든 node에 붙어서 설치 -> 모든 node의 log 수집
- 연동 시스템
  - Elasticsearch
    - 가공된 로그 저장/검색 용도 서비스
    - 시각화 서비스
      - Kibana
        - 엘라스틱 위주로 시각화 용도로 적합
        - 필터 적용에서는 더 강력
      - Grafana
        - 엘라스틱 이외의 서비스와 같이 시각화 하기
      - 일단 Grafana로 시각화 목표

- 설치
  - helm 레포지토리 생성
  ```angular2html
  helm repo add fluent https://fluent.github.io/helm-charts
  helm repo update
  ```
  - helm value 파일 생성
  ```angular2html
  helm show values fluent/fluent-bit > values.yaml
  ```
  - value 파일 기반으로 fluntbit 설치
  ```angular2html
  helm upgrade --install fluent-bit fluent/fluent-bit `
  --namespace logging `
  --create-namespace `
  --values .\values.yaml
  ```