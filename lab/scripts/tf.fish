## Workflow:
# terraform init
# terraform plan
# terraform apply

alias tf="terraform"
alias impaccount="echo \"$IMPERVA_SITE1_ID\" | pbcopy"
alias tap="tapply"
alias tapa="tapply -a"
alias tfdebug="set -gx TF_LOG DEBUG; set -gx TF_LOG_PATH \"debug.log\""
alias tfdebugoff="set -e TF_LOG; set -e TF_LOG_PATH"
alias tfinit="terraform init --upgrade"
alias tfmigrate="terraform init -migrate-state"
alias tfreconfigure="terraform init -reconfigure"
alias tp="tplan"
alias tptrace="tplan -t"
alias tpa="tplan && tapply"
alias tplangraph="terraform graph -type=plan"
alias tplangraphpic="terraform graph -type=plan | dot -Tpng > graph.png"

# reset parallel
function tfpar

  set currentLocation $(pwd)
  set parallelSetting "$TFE_PLAN_PARALLELISM_DEFAULT"

  if string match -iq "*imperva*" $currentDirectory
    set parallelSetting "$TFE_PLAN_PARALLELISM_IMPERVA"
  end

  if test (count $argv) -gt 0
    set parallelSetting "$argv[1]"
    set argv $argv[2..-1]
  end

  set -gx  TF_CLI_ARGS_plan "-parallelism=$parallelSetting"
  pecho "$TF_CLI_ARGS_plan"

end

# auto approve td
function tdestroy
    terraform destroy -auto-approve
end

# deletes local tf
function tdelete

  set modeDeleteAll "f"

  while test (count $argv) -gt 0
    set key "$argv[1]"
    set argv $argv[2..-1]
    switch $key
      case '-a'; set modeDeleteAll "t"
    end
  end

  if [ "$modeDeleteAll" = 't' ]
    rm -rf .terraform
  end

  rm -f terraform.tfstate*
  rm -f .terraform.lock.hcl

end

function tftimelimit

  set -e AWS_CREDENTIAL_EXPIRATION
  source $FILE_AWS_TEMP

  if [ -z $AWS_CREDENTIAL_EXPIRATION ]
    echo "No expiration present"
    return
  end

  set nowEpoch $(date +%s)

  # Calculate time difference in minutes
  set diffMinutes $(math "($AWS_EPOCH - $nowEpoch) / 60")

  echo "Expire time: $AWS_CREDENTIAL_EXPIRATION (in $diffMinutes minutes)"
  if [ $diffMinutes -lt 30 ]
    echo "NO TIME LEFT TO RUN APPLY!!!"
  end

end

# will take the directory path and create a hash value out of it. 
# this hash value will be the output in the tmp directory
# avoids overwriting tf outputs
function tplan

  tftimelimit
  impenv
  tfpar

  set modeTrace ''
  set modeDebug ''
  set modeDestroy "f"
  set hashDir $(hashdir)
  set outfile "tfout-$hashDir"
  echo "hash $hashDir"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-d'
        set modeDestroy "t"
      case '-t'
        set modeTrace "t"

      case '-debug'
        set modeDebug "t"

      case '*'
        set outfile "$outfile_$key"
    end
  end
  set outfile (string trim --chars '_' $outfile)

  set -e TF_LOG
  if [ -n $modeTrace ]
    set -gx TF_LOG TRACE
  end
  if [ -n $modeDebug ]
    set -gx TF_LOG DEBUG
  end

  if [ "$modeDestroy" = 't' ]

    terraform plan -destroy

  else

    # output to plan 
    if [ "$outfile" ]

      terraform plan -out="/tmp/$outfile"

    else

      terraform plan

    end

  end

end

# terraform apply with the hash value output
function tapply

  tfpar
  set modeDestroy "f"
  set autoApply "f"
  set hashDir $(md5 -q -s $(pwd))
  set outfile "tfout-$hashDir"
  set key ''
  echo "hash $hashDir"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-d'; set modeDestroy "t"
      case '-a'; set autoApply "t"
      case '*'; set outfile "$outfile_$key"
    end

  end

  set outfile (string trim --chars '_' $outfile)

  if [ "$modeDestroy" = 't' ]

      #terraform apply -destroy
      terraform apply 

  else

      #terraform apply -auto-approve
      if [ "$autoApply" = 't' ]

        if [ $outfile ]
          terraform plan -auto-approve "/tmp/$outfile"
        else
          terraform plan -auto-approve
        end

      else

        if [ "$outfile" ]
          terraform apply "/tmp/$outfile"
        else
          terraform apply
        end
      end

  end

