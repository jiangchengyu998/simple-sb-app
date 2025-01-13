pipeline {
  agent any

  environment{
      harborHost = '192.168.101.102:80'
      harborRepo = 'repo'
      harborUser = 'admin'
      harborPasswd = 'Harbor12345'
      spProjectName = 'simple-sb-app'
  }

  stages {
      stage('拉取Git代码') {
          steps {
              checkout([$class: 'GitSCM', branches: [[name: '${tag}']],
              extensions: [], userRemoteConfigs: [[url:
              'https://github.com/jiangchengyu998/simple-sb-app.git']]])
          }
      }
      stage('Extract Branch') {
          steps {
              script {
                  // 提取 main 部分
                  def branch = params.tag.tokenize('/').last()
                  echo "Extracted Branch: ${branch}"
                  env.MY_VAR = "${branch}"
              }
          }
      }
      stage('构建代码') {
          steps {
              sh '/var/jenkins_home/maven/bin/mvn clean install package -DskipTests'
          }
      }
      stage('检测代码质量') {
            steps {
                sh '/var/jenkins_home/sonar-scanner/bin/sonar-scanner ' +
                   '-Dsonar.source=./ ' +
                   '-Dsonar.projectName=${JOB_NAME} ' +
                   '-Dsonar.projectKey=${JOB_NAME} ' +
                   '-Dsonar.java.binaries=./target ' +
                   '-Dsonar.exclusions=**/*.java ' +
                   '-Dsonar.test.exclusions=**/*.java ' +
                   '-Dsonar.coverage.exclusions=**/*.java ' +
                   '-Dsonar.login=6da0d36ca3a51f8fa2fcad8cff37fd474f2d1a77'
            }
      }
      stage('制作自定义镜像并发布Harbor') {
          steps {
              sh '''
                  echo "MY_VAR value: "${env.MY_VAR}"" // 检查 MY_VAR 是否有值
                  mv target/*.jar docker/$spProjectName.jar
                  docker build -t $spProjectName:"${env.MY_VAR}" ./docker
                  docker login -u $harborUser -p $harborPasswd $harborHost
                  docker tag $spProjectName:"${env.MY_VAR}" $harborHost/$harborRepo/$spProjectName:"${env.MY_VAR}"
                  docker push $harborHost/$harborRepo/$spProjectName:"${env.MY_VAR}"
                  docker image prune -f
              '''
          }
      }
      stage('目标服务器拉取镜像并运行') {
          steps {
            sshPublisher(
                publishers: [
                    sshPublisherDesc(
                        configName: '102-jenkins',
                        transfers: [
                            sshTransfer(
                                cleanRemote: false,
                                excludes: '',
                                execCommand: "deploy.sh $harborHost $harborRepo $spProjectName "${env.MY_VAR}" $container_port $host_port",
                                execTimeout: 120000,
                                flatten: false,
                                makeEmptyDirs: false,
                                noDefaultExcludes: false,
                                patternSeparator: '[, ]+',
                                remoteDirectory: '',
                                remoteDirectorySDF: false,
                                removePrefix: '',
                                sourceFiles: ''
                            )
                        ],
                        usePromotionTimestamp: false,
                        useWorkspaceInPromotion: false,
                        verbose: false
                    )
                ]
            )
          }
      }

  }
}
