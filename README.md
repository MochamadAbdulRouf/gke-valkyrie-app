
1. Build the Image
```bash
docker build -t valkyrie-prod:v0.0.3 .
```

2. Test Launch container using the image with tag
```bash
docker run -d -p 8080:8080 valkyrie-prod:v0.0.3
```

Note: This is an efficient way to push Docker images to Artifact Registry.

3. Create repository in Artifact Registry.Use Docker format and use the `REGION` your region as the location

4. Before you can push or pull images, configure Docker to use the google cloud CLI to authenticate request to Artifact Registry (GCR).
```bash
gcloud auth configure-docker Region-docker.pkg.dev
```
example :
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

5. Retag the container to able push it to the repository, The format should resemble the following :
```bash
LOCATION-docker.pkg.dev/PROJECT-ID/REPOSITORY/IMAGE
```
example :
```bash
docker build -t us-central1-docker.pkg.dev/qwiklabs-gcp-01-dd6279f0b9c8/valkyrie-docker-repo/valkyrie-prod:v0.0.3 .
```

6. Push the Docker image to the Artifact Registry
```bash
docker push us-central1-docker.pkg.dev/qwiklabs-gcp-01-dd6279f0b9c8/valkyrie-docker-repo/valkyrie-prod:v0.0.3
```

7. Create and Expose a Deployment in Kubernetes, Get the Kubernetes credentials using ZONE(example: us-east-1) zone before you deploy the image onto the Kubernetes Cluster
```bash
gcloud container clusters get-credentials [your-cluster-name] --zone ZONE 
```
note: change the ZONE by adjusting your cluster location

8. Before you create deployments, Make sure you check and replace placeholder values in the `deployment.yaml` file and format should be `LOCATION-docker.pkg.dev/PROJECT-ID/REPOSITORY/IMAGE`

9. Create deployments from the `deployment.yaml` and `service.yaml` files 
```bash
kubectl create -f deployment.yaml
kubectl create -f service.yaml
```

10. From the Navigation Menu, Select Kubernetes Engine > Gateways, Services & Ingress.Click on the `load balancer IP Address` of the valkyrie-dev service to verify your services are up and running.