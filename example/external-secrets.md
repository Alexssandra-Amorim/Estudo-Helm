## deprecated -- go-to `multiplos-external-secrets.md`
O princípio aplicado é de gerar um artefato chamado 'secretStore' e do artefato 'external-secrets'. O secretstore define e realiza a autenticação com o provedor das variáveis, enquanto o external-secrets define quais variáveis serão buscadas nesse provedor. Essa combinação gera um terceiro artefato do tipo 'secret' chamado 'envs', onde ficam armazenadas as variáveis do serviço. 

O padrão usado foi baseado no Vault, porém há também a possibilidade de uso com o AWS SecretsManager.

Para usar a secret, é declarado o parametro `envsFrom` nos deployments.
```yaml
      envFrom:
        - secretRef:
            name: envs
```

## Definição de parametros do external-secrets

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

```yaml
global:
  externalSecrets:
    enabled: true
    secretStore: cluster-secret-store-default
```
</td>
<td>
Para uso com Vault:

```yaml
global:
  externalSecrets:
    enabled: true
    type: vault
    refreshInterval: 5m
    mountPath: kubernetes-xxxx-xxx-hom
    path: kv/xxxx/hom
```

Para uso com AWS SecretManager:
```yaml
global:
  externalSecrets:
    enabled: true
    type: aws
    refreshInterval: 5m
    secretStore:
      region: us-east-1
    roleArn: arn:aws:iam::888888888888:role/example-role-for-external-secrets 
```

</td>
</tr>
</table>

## Tabela de Parâmetros - Caso Vault

<table>
<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> enabled </td> <td> - </tb> <td> Indicador para habilitar ou não o external-secrets - true/false </td>
</tr>
<tr>
<td> type </td> <td> aws </tb> <td> Tipo de external-secrets a ser utilizado. Campo aceita <i>aws</i> ou <i>vault</i> </td>
</tr>
<tr>
<td> refreshInterval </td> <td> 1h </tb> <td> Tempo que o external-secrets espera para sincronizar novamente as variáveis </td>
</tr>
<tr>
<td> mountPath </td> <td> - </tb> <td> Path do cluster para autenticação com o Vault. Normalmente será 'kubernetes-$clusterName' (ex: kubernetes-store1-use1-hom ou kubernetes-secexp-use1-prd). Obrigatório </td>
</tr>
<tr>
<td> path </td> <td> - </tb> <td> Path para as variáveis do MS. Normalmente o padrão será 'kv/$bu/$stage' (ex: kv/store/hom ou kv/social/prd). Obrigatório </td>
</tr>
</table>


## Tabela de Parâmetros - Caso AWS SecretsManager

<table>
<tr>
<td> <b>Parametro</b> </td> <td> <b>Default</b> </td> <td> <b>Descrição</b> </td>
</tr>
<tr>
<td> enabled </td> <td> - </tb> <td> Indicador para habilitar ou não o external-secrets - true/false </td>
</tr>
<tr>
<td> type </td> <td> aws </tb> <td> Tipo de external-secrets a ser utilizado. Campo aceita <i>aws</i> ou <i>vault</i> </td>
</tr>
<tr>
<td> refreshInterval </td> <td> 1h </tb> <td> Tempo que o external-secrets espera para sincronizar novamente as variáveis </td>
</tr>
<tr>
<td> secretStore.region </td> <td> us-east-1 </tb> <td> Região onde se encontra o SecretsManager. Obrigatório </td>
</tr>
<tr>
<td> roleArn </td> <td> - </tb> <td> arn da IAM Role que será usada para acesso ao SecretsManager. Obrigatório </td>
</tr>
</table>
