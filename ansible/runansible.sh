cd "$(dirname "$0")"
echo "------------------------------------"
echo "Running ansible playbook"
echo "------------------------------------"

ansible-playbook --verbose n01603990-playbook.yml

echo "------------------------------------"
echo "Completed ansible playbook"
echo "------------------------------------"