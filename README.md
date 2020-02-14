# eks-kubectl

Access your EKS cluster via `kubectl` in a Github Action. No fuss, no messing around with special
kubeconfigs, just ensure you have `eks:ListCluster` and `eks:DescribeCluster` rights on your
user.

See [this great blog post](https://prabhatsharma.in/blog/amazon-eks-iam-authentication-how-to-add-an-iam-user/)
for an overview if you're using a new IAM user.

## Example configuration

You just need to supply your AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, the region your cluster is
in and it's name

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
          args: set image --record deployment/pod-name pod-name=${{ steps.build.outputs.IMAGE_URL }}
      # --- #
```