end

function tawslist

  #echo "$tfResource resource |$resource|"
  switch $argv[1]

    case 'aws_cloudfront_distribution'
      aws cloudfront list-distributions | jq '.DistributionList.Items[] | .Id + " " + .Comment'
    case 'aws_wafv2_web_acl'
      echo "**** FORMAT: format is aws_wafv2_web_acl.unbreakable_disable [ID]/[NAME]/CLOUDFRONT"
      aws wafv2 list-web-acls --scope=CLOUDFRONT --region=us-east-1 | jq '.WebACLs[] | .Id + "/" + .Name + "/CLOUDFRONT"'
    case 'aws_wafv2_ip_set'
      echo "**** FORMAT: aws_wafv2_web_acl.unbreakable_disable [ID]/[NAME]/CLOUDFRONT"
      aws wafv2 list-ip-sets --scope CLOUDFRONT --region=us-east-1 | jq '.IPSets[] | .Id + "/" + .Name + "/CLOUDFRONT"'
    #case 'aws_iam_policy'
    #    aws iam list-policies | grep -i "policyName\|PolicyID\|ARN"

    case 'aws_s3_bucket'
      aws s3api list-buckets | jq '.Buckets[] | .Name' > .s3Buckets
      echo "Bucket names are listed in .s3Buckets file"

    case 'aws_cloudfront_origin_access_control'
      echo "**** FORMAT: aws_cloudfront_origin_access_control.default [ID]"
      #aws cloudfront list-origin-access-controls | grep -i "name\|id"
      aws cloudfront list-origin-access-controls | jq '.OriginAccessControlList.Items[] | .Id + " " + .Name'

  end

end

function tres

  set doList "f"
  set findResource "f"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch $key
      case '-l'
        set doList "t"
      case '-f'
        set findResource "t"
    end

  end

  if [ "'$doList" = "t" ]

    grep -irl "resource"  --include=\*.tf *

  else

    set tfOutput $(grep -irh "resource" --include=\*.tf * | awk '{print $2 "." $3 }' |  sed 's/"//g' | sort | uniq)
    set tfUOutput $(grep -irh "resource" --set include \*.tf * | awk '{print $2 }' |  sed 's/"//g' | sort | uniq)
    for tfResource in $( echo $tfUOutput )

      #echo "$tfResource"
      if [ "$findResource" = "t" ]
        set currentResource $(echo $tfResource | awk -F'.' '{print $argv[1]}')
        echo "\n\n$currentResource"
        tawslist $currentResource

      end
      echo "\n\nResources:\n$tfOutput"
    end
  end
end


function timport

    terraform import $argv[1] $argv[2]

end

# remove state from terraform local file
#terraform state rm 'module.incapsula_sidearms["gameday.cottonbowl.com"].incapsula_cache_rule.all["2"]'

function tstates

    set editMode "f"
    set removeMode "f"
    set removeTarget ""

    while test (count $argv) -gt 0
    do

        set key "$argv[1]"
        switch $key
            case '-e'
                set editMode "t"
                set argv $argv[2..-1]
            case '-rm'
                set removeMode "t"
                set removeTarget "$argv[2]"
                set argv $argv[2..-1]
                set argv $argv[2..-1]
            case '*'
                set argv $argv[2..-1]
        end

    end

    if [ "$editMode" = 't' ]

        echo "do something else"
        vim terraform.tfstate

    elif [ "$removeMode" = 't' ]

        terraform states rm $removeTarget

    else

        terraform state list

    end

end


function tfunlock
  
  set lockID $(tplan 2>&1 | grep -A 100 -i "Lock Info:" | grep -io "ID:.*" | awk '{print $2}')
  echo "lockId $lockID"
  if [ "$lockID" != "" ]

    set commandUnlock "terraform force-unlock $lockID"
    echo "$commandUnlock"
    echo -n "$commandUnlock" | pbcopy
    terraform force-unlock $lockID

  end

end

# show in terraform
function tfresource
  terraform show
end

function tspace

  if test (count $argv) -gt 0

    terraform workspace list
    return

  end

  set workspace "$argv[1]"
  set argv $argv[2..-1]

  terraform workspace select $workspace || terraform workspace new $workspace

end

# remove resources
function tfrm
  terraform state rm $argv[1]
end

function tfremove

  echo "terraform state rm 'module.incapsula_sidearms[\"gameday.cottonbowl.com\"].incapsula_cache_rule.all[\"2\"]'"

end

