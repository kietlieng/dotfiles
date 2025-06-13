## Workflow:
# terraform init
# terraform plan
# terraform apply

alias tf="terraform"
alias impaccount="echo \"$IMPERVA_SITE1_ID\" | pbcopy"
alias tap="tapply"
alias tapa="tapply -a"
alias tfdebug="export TF_LOG=DEBUG; export TF_LOG_PATH=\"debug.log\""
alias tfdebugoff="unset TF_LOG; unset TF_LOG_PATH"
alias tfinit="terraform init --upgrade"
alias tfmigrate="terraform init -migrate-state"
alias tfreconfigure="terraform init -reconfigure"
alias tp="tplan"
alias tpa="tplan && tapply"
alias tplangraph="terraform graph -type=plan"
alias tplangraphpic="terraform graph -type=plan | dot -Tpng > graph.png"

# reset parallel
function tfpar() {

  local currentLocation=$(pwd)
  local parallelSetting="$TFE_PLAN_PARALLELISM"

  if [[ $currentLocation == *"imperva"* ]]; then
    parallelSetting="$TFE_PLAN_PARALLELISM_IMPERVA"
  fi

  if [[ $# -gt 0 ]]; then
    parallelSetting="$1"
    shift
  fi

  export TF_CLI_ARGS_plan="-parallelism=$parallelSetting"
  pecho "$TF_CLI_ARGS_plan"

}

# auto approve td
function tdestroy() {
    terraform destroy -auto-approve
}

# deletes local tf
function tdelete() {

    modeDeleteAll="f"

    while [[ $# -gt 0 ]];
    do
        key="$1"
        case $key in
            '-a' )
                modeDeleteAll="t"
                shift
                ;;
            * )
                shift
                ;;
        esac
    done

    if [[ $modeDeleteAll = 't' ]]; then
        rm -rf .terraform
    fi

    rm -f terraform.tfstate*
    rm -f .terraform.lock.hcl

}

# will take the directory path and create a hash value out of it. 
# this hash value will be the output in the tmp directory
# avoids overwriting tf outputs
function tplan() {

    impenv
    tfpar

    local destroyMode="f"
    local hashDir=$(hashdir)
    local outfile="tfout-${hashDir}"
    echo "hash $hashDir"

    while [[ $# -gt 0 ]];
    do

        key="$1"
        case $key in
            '-d' )
                destroyMode="t"
                shift
                ;;
            * )
                outfile="${outfile}_$key"
                shift
                ;;
        esac

    done
    outfile="${outfile//_/}"


    if [[ $destroyMode = 't' ]]; then

        terraform plan -destroy

    else

      # output to plan 
      if [[ $outfile ]]; then
        terraform plan -out="/tmp/$outfile"
      else
        terraform plan
      fi

    fi

}

# terraform apply with the hash value output
function tapply() {

  tfpar
  local destroyMode="f"
  local destroyMode="f"
  local autoApply="f"
  local hashDir=$(md5 -q -s $(pwd))
  local outfile="tfout-${hashDir}"
  local key=''
  echo "hash $hashDir"


  while [[ $# -gt 0 ]]; do

      key="$1"
      shift

      case $key in
          '-d' )
              destroyMode="t"
              ;;
          '-a' )
              autoApply="t"
              ;;
          * )
              outfile="${outfile}_$key"
              ;;
      esac

  done

  outfile="${outfile//_/}"

  if [[ $destroyMode == 't' ]]; then

      #terraform apply -destroy
      terraform apply 

  else

      #terraform apply -auto-approve
      if [[ $autoApply == 't' ]]; then

        if [[ $outfile ]]; then
          terraform plan -auto-approve "/tmp/$outfile"
        else
          terraform plan -auto-approve
        fi

      else

        if [[ $outfile ]]; then
          terraform apply "/tmp/$outfile"
        else
          terraform apply
        fi
      fi

  fi

}

function tawslist() {

    #echo "$tfResource resource |$resource|"
    case $1 in

        'aws_cloudfront_distribution' )
            aws cloudfront list-distributions | jq '.DistributionList.Items[] | .Id + " " + .Comment'
            ;;
        'aws_wafv2_web_acl' )
            echo "**** FORMAT: format is aws_wafv2_web_acl.unbreakable_disable [ID]/[NAME]/CLOUDFRONT"
            aws wafv2 list-web-acls --scope=CLOUDFRONT --region=us-east-1 | jq '.WebACLs[] | .Id + "/" + .Name + "/CLOUDFRONT"'
            ;;
        'aws_wafv2_ip_set' )
            echo "**** FORMAT: aws_wafv2_web_acl.unbreakable_disable [ID]/[NAME]/CLOUDFRONT"
            aws wafv2 list-ip-sets --scope CLOUDFRONT --region=us-east-1 | jq '.IPSets[] | .Id + "/" + .Name + "/CLOUDFRONT"'
            ;;
        #'aws_iam_policy' )
        #    aws iam list-policies | grep -i "policyName\|PolicyID\|ARN"
        #    ;;

        'aws_s3_bucket' )
            aws s3api list-buckets | jq '.Buckets[] | .Name' > .s3Buckets
            echo "Bucket names are listed in .s3Buckets file"
            ;;

        'aws_cloudfront_origin_access_control' )
            echo "**** FORMAT: aws_cloudfront_origin_access_control.default [ID]"
            #aws cloudfront list-origin-access-controls | grep -i "name\|id"
            aws cloudfront list-origin-access-controls | jq '.OriginAccessControlList.Items[] | .Id + " " + .Name'
            ;;

        * )
            ;;

    esac

}

