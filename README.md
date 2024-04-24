# aws-eks-kubectl

Access your EKS cluster via `kubectl` in a Github Action. No fuss, no messing around with special
kubeconfigs, just ensure you have `eks:ListCluster` and `eks:DescribeCluster` rights on your
user.

## Example configuration

### Supplying AWS credentials
You can supply your AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, the region your cluster is in, and the cluster name.

```yaml
jobs:
  jobName:
    name: Update deploy
    runs-on: ubuntu-latest
    steps:
      - uses: pdeveltere/aws-eks-kubectl@v1
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: ${{ secrets.AWS_REGION }}
          cluster_name: ${{ secrets.CLUSTER_NAME }}
          eks_role_arn: ${{ secrets.EKS_ROLE_ARN }}
          kubernetes_version: v1.21.0
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
```

### Using the AWS credentials present on the environment
If credentials are already present on the environment you don't need to supply them.

```yaml
jobs:
  jobName:
    name: Update deploy
    runs-on: ubuntu-latest
    env:
      aws-access-key-id: ${{ secrets.MY_AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.MY_AWS_SECRET_ACCESS_KEY }}
      aws_region: eu-central-1
    steps:
      - uses: pdeveltere/aws-eks-kubectl@v1
        with:
          cluster_name: ${{ secrets.CLUSTER_NAME }}
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
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
      - uses: pdeveltere/aws-eks-kubectl@v1
        id: kubectl
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: ${{ secrets.AWS_REGION }}
          cluster_name: ${{ secrets.CLUSTER_NAME }}
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
      - name: Use the output
        run: echo "${{ steps.kubectl.outputs.kubectl-out }}"
```
