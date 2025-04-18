# Fluentbit
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
      - 써보니까 굳이 인것 같아서 **kibana**로 시각화

## 설치
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
  - 삭제
    -  helm uninstall fluent-bit -n logging

- 명령어
  - 로그 잘 들어가는지 확인
   - kubectl logs -n logging -l app.kubernetes.io/name=fluent-bit

## value 설정
  - config
    - input, filter는 기본값으로 설정하면 eks 내의 모든 노드의 로그를 수집함
    - output
      - 수집한 로그를 어디로 보낼 것인지 설정
      - name은 자유, match는 기본은 host.*인데, 이러면 host라고 붙은 로그만 전송해서 수정 필요, 여기선 * 사용 (전부 전송)
      - host는 pod의 클러스터 ip 설정해주는데, 서비스 이름으로 넣어도 됨 -> 내부 클러스터 uri(?) 넣어줘야 함
        - elasticsearch-cs.default.svc.cluster.local
      - 나머지는 기본값
