O princípio aplicado é de gerar um artefato chamado 'secretStore' e do artefato 'external-secrets'. O secretstore define e realiza a autenticação com o provedor das variáveis, enquanto o external-secrets define quais variáveis serão buscadas nesse provedor. Essa combinação gera um terceiro artefato do tipo 'secret' chamado 'envs', onde ficam armazenadas as variáveis do serviço. 

O padrão foi baseado no Vault, porém há também a possibilidade de uso com o AWS SecretsManager.

É possível declarar múltiplos externalSecrets, com o propósito de fazer o acesso a mais de um secret engine. Um caso de uso comum é o acesso ao secret engine da BU (kv/$bu/hom) em conjunto com o secret engine global (kv/global/hom).


Para usar a secret, é declarado o parametro `envsFrom` nos deployments.
```yaml
      ...
      envFrom:
        - secretRef:
            name: envs
        - secretRef:
            name: envs-second-externalsecret
        ...
```

## Definição de parametros do external-secrets

<table>
<tr>
<td> Antes </td> <td> Depois </td>
</tr>
<tr>
<td>

Para uso com Vault:

```yaml
global:
  externalSecrets:
    enabled: true
    type: vault
    refreshInterval: 5m
    mountPath: kubernetes-xxxx-xxxx-hom
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

<td>
Para uso com Vault:

```yaml
global:
  externalSecrets:
    - enabled: true
      name: default
      type: vault
      refreshInterval: 5m
      mountPath: kubernetes-xxxxx-xxx-hom
      path: kv/xxxx/hom
      dataFrom:
        - secretFile: ms-example
    - enabled: true
      name: second-externalsecret
      type: vault
      mountPath: kubernetes-xxxx-use1-hom
      path: kv/global/hom
      dataFrom:
        - secretFile: global
```

Para uso com AWS SecretManager:
```yaml
global:
  externalSecrets:
    - enabled: true
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
<td> name </td> <td> - </tb> <td> Nome do artefato external-secrets. É indicado que o ES que aponta para as variáveis "padrões" se chame 'default' ou 'envs' </td>
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
<td> mountPath </td> <td> - </tb> <td> Path do cluster para autenticação com o Vault. Normalmente será 'kubernetes-$clusterName' (ex: kubernetes-xxxxx-use1-hom ou kubernetes-xxxxx-use1-prd). Obrigatório </td>
</tr>
<tr>
<td> path </td> <td> - </tb> <td> Path para as variáveis do MS. Normalmente o padrão será 'kv/$bu/$stage' (ex: kv/xxxx/hom ou kv/xxxx/prd). Obrigatório </td>
</tr>
<tr>
<td> dataFrom </td> <td> - </tb> <td> Contém uma lista <b>- secretFile: value</b> indicando de qual arquivo de variáveis acessar, dentro do path indicado. Obrigatório ter pelo menos 1 chave. </td>
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
