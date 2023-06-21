Nos novos clusters, houve a substituição do **banzaicloud-operator** pelo **keda** como autoscaling baseado em custom metrics. Com isso, temos mudanças em como declarar um scaler

## Definição de parametros do HPA vanilla

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
hpa:
  enabled: true
  min: 3
  max: 10
  targetCPU: 80
```
ou
```yaml
hpa:
  enabled: true
  min: 3
  max: 10
  metrics:
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
```
</td>
<td>
    
```yaml
hpa:
  enabled: true
  type: vanilla
  min: 3
  max: 10
  targetCPU: 60
  targetMemory: 80
```
</td>
</tr>
</table>

## Definição de parametros do HPA Keda

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
hpa:
  enabled: false
  min: 1
  max: 1
keda:
  enabled: true
  pollingInterval: 10
  cooldownPeriod: 10
  minReplicaCount: 1
  maxReplicaCount: 10
  triggers:
    - type: aws-sqs-queue
      metadata:
        queueURL: #https://sqs.us-east-1.amazonaws.com/accountID/filaName
        queueLength: "5"
        awsRegion: "us-east-1"
        identityOwner: operator
        scaleOnInFlight: "false"
```
</td>
<td>
    
```yaml
hpa:
  enabled: true
  type: keda
  min: 2
  max: 5
  targetCPU: 60
  targetMemory: 80
  pollingInterval: 20
  cooldownPeriod: 10
  triggers:
    - type: kakfa
      metadata:
        protocol: amqp
        queueName: demo_queue # Nome da queue
        mode: QueueLength
        value: "3" # Se tivermos 3 novas mensagens, ativa scaling
      authenticationRef:
        name: keda-trigger-auth-rabbitmq-conn
```
</td>
</tr>
</table>

## Tabela de Parâmetros

<table>
<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> type </td> <td> vanilla </tb> <td> Tipo de hpa a ser utilizado. Valor aceita <i>vanilla</i> ou <i>keda</i> </td>
</tr>
<tr>
<td> min </td> <td> - </td> <td> Valor mínimo de pods do deployment -- Precisa ser menor do que <i>max</i>. Obrigatório </td>
</tr>
<tr>
<td> max </td> <td> - </td> <td> Valor máximo de pods do deployment. Obrigatório  </td>
</tr>
<tr>
<td> targetCPU </td> <td> 60 </td> <td> Média de uso de CPU para ativar um scaling do deployment (em %). Opcional </td>
</tr>
<tr>
<td> targetMemory </td> <td> - </td> <td> Média de uso de Memória para ativar um scaling do deployment (em %). Não é habilitado por default. Opcional</td>
</tr>
<tr>
<td> pollingInterval </td> <td> 30 </td> <td> Período entre as sondagens do keda em segundos. A cada `pollingInterval`, o Keda Operator checa a necessidade de scaling. Opcional </td>
</tr>
<tr>
<td> cooldownPeriod </td> <td> 300 </td> <td> Delay entre o Keda Operator avaliar que há espaço para escalar o deployment para zero réplicas e a ocorrência. Só é utilizado caso o parametro <i>min</i> seja 0. Opcional </td>
</tr>
<tr>
<td> triggers </td> <td>  </td> <td> Ver abaixo. Obrigatório caso <i>type = keda</i> </td>
</tr>
</table>

<br><br><br>


### Tabela de Parâmetros do bloco Triggers.(https://keda.sh/docs/2.9/concepts/scaling-deployments/#triggers)

<table>
<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> type </td> <td> - </tb> <td> Tipo de gatilho a ser usado. Obrigatório </td>
</tr>
<tr>
<td> metadata </td> <td> - </td> <td> Parametros de configuração que o gatilho necessita. Obrigatório </td>
</tr>
</table>
Devido ao alto nível de customização dos triggers. Temos muitos parâmetros que podem ser usados, sendo necessário consultar os parametros necessários em cada caso.