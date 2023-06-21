
```yaml
cronjobs:
    - name: process-previous-day
      image: accountID.dkr.ecr.us-east-1.amazonaws.com/dev/ms-example
      enabled: true
      command: /docker-env.sh
      args: /app/artisan schedule:run
      workload: auth
      envFrom:
        - secretRef:
            name: envs
      memory: 100Mi
      cpu: 100m
      schedule: "*/10 11-17 * * *"
      ttl: 3600
      spot_support: true
```


## Tabela de Parâmetros
<table>

<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> name </td> <td> - </tb> <td> Nome do cronjob. É concatenado com `app_name-cronjob-$name`. Obrigatório </td>
</tr>
<tr>
<td> image </td> <td> - </td> <td> Link da imagem da aplicação no ECR. Obrigatório </td>
</tr>
<tr>
<td> enabled </td> <td> - </td> <td> Parametro pra indicar se o cronjob deve ou não ser criado no cluster. Boolean (true/false) Obrigatório </td>
</tr>
<tr>
<td> command </td> <td> - </td> <td> Comando que o cronjob irá executar. Obrigatório </td>
</tr>
<tr>
<td> args </td> <td> - </td> <td> Argumentos a serem passados junto ao command. Obrigatório </td>
</tr>
<tr>
<td> workload </td> <td> - </td> <td> Workload que sua aplicação utiliza. Obrigatório </td>
</tr>
<tr>
<td> envFrom </td> <td> - </td> <td> Bloco necessário para importação de variáveis. Necessário utilizar para importar envs via external-secrets. 'name' se refere ao nome do secret que possui as envs. </td>
</tr>
<tr>
<td> memory </td> <td> - </td> <td> Define o requests_memory e limits_memory. Obrigatório </td>
</tr>
<tr>
<td> cpu </td> <td> - </td> <td> Define o requests_cpu e limits_cpu. Obrigatório </td>
</tr>
<tr>
<td> schedule </td> <td> - </td> <td> Define a programação de execução do cronjob. Obrigatório </td>
</tr>
<tr>
<td> ttl </td> <td> 3600 </td> <td> Define o tempo máximo de execução do processo em segundos.  </td>
</tr>
<tr>
<td> spot_support </td> <td> false </td> <td> Define se o cronjob pode rodar em máquinas Spot. Boleean (true/false) </td>
</tr>

</table>

* não é possível declarar limits e requests de forma separada. Como os cronjobs possuem horários específicos para a execução, os requests e limits são iguais de forma a garantir um QoS superior, dando prioridade pra alocação desse processo.

* Apoio pra agendar o schedule: https://crontab.guru/ -- Lembrando que o cluster roda em Virgínia, então o schedule precisa ser criado em UTC.

* Como boa prática, é ideal que o TTL seja menor que o tempo entre duas execuções.

* Nos novos clusters de QA, todos os workloads são spot, então é necessário que `spot_support` seja true no values.qa.yaml.
