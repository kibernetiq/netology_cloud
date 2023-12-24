# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

### Цели задания 

1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.

---
## Задание 1. Yandex Cloud

1. Настроить с помощью Terraform кластер баз данных MySQL.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость.  
 [network.tf#L1-L54](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/network.tf#L1-L54)
 - Разместить ноды кластера MySQL в разных подсетях.  
 [db.tf#L20-L39](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/db.tf#L20-L39)
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.  
 [db.tf#L18-L21](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/db.tf#L18-L21)
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.  
 [db.tf#L3](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/db.tf#L3)
 - Задать время начала резервного копирования — 23:59.  
 [db.tf#L18-L21](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/db.tf#L18-L21)
 - Включить защиту кластера от непреднамеренного удаления.  
 [db.tf#L7](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/db.tf#L7)
 - Создать БД с именем `netology_db`, логином и паролем.  
 [db.tf#L47-L60](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/db.tf#L47-L60)

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.  
 [network.tf#L6-L33](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/network.tf#L6-L33)
 - Создать отдельный сервис-аккаунт с необходимыми правами.  
 [sa.tf#L6-L94](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/sa.tf#L6-L94)
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.  
 [k8s.tf#L1-L42](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/k8s.tf#L1-L42)
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.  
 [k8s.tf#L39-L42](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/k8s.tf#L39-L42)
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.  
 [k8s.tf#L44-L89](https://github.com/kibernetiq/netology_cloud/blob/cloud-15-4/k8s.tf#L44-L89)  
Примечание: При добавлении воркер нод в кластер с автомасштабированием получил ошибку, для решения задал фиксированный размер.  
```
Error: error while requesting API to create Kubernetes node group: server-request-id = 2e15e7d0-e2b4-405f-ba4f-e733b39878fb server-trace-id = c6ef54d8bdbc4fb0:efa21521633b538c:c6ef54d8bdbc4fb0:1 client-request-id = dfd3c578-c995-4d30-89fb-b9e5a8f731e8 client-trace-id = 514c6d23-b0d4-45e9-9003-2f8a2bd3194e rpc error: code = InvalidArgument desc = Validation error:
│ allocation_policy.locations: auto scale node groups can have only one location
```

 - Подключиться к кластеру с помощью `kubectl`.
```
yura@Skynet cloud % yc managed-kubernetes cluster list
+----------------------+--------------+---------------------+---------+---------+-------------------------+----------------------+
|          ID          |     NAME     |     CREATED AT      | HEALTH  | STATUS  |    EXTERNAL ENDPOINT    |  INTERNAL ENDPOINT   |
+----------------------+--------------+---------------------+---------+---------+-------------------------+----------------------+
| cat0bpalp5haosij9dlt | k8s-regional | 2023-12-25 10:32:03 | HEALTHY | RUNNING | https://158.160.139.144 | https://192.168.2.15 |
+----------------------+--------------+---------------------+---------+---------+-------------------------+----------------------+
```

```
yura@Skynet cloud % yc managed-kubernetes cluster list-nodes cat0bpalp5haosij9dlt 
+--------------------------------+---------------------------+--------------------------------+-------------+--------+
|         CLOUD INSTANCE         |      KUBERNETES NODE      |           RESOURCES            |    DISK     | STATUS |
+--------------------------------+---------------------------+--------------------------------+-------------+--------+
| epd3u402mttcske960g8           | cl1jonkscrrcsa9mnf7p-etum | 2 100% core(s), 2.0 GB of      | 64.0 GB hdd | READY  |
| RUNNING_ACTUAL                 |                           | memory                         |             |        |
| ef3e57q3gaaglv1mepnl           | cl1jonkscrrcsa9mnf7p-udoj | 2 100% core(s), 2.0 GB of      | 64.0 GB hdd | READY  |
| RUNNING_ACTUAL                 |                           | memory                         |             |        |
| fhmb5v27lhlsp0cue8mm           | cl1jonkscrrcsa9mnf7p-uwah | 2 100% core(s), 2.0 GB of      | 64.0 GB hdd | READY  |
| RUNNING_ACTUAL                 |                           | memory                         |             |        |
+--------------------------------+---------------------------+--------------------------------+-------------+--------+
```
```
yura@Skynet cloud % kubectl get nodes
NAME                        STATUS   ROLES    AGE   VERSION
cl1jonkscrrcsa9mnf7p-etum   Ready    <none>   33m   v1.25.4
cl1jonkscrrcsa9mnf7p-udoj   Ready    <none>   34m   v1.25.4
cl1jonkscrrcsa9mnf7p-uwah   Ready    <none>   33m   v1.25.4
```