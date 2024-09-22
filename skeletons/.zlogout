# Kill ssh-agent on logout if it exists
if [[ -v SSH_AGENT_PID ]];
then
    kill -9 $SSH_AGENT_PID
fi
