function csecure
  echo -e "getenforce; systemctl -a | grep -i \"table\\|fire\\|confluent\"" | pbcopy
end

alias yump "yum pack"

function yum

  set --local yumInstallPack ""
  set --local indirectReference ""
  set --local shouldExit 'f'
  set --local modePackageType 'yum'

  # array to do things
  # redhat specifics
  set packArray_rhsm "subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-source-rpms"
  set packArray_dnf "dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y"

  # centos
  set packArray_yum_pack "sudo yum install y epel-release; sudo yum install -y netcat mtr net-tools vim git wget htop iotop iftop unzip bind-utils gcc.x86_64; sudo yum groupinstall \"Development Tools\" -y; sudo yum install openssl-devel libffi-devel bzip2-devel -y;"
  set packArray_yum_rust "yum install -y rust cargo;"
  set packArray_yum_go "yum install -y go;"
  set packArray_yum_list "yum list kernel;"
  set packArray_yum_jdk "sudo yum install -y java-1.8.0-openjdk.x86_64;"
  set packArray_yum_docker "sudo yum install -y yum-utils device-mapper-persistent-data lvm2 && sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && sudo yum install -y docker-ce docker-ce-cli containerd.io"
  set packArray_yum_node "sudo yum update -y && curl –sL https://rpm.nodesource.com/setup_18.x | sudo bash - && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo && sudo yum install -y nodejs yarn redis libpng-devel git libvhdi-utils lvm2 cifs-utils make automake gcc gcc-c++"
  set packArray_yum_python "yum install -y python3"

  # dnf
  set packArray_dnf_pack "sudo dnf install -y netcat mtr net-tools vim git wget htop iotop iftop unzip bind-utils gcc.x86_64; sudo dnf install openssl-devel libffi-devel bzip2-devel -y;"

  #echo "pack rust go list jdk docker node"
  # for key val in "${(@kv)packArray}"
  #     echo -n "$key "
  # end

  echo ""

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key 

      case 'type'
        set modePackageType "$argv[1]"
        set argv $argv[2..-1]

      case 'pack' 'python'

        # use indirect reference to create a 2d array
        # echo "pack: |packArray| mode |$modePackageType| key |$key|"
        set indirectReference "packArray" "$modePackageType" "$key"
        set indirectJoin (string join -n "_" $indirectReference)
        # echo "update |$indirectJoin| |$$indirectJoin|"
        set yumInstallPack "$$indirectJoin"
        set shouldExit 't'

      case '*'

        set indirectReference "packArray" "$modePackageType" "$key"
        set indirectJoin (string join -n "_" $indirectReference)
        set yumInstallPack "$$indirectJoin"

    end

  end

  if [ $yumInstallPack ]
    echo "$yumInstallPack"
    echo -n $yumInstallPack | pbcopy
  end

  if [ $shouldExit = 't' ]
    exit
  end

end

function kernelremove
  echo -n "yum remove kernel " | pbcopy
end

function cdrives
  echo -n "ls -ltr /dev/hd*; ls -ltr /dev/sd*" | pbcopy
end

function caws
  echo -n "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"; unzip awscliv2.zip; sudo ./aws/install" | pbcopy
end

function ckub
  set command "curl -lo https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/bin/kubectl"
  if test (count $argv) -eq 0
    echo -n "$command" | pbcopy
  else
    echo -n "$command"
  end
end

function crke
 # remove older version
 set command "curl -lo https://github.com/rancher/rke/releases/download/v1.0.0/rke_linux-amd64 && chmod +x ./rke_linux-amd64 && sudo mv ./rke_linux-amd64 /usr/bin/rke"
 if test (count $argv) -eq 0
   echo -n "$command" | pbcopy
 else
   echo "$command"
 end
end

function chelm
 set command "curl -LO https://get.helm.sh/helm-v2.15.1-linux-amd64.tar.gz && tar -xvzf helm-v2.15.1-linux-amd64.tar.gz && chmod 755 linux-amd64/helm && sudo cp linux-amd64/helm /usr/bin/helm && rm -rf helm-v2.15.1-linux-amd64.tar.gz linux-amd64"
 if test (count $argv) -eq 0
   echo -n "$command" | pbcopy
 else
   echo "$command"
 end
end

function crancher
 set command1 $(centrke -c)
 set command2 $(centkub -c)
 set command3 $(centhelm -c)
 echo -n "$command1 && $command2 && $command3" | pbcopy
end

# for testing 2d arrays with dynamic variables
function 2d 

  set a "appleorange"
  set b "orange"
  set modePackageType "yum"
  set key "blah"
  set indirectReference -n "_" "packArray" "$modePackageType" "$key"
  set indirectJoin (string join $indirectReference)


  echo "blah $indirectJoin $$indirectJoin"

end
