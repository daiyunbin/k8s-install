helm repo add bitnami https://charts.bitnami.com/bitnami
helm fetch bitnami/elasticsearch
tar zxvf elasticsearch-xxx.tgz
cd elasticsearch/
vim values.yaml
修改需要修改的参数
helm install elastic -f values.yaml bitnami/elasticsearch --namespace elastic


NOTES:
-------------------------------------------------------------------------------
 WARNING

    Elasticsearch requires some changes in the kernel of the host machine to
    work as expected. If those values are not set in the underlying operating
    system, the ES containers fail to boot with ERROR messages.

    More information about these requirements can be found in the links below:

      https://www.elastic.co/guide/en/elasticsearch/reference/current/file-descriptors.html
      https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

    This chart uses a privileged initContainer to change those settings in the Kernel
    by running: sysctl -w vm.max_map_count=262144 && sysctl -w fs.file-max=65536

** Please be patient while the chart is being deployed **

  Elasticsearch can be accessed within the cluster on port 9200 at elastic-elasticsearch-coordinating-only.elastic.svc.cluster.local

  To access from outside the cluster execute the following commands:

    kubectl port-forward --namespace elastic svc/elastic-elasticsearch-coordinating-only 9200:9200 &
    curl http://127.0.0.1:9200/