function tres() {

    doList="f"
    findResource="f"

    while [[ $# -gt 0 ]];
    do

        key="$1"
        case $key in
            "-l" )
                doList="t"
                shift
                ;;

            "-f" )
                findResource="t"
                shift
                ;;
            * )
                shift
                ;;
        esac

    done

    if [[ $doList = "t" ]];
    then

        grep -irl "resource"  --include=\*.tf *

    else

        tfOutput=$(grep -irh "resource" --include=\*.tf * | awk '{print $2 "." $3 }' |  sed 's/"//g' | sort | uniq)
        tfUOutput=$(grep -irh "resource" --include=\*.tf * | awk '{print $2 }' |  sed 's/"//g' | sort | uniq)
        for tfResource in $( echo $tfUOutput );
        do

            #echo "$tfResource"

            if [[ $findResource = "t" ]];
            then

                currentResource=$(echo $tfResource | awk -F'.' '{print $1}')
                echo "\n\n$currentResource"
                tawslist $currentResource
            fi

        done

        echo "\n\nResources:\n$tfOutput"

    fi
}


function timport() {

    terraform import $1 $2

}

function tstates() {

    editMode="f"
    removeMode="f"
    removeTarget=""

    while [[ $# -gt 0 ]];
    do

        key="$1"
        case $key in
            '-e' )
                editMode="t"
                shift
                ;;
            '-rm' )
                removeMode="t"
                removeTarget="$2"
                shift
                shift
                ;;
            * )
                shift
                ;;
        esac

    done

    if [[ $editMode = 't' ]]; then

        echo "do something else"
        vim terraform.tfstate

    elif [[ $removeMode = 't' ]]; then

        terraform states rm $removeTarget

    else

        terraform state list

    fi

}


function tflock() {
  
  lockID=$(tapply 2>&1 | grep -A 100 -i "Lock Info:" | grep -io "ID:.*" | awk '{print $2}')
  echo "lockId $lockID"
  if [[ $lockID != "" ]]; then

    commandUnlock="terraform force-unlock $lockID"
    echo "$commandUnlock"
    echo -n "$commandUnlock" | pbcopy
    terraform force-unlock $lockID

  fi

}

# show in terraform
function tfresource() {
  terraform show
}

function tspace() {

  if [[ $# -eq 0 ]]; then

    terraform workspace list
    return

  fi

  local workspace="$1"
  shift

  terraform workspace select $workspace || terraform workspace new $workspace

}

# remove resources
function tfrm() {
  terraform state rm $1
}
