# eks-kubectl

Access your EKS cluster via `kubectl` in a Github Action. No fuss, no messing around with special
kubeconfigs, just ensure you have `eks:ListCluster` and `eks:DescribeCluster` rights on your
user.

See [this great blog post](https://prabhatsharma.in/blog/amazon-eks-iam-authentication-how-to-add-an-iam-user/)
for an overview if you're using a new IAM user.

## Example configuration

### Supplying AWS credentials
You can supply your AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, the region your cluster is in, and the cluster name.

```yaml
jobs:
  jobName:
    name: Update deploy
    runs-on: ubuntu-latest 
    steps:
      # --- #
      - name: Build and push CONTAINER_NAME
        uses: ianbelcher/eks-kubectl-action@master
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: ${{ secrets.AWS_REGION }}
          cluster_name: ${{ secrets.CLUSTER_NAME }}
          eks_role_arn: ${{ secrets.EKS_ROLE_ARN }}
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
      # --- #
```

### Using the AWS credentials present on the environment
If credentials are already present on the environment you don't need to supply them.

```yaml
jobs:
  jobName:
    name: Update deploy
    runs-on: ubuntu-latest 
    env:
      aws_region: eu-central-1
    steps:
      - name: AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.MY_AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.MY_AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.aws_region }}
      # --- #
      - name: Build and push CONTAINER_NAME
        uses: ianbelcher/eks-kubectl-action@master
        with:
          cluster_name: ${{ secrets.CLUSTER_NAME }}
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
      # --- #
```

### Outputs

The action exports the following outputs:
- `kubectl-out`: The output of `kubectl`.

```yaml
jobs:
  jobName:
    name: Update deploy
    runs-on: ubuntu-latest 
    steps:
      # --- #
      - name: Build and push CONTAINER_NAME
        id: kubectl
        uses: ianbelcher/eks-kubectl-action@master
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: ${{ secrets.AWS_REGION }}
          cluster_name: ${{ secrets.CLUSTER_NAME }}
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
      # --- #
      - name: Use the output
        run: echo "{{ steps.kubectl.outputs.kubectl-out }}"
```
