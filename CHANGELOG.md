# Changelog Entries 

## Subtitle

```bash
fix: mudança no template/versão atual a fim de ajustes. (1.1.1, 1.1.2 > 1.1.3)
add: nova feature importada dentro do template. (1.1.1, 1.1.2 > 1.2.0)
breaking: mudança que interfere no funcionamento geral do template. (1.1.1, 1.1.2 > 2.0.0)
```

## v0.55.2
**fix**
- Remoção de logs de debug do otelcol para evitar vazamento de memória

## v0.55.1
**fix**
- Ajuste na pipeline de métricas do otelcol para habilitar o receiver do prometheus


## v0.55.0
**add**
- Adiciona a possibilidade de habilitar o receiver de métricas no formato prometheus no coletor opentelemetry:
```yaml
     otelcol:
       prometheus: true
```

## v0.53.0
**add**
- Refactoring para permitir múltiplas external secrets e secret stores, com nomenclatura customizada. Vide exemplo documentado no values.yaml do helm-ms.

## v0.52.0 | v0.52.1
**add**
- Diferenciador entre o endpoint de traces e de métricas nas configurações do opentelemetry (da nova stack) em `otelcol-config.yaml` mantendo os exporters configurados para o NewRelic



## v0.51.0
**fix**
- Mudança no endpoint pra coleta de traces do `otelcol-config.yaml`. Novo endpoint criado por Observabilidade


## v0.50.2
**fix**
- cert-monitor namespace precisa ser 'monitoring' no momento.

## v0.50.1
**fix**
- deployments priority-class validation syntax

## v0.50.0
**feature**
- add certificate service-monitor

## v0.49.0
**feature**
- add external-secrets for new clusters k8s
**fix**
- update ingress version from `v1beta1` to `v1`

## v0.47.1
**fix:**
Rollback da remoção do EnvsFrom por conta dos clusters antigos (msqa/msprod)
## v0.47.0
**add:**
Habilitando Jaeger via HTTP no OTel Collector
**fix:**
Rollback na condicional de Path do ingress (no caso de omissão do parâmetro `path`, ele continuava procurando por ele)
Rollback na validação de liveness/readiness dos workers, tá quebrando os updates do msprod

## v0.44.0
**add:**
Annotations no recurso de CronJob

## v0.43.1
**add:**
Padronizado worker para novos modelos EKS CK - service/ms-codekloud

## v0.42.0
**add:**
Padronizado api para novos modelos EKS CK

## v0.41.0
**add:**
Possibilita reutilizar os serviços existentes para uso de métricas com o ServiceMonitor, evitando a criação de um serviço somente para métricas.

## v0.30.0
**add:**
Possibilita a nomeação de portas de serviços, e copia as labels das APIs para o serviço.
Isso foi feito para que funcione a integração entre o Service Monitor global mantido pelo time de O11Y, que acaba lendo de uma porta com nome específico.


## v0.28.0
**add:**
Adiciona a insersão das annotations do deployment-api no campo `spec.template.metadata.annotations`. Antes elas eram inseridas apenas no `metadata.annotations`, não gerando a annotation dentro do pod.
Necessário pra inserir o campo `observability.ppay.me/bu: open_finance`, usado no processamento de logs da nova plataforma de observabilidade.
```yaml
  apis:
    - name: api
      annotations:
        foo: bar
```


## v0.28.0
**fix:**
Adiciona a possibilidade de definir o newrelic como exporter padrão para o collector do opentelemetry:
```yaml
     otelcol:
        newrelic: true
```

## v0.26.0
**add:**
Implementa a criação de um ServiceAccount linkado ao deploy da API caso ele possua os parametros para isso, possibilitando passar o roleArn linkado a esse SA
Dentro dos valores do deployment-api:
```yaml
     sa:
       enabled: true
       roleArn: "arn:aws:iam::AccountID:role/example-name"
```

## v0.25.4
**fix:**
- adição do global.serviceAccount.name no values.yaml do template pra evitar de quebrar um MS que não passe esse parametro

no charts/helm-ms/values.yaml
```yaml
      serviceAccount:
        name: ""
```

