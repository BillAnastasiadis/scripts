steps="${step_context}"
job=$1
repo_url="https://github.com/$2"
run_url="https://github.com/$2/actions/runs/$3"
results=""
if [ -z "$steps" ]
then
  exit 0
else
  for k in $(jq -c 'keys[]' <<< "$steps"); do
    outcome="$(jq -c ".${k}.outcome" <<< "$steps")"
    if [[ $outcome != \"success\" ]]
    then
      if [ -z "$results" ]
      then
        results="<p><b>There are failures in the Github Actions pipeline for repo"
        results="${results}<a href='${repo_url}'>${2}</a></b></p>"
        results="${results}<table><tr><th>Job</th><th>Step</th><th>State</th></tr>"
      fi
      pipeline="$(sed -e 's/^"//' -e 's/"$//' <<<"$k")"
      outcome="$(sed -e 's/^"//' -e 's/"$//' <<<"$outcome")"
      results="${results}<tr><td><a href='${run_url}'>${job}</td><td>${pipeline}</td><td>${outcome}</td></tr>"
    else
      if [ -z "$results" ]
      then
        repo_url="$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' <<< "$repo_url")"
        repo="$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' <<< "$2")"
        results="<p><b>There are failures in the Github Actions pipeline for repo"
        results="${results}<a href='${repo_url}'>${repo}</a></b></p>"
        results="${results}<table><tr><th>Job</th><th>Step</th><th>State</th></tr>"
      fi
      pipeline="$(sed -e 's/^"//' -e 's/"$//' <<<"$k")"
      outcome="$(sed -e 's/^"//' -e 's/"$//' <<<"$outcome")"
      run_url="$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' <<< "$run_url")"
      job="$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' <<< "$job")"
      results="${results}<tr><td><a href='${run_url}'>${job}</td><td>${pipeline}</td><td>${outcome}</td></tr>"
    fi
    if [ -n "$results" ]; then
      results="${results}</table>"
    else
      exit 0
    fi
  done
fi
echo "::set-output name=result::${results}"
exit 1