# Tipo ALB (Application Load Balancer)

```yaml
apis:
    - name: api
    [...]
      ingress:
        - type: ingress-default-aws
          enabled: true
          name: example-internal-alb
          annotations:
            alb.ingress.kubernetes.io/target-type: ip
            alb.ingress.kubernetes.io/scheme: internal
            alb.ingress.kubernetes.io/healthcheck-path: /health/alive
            alb.ingress.kubernetes.io/healthcheck-port: 8080
            alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
            alb.ingress.kubernetes.io/group.name: example-internal
            alb.ingress.kubernetes.io/tags: bu=example
          hosts:
            - hostname: ms-xxxxx-alb.ms.prod
```


## Tabela de Parâmetros
<table>

<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> type </td> <td> - </tb> <td> Tipo de ingress. Esse campo é traduzido no IngressClassName, por padrão os clusters possuem 'internal-microservices' e 'ingress-default-aws'. Obrigatório </td>
</tr>
<tr>
<td> enabled </td> <td> - </td> <td> Parametro pra indicar se o ingress deve ser criado. Boolean (true/false) Obrigatório </td>
</tr>
<tr>
<td> name </td> <td> - </td> <td> Nome do ingress a ser criado. Caso não seja declarado, o nome é uma concat do nome da api com o tipo do ingress </td>
</tr>
<tr>
<td> annotations </td> <td> - </td> <td> Annotations de definição dos parametros do ALB. Ver tabela de annotations </td>
</tr>
<tr>
<td> hosts </td> <td> - </td> <td> Lista de hostnames. Aceita N slices '- hostname: ${url}' </td>
</tr>
</table>


### Tabela de annotations 
As seguintes annotations são tomadas como 'essenciais' pro uso do ALB. Todas elas possuem o prefixo 'alb.ingress.kubernetes.io/', como no exemplo no início da documentação.

<table>

<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> target-type </td> <td> - </tb> <td> Especifica como rotear tráfego para os pods. Opções são <b>instance</b> ou <b>ip</b>. Padrão de uso: ip </td>
</tr>
<tr>
<td> scheme </td> <td> internal </td> <td> Especifíca se o ALB será interno ou público. Opções são <b>internal</b> ou <b>internet-facing</b>. O uso de ALB internet-facing deve ser validado com o time de Redes e Gatekeepers. Padrão de uso: internal </td>
</tr>
<tr>
<td> healthcheck-path </td> <td> - </td> <td> Endpoint que o ALB utiliza pra fazer healthcheck nos pods. Padrão de uso: declarar o endpoint de liveness da sua aplicação </td>
</tr>
<tr>
<td> healthcheck-port </td> <td> - </td> <td> Porta a ser usada no health-check. Padrão de uso: declarar o containerPort da API </td>
</tr>
<tr>
<td> listen-ports </td> <td> - </td> <td> Porta que o ALB escuta. Padrão de uso: '[{"HTTP": 80}]' | '[{"HTTPS": 443}]' </td>
</tr>
<tr>
<td> group.name </td> <td> - </td> <td> Especifica qual o grupo do ALB que o seu ingress será anexado. O padrão a ser utilizado é de um ALB por BU, padronizando o nome em "bu-internal" </td>
</tr>
<tr>
<td> tags </td> <td> - </td> <td> Especifica tags a serem aplicadas nos recursos da AWS (alb, securitygroups e targetgroup). Stringmap separado por vírgulas. Obrigatório ter a tag de bu no padrão de FinOps  </td>
</tr>
</table>

O aws-load-balancer-controller aceita várias outras annotations de configurações. A tabela completa pode ser acessada em: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/#annotations
