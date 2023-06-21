## Definição de portas do deployment

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
containerPort: 9501 
```

</td>
<td>
    
```yaml
multiPortContainer:
  enabled: true
  ports:
    - name: http
      containerPort: 9501
    - name: grpc
      containerPort: 8080
```
</td>
</tr>
</table>

## Service

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
service:
  enabled: true
  port: 80
  targetPort: 9501
```

</td>
<td>
    
```yaml
multiPortService:
  enabled: true
  ports:
    - name: http
      port: 80
      targetPort: 9501
    - name: grpc
      port: 8080
      targetPort: 8080
```
</td>
</tr>
</table>

O nome das portas é opcional. A lista pode ser composta apenas de port e targetPort.

## Healthcheck

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
health:
  path: /health
readiness:
  initialDelaySeconds: 10
liveness:
  initialDelaySeconds: 30
```

</td>
<td>
    
```yaml
health:
  path: /health
  portName: http
readiness:
  initialDelaySeconds: 10
liveness:
  initialDelaySeconds: 30
```
</td>
</tr>
</table>

É necessário indicar qual porta será usada para healthcheck pelos probes do K8s. Note que portName se refere ao nome especificado no Deployment, uma vez que o nome das portas no Service é opicional.

## Ingress

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
ingress:
  - type: ingress-default-aws
    hosts:
      - hostname: xxxx.ms.qa
    annotations:
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/healthcheck-path: /health
      alb.ingress.kubernetes.io/tags: bu=xxxxx
      alb.ingress.kubernetes.io/group.name: internal-microservices
```

</td>
<td>
    
```yaml
ingress:
  - type: ingress-default-aws
    hosts:
      - hostname: xxxx.ms.qa
        servicePort: 80
      - hostname: xxxxx-webhook.ms.qa    
        servicePort: 8080
    annotations:
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/healthcheck-path: /health
      alb.ingress.kubernetes.io/tags: bu=xxxxxx
      alb.ingress.kubernetes.io/group.name: internal-microservices
```
</td>
</tr>
</table>

Se a aplicação utilizar um hostname único, é possível redirecionar a requisição através do path. Exemplo:

```yaml
ingress:
  - type: ingress-default-aws
    hosts:
      - hostname: xxxx.ms.qa
        path: /api/v1
        servicePort: 80
      - hostname: xxxx.ms.qa   
        servicePort: 8080
        path: /api/webhook
    annotations:
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/healthcheck-path: /health
      alb.ingress.kubernetes.io/tags: bu=xxxx
      alb.ingress.kubernetes.io/group.name: internal-microservices
```