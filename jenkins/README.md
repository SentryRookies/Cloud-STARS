# 1. Helm에 jenkins 설치
```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
```
# 2. jenkins 설치 
- namespace를 default를 설정하여 Ingress 설정할 수 있도록 세팅

```
helm install jenkins -n default jenkinsci/jenkins -f jenkins-values.yaml
```

# LB 설치 (진행 X, LB가 작동 안됨)
```
현재 LB는 작동이 안됨 
세팅이 되어있다 정도면 알면 된다
kubctl apply -f jenkins/jenkins_lb.yaml
```

# 3. PV & PVC 세팅
```
kubctl apply -f jenkins_pv.yaml
```
만약 pv,pvc가 작동이 안된다면
0.storageClass.yaml 파일을 수정해야 한다
해당 파일 맨 밑에 아래 내용 추가
```
parameters:
  provisioningMode: efs-ap
  fileSystemId: fs-07cac985d0f82c76d
  directoryPerms: "0755"
  gidRangeStart: "1000"
  gidRangeEnd: "2000"
  basePath: "/jenkins"
```

# Ingress 세팅 값
```
- host: jenkins.seoultravel.life
      http:
        paths:
          - backend:
              service:
                name: jenkins
                port:
                  number: 8888
            path: /
            pathType: Prefix
```