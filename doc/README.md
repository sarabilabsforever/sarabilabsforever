# sarabilabsforever

```yaml
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml
# Copied article from
# https://github.com/WOA-Project/Lumia950XLPkg/blob/master/azure-pipelines.yml

trigger:
  - main

pool:
  vmImage: ubuntu-latest

variables:
  - group: AWS Credentials

steps:

  - script: sudo apt update
    displayName: 'Update APT sources'

  - script: echo Hello, world!
    displayName: 'Run a one-line script'

  - script: ./Tools/CI/Bootstrapper/init.sh
    displayName: 'Prepare pre-build environment, init phase'

  - script: ./Tools/CI/Builder/Build.sh
    displayName: 'build phase'

  - script: |
      echo Add other tasks to build, test, and deploy your project.
      echo See https://aka.ms/yaml
    displayName: 'Run a multi-line script'

  - script: |
      sudo pip3 install --upgrade pip
      pip3 install awscli --upgrade --user
      export PATH="/home/vsts/.local/bin:$PATH"
      aws --version
      echo What
      echo $AWS_ACCESS_KEY_ID
    displayName: 'Install AWS CLI'


``` 

```yaml
---
name: $(BuildDefinitionName)_$(Date:yyyyMMdd)$(Rev:.rr)

trigger:
  - main

jobs:
  - job: macOS
    pool:
      vmImage: "macOS-latest"
    timeoutInMinutes: 180
    steps:
      - task: shellexec@0
        displayName: "Display Build Number"
        inputs:
          code: |
            echo building $(Build.BuildNumber)
      - task: shellexec@0
        displayName: "Brew Update"
        inputs:
          code: |
            brew --version
            brew doctor
            brew update
      - task: shellexec@0
        displayName: "Check Python Version"
        inputs:
          code: |
            brew install python@3.9
            brew postinstall python@3.9
            python3 --version
            pip --version
      - task: shellexec@0
        displayName: "Install AWS CLI2"
        inputs:
          code: |
            pwd
            ls -lsa
            curl --version
            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
            sudo installer -pkg AWSCLIV2.pkg -target /
            aws --version

```



```yaml
---
---
name: $(BuildDefinitionName)_$(Date:yyyyMMdd)$(Rev:.rr)

trigger:
  - main

jobs:
    - job: Windows
      pool:
        vmImage: 'vs2017-win2016'
      timeoutInMinutes: 180
      steps:
      - task: InlinePowershell@1
        displayName: Calling Powershell
        inputs:
          Script: 'Write-Output ''Hello world'''
      - task: InlinePowershell@1
        displayName: Chocolatey Version
        inputs:
          Script: |
            choco
        - task: InlinePowershell@1
        displayName: Install Python
        inputs:
          Script: |
            choco install python3 --pre 
          - task: InlinePowershell@1
        displayName: Install AWS CLI2
        inputs:
          Script: |
            choco install awscli
          - task: InlinePowershell@1
        displayName: Check Version(s)
        inputs:
          Script: |
            python --version
            aws --version
    
```