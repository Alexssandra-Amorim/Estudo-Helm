# CP-Kafka Connect Helm Chart

This chart bootstraps a deployment of a Confluent Kafka Connect

## Release Notes

0.3.0

- Adding external-secrets.


0.2.0
- Add cronjob for restarting failed tasks using `restartFailedTasks.enabled`. For more details: https://bityli.com/rrggADc

## Prerequisites

* Kubernetes 1.9.2+
* Helm 2.8.2+
* A healthy and accessible Kafka Cluster


## Docker Image Source:

* [DockerHub -> ConfluentInc](https://hub.docker.com/u/confluentinc/)

## Configuration

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install --name my-kafka-connect -f my-values.yaml ./kafka-connect
```

> **Tip**: A default [values.yaml](values.yaml) is provided

### Kafka Connect Deployment

The configuration parameters in this section control the resources requested and utilized by the `kafka-connect` chart.

| Parameter         | Description                           | Default   |
| ----------------- | ------------------------------------- | --------- |
| `replicaCount`    | The number of Kafka Connect Servers.  | `1`       |
| `.Values.global.externalSecrets.enabled`    | External secrets.  | `false`       |

### Image

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image` | Docker Image of Confluent Kafka Connect. | `confluentinc/cp-kafka-connect` |
| `imageTag` | Docker Image Tag of Confluent Kafka Connect. | `6.1.0` |
| `imagePullPolicy` | Docker Image Tag of Confluent Kafka Connect. | `IfNotPresent` |
| `imagePullSecrets` | Secrets to be used for private registries. | see [values.yaml](values.yaml) for details |

### Port

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `servicePort` | The port on which the Kafka Connect will be available and serving requests. | `8083` |

### Kafka Connect Worker Configurations

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `configurationOverrides` | Kafka Connect [configuration](https://docs.confluent.io/current/connect/references/allconfigs.html) overrides in the dictionary format. | `{}` |
| `customEnv` | Custom environmental variables | `{}` |

### Volumes

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `volumes` | Volumes for connect-server container | see [values.yaml](values.yaml) for details |
| `volumeMounts` | Volume mounts for connect-server container | see [values.yaml](values.yaml) for details |

### Secrets

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `secrets` | Secret with one or more `key:value` pairs | see [values.yaml](values.yaml) for details |

### Kafka Connect JVM Heap Options

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `heapOptions` | The JVM Heap Options for Kafka Connect | `"-Xms512M -Xmx512M"` |

### Resources

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `resources.requests.cpu` | The amount of CPU to request. | see [values.yaml](values.yaml) for details |
| `resources.requests.memory` | The amount of memory to request. | see [values.yaml](values.yaml) for details |
| `resources.requests.limit` | The upper limit CPU usage for a Kafka Connect Pod. | see [values.yaml](values.yaml) for details |
| `resources.requests.limit` | The upper limit memory usage for a Kafka Connect Pod. | see [values.yaml](values.yaml) for details |

### Annotations

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `podAnnotations` | Map of custom annotations to attach to the pod spec. | `{}` |

### JMX Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `jmx.port` | The jmx port which JMX style metrics are exposed. | `5555` |

### Prometheus JMX Exporter Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `prometheus.jmx.enabled` | Whether or not to install Prometheus JMX Exporter as a sidecar container and expose JMX metrics to Prometheus. | `true` |
| `prometheus.jmx.image` | Docker Image for Prometheus JMX Exporter container. | `solsson/kafka-prometheus-jmx-exporter` |
| `prometheus.jmx.imageTag` | Docker Image Tag for Prometheus JMX Exporter container. | `6f82e2b0464f50da8104acd7363fb9b995001ddff77d248379f8788e78946143` |
| `prometheus.jmx.imagePullPolicy` | Docker Image Pull Policy for Prometheus JMX Exporter container. | `IfNotPresent` |
| `prometheus.jmx.port` | JMX Exporter Port which exposes metrics in Prometheus format for scraping. | `5556` |
| `prometheus.jmx.resources` | JMX Exporter resources configuration. | see [values.yaml](values.yaml) for details |

### Running Custom Scripts

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `customEnv.CUSTOM_SCRIPT_PATH` | Path to external bash script to run inside the container | see [values.yaml](values.yaml) for details |
| `livenessProbe` | Requirement of `livenessProbe` depends on the custom script to be run  | see [values.yaml](values.yaml) for details |
| `readinessProbe` | Requirement of `readinessProbe` depends on the custom script to be run  | see [values.yaml](values.yaml) for details |

### Deployment Topology

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `nodeSelector` | Dictionary containing key-value-pairs to match labels on nodes. When defined pods will only be scheduled on nodes, that have each of the indicated key-value pairs as labels. Further information can be found in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) | `{}`
| `tolerations`| Array containing taint references. When defined, pods can run on nodes, which would otherwise deny scheduling. Further information can be found in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) | `{}`

### Kafka Connect UI

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `webui.enabled` | managemente kafka connect from WebUI. `true` or `false` | `false`
| `ingressClass`| Ingress Class | `internal-microservices`
| `host`| Ingress hostname | `{{ .Values. fullnameOverride }}.ms.{{ .Values.globbal.app_stage}}`. see [values.yaml](values.yaml) for details

### Cronjob for Restarting Failed Tasks

Automatically restarting failed Kafka Connect tasks
| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `restartFailedTasks.enabled` | Restart failed connector tasks. `true` or `false` | `true`
| `restartFailedTasks.image`| Container Image | `image.dkr.ecr.us-east-1.amazonaws.com/dev/ms`
| `restartFailedTasks.schedule` | Cron schedule | `"*/5 * * * *"`
| `restartFailedTasks.resources` | Restart failed tasks resources configuration. | see [values.yaml](values.yaml) for details |