## v0.25.4
**change:**
- Alterar ServiceAccount no Deployment para utilizar pela chave ``serviceAccount.name`` possibilitando utilizarmos mais informações do serviceAccount.
```
      {{- if not (empty $.Values.global.serviceAccount.name) }}
      serviceAccountName: {{ $.Values.global.serviceAccount.name }}
      {{- end}}
```

## v0.25.3
**add:**
- Atrelar ServiceAccount ao Deployment
```
      {{- if not (empty $.Values.global.serviceAccountName) }}
      serviceAccountName: {{ $.Values.global.serviceAccountName }}
      {{- end}}
```

## v0.25.2
**add:**
- Serviços que usam OTel Sidecar exportando para o Collector.

## v0.25.1
**fix:**
- Alterando nome da porta para `health-port` devido restricao de caracteres:
```
        {{- if $api.containerPort }}
        ports:
        - name: container-port
          containerPort: {{ $api.containerPort }}
          protocol: TCP
        {{- if $api.healthcheckPort }}
        - name: health-port
          containerPort: {{ $api.healthcheckPort }}
          protocol: TCP
        {{- end }}
        {{- end }}
        {{- if $api.volumeMounts }}
```

## v0.25.0
**add:**
- Inclusão de possibilidade de porta para healthcheck a partir do parametro "healthcheckPort":
```
        {{- if $api.containerPort }}
        ports:
        - name: container-port
          containerPort: {{ $api.containerPort }}
          protocol: TCP
        {{- if $api.healthcheckPort }}
        - name: health-check-port
          containerPort: {{ $api.healthcheckPort }}
          protocol: TCP
        {{- end }}
        {{- end }}
        {{- if $api.volumeMounts }}
```


## v0.24.0
**add:**
- Inclusão de labels no service:
```
     {{- with $api.service.labels -}}
            {{ toYaml . | nindent 4 }}
        {{- end }}
```
## v0.23.0
**add:**
- Inclusão do OpenTelemetry Collector como sidecar. Para utilizar:
```
    global:
      otelcol:
        enabled: true
```

## v0.22.0
**add:**
- Inclusão de Count de Namespace por Squad no Grafana
```
    labels:
      sre: sre-nome_squad
```

## v0.21.0
**add:**
- Inclusão de suporte ao Keda nos workers
```
    workers:
    - name: worker-name
    ...
      keda: ...
```
- Inclusão da propriedade *workloadLabel* para customizar Key usada no workload. Essa propriedade muda nos clusters apartados.

## v.20.0
**add:**
- Includindo Volume e VolumeMounts em CronJob


## v0.19.9
**add:**
- Adição de hostAlias no template de cronjob.

## v0.19.8
**fix:**
- correção na customização de node affinity nos cronjobs
- correção na customização de toleration no cronjob


## v0.19.7

Simples adição de label pra uso do prometheus em dashes no grafana

**add:**

- deployment label “workload” referenciando a qual o workload (compute, memory ou general) o deployment está alocado.

## v0.19.6

**fix:**

- mudança na forma de interpretar a existência do startUp Probe no deployment-api.

## v0.19.5

**add:**

- inclusão de startingDeadlineSeconds no template do cronjob, trazendo um default de 350s caso não esteja declarado no helm do serviço.

## v0.19.4

**add:**

- inclusão do startUp Probe no template dos deployments. </br>

*Observação:*

essa alteração teve uma breaking change (a alteração de versão apenas da Patch não foi condizente), sendo necessário referenciar o startupProbe no helm do microsserviço. Caso o deploy não utilize startupProbe, ainda será necessário declará-la com:

```bash
startup:
    enabled: false
```

## v0.19.3

**add:**

- suporte a lifecycle (postStart, preStop) no deployment-worker

## v0.19.2

**add:**

- customização de rollingUpdateMaxSurge para API (default como 25%)
- customização de rollingUpdateMaxUnavailable para API (default como 0)

**fix:**

- liveness e readiness probes para api e workers

## v0.19.1

**add:**

- adequação do serviceMonitor (service-monitor-metrics) de acordo com procedimentos o11y

## v0.19.0

**add:**

- separacao e customizaçao de parametros para o liveness e readiness probes
