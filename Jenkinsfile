def label = "slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
  containerTemplate(name: 'maven', image: 'maven:3.6-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'kubectl', image: 'cnych/kubectl', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'helm', image: 'cnych/helm', command: 'cat', ttyEnabled: true)
], volumes: [
  hostPathVolume(mountPath: '/root/.m2', hostPath: '/var/run/m2'),
  hostPathVolume(mountPath: '/home/jenkins/.kube', hostPath: '/root/.kube'),
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  hostPathVolume(mountPath: '/etc/docker', hostPath: '/etc/docker'),
  hostPathVolume(mountPath: '/etc/hosts', hostPath: '/etc/hosts')
]) {
node(label) {
  def myRepo = checkout scm
  def gitCommit = myRepo.GIT_COMMIT
  def gitBranch = myRepo.GIT_BRANCH

  def imageTag = "v1.3"
  def dockerRegistryUrl = "hbr.hf.cn"
  def imageEndpoint = "test/solo"
  def image = "${dockerRegistryUrl}/${imageEndpoint}"

  stage('代码编译打包') {
    try {
      container('maven') {
        echo "2. 代码编译打包阶段"
        sh "mvn clean package -Dmaven.test.skip=true"
      }
    } catch (exc) {
      println "构建失败 - ${currentBuild.fullDisplayName}"
      throw(exc)
    }
  }
  stage('构建 Docker 镜像') {
    withCredentials([[$class: 'UsernamePasswordMultiBinding',
      credentialsId: 'dockerhbr',
      usernameVariable: 'DOCKER_HUB_USER',
      passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
        container('docker') {
          echo "3. 构建 Docker 镜像阶段"
          sh """
            docker login https://${dockerRegistryUrl} -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
            docker build -t ${image}:${imageTag} .
            docker push ${image}:${imageTag}
            docker rmi -f ${image}:${imageTag}
            #sleep 3600
            """
        }
    }
  }
  stage('运行 Kubectl') {
      container('kubectl') {
        echo "创建对象"
        sh """
           #kubectl delete -f deployment.yaml
           kubectl apply -f deployment.yaml
           #kubectl create -f service.yaml
           #kubectl create -f ingress.yaml
           kubectl get pods --all-namespaces
           """
      }
    }
  }
}  
