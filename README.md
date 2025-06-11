# Rumo à Procedência - Professional Landing Page

This project provides a professional infrastructure for hosting a static website on AWS, with automated deployment, manual approval, and alerting. The workflow is secure, auditable, and production-ready.

## Features
- **Static hosting** on S3 with versioning, lifecycle, and secure public policy.
- **Automated deploy** via GitHub Actions (GHA) using OIDC (no static secrets).
- **Manual approval** for production deploy.
- **Staging deploy** via GitHub Pages.
- **Email alerts** via configurable SNS.
- **Notifications and outputs**: Site URLs (S3 and GitHub Pages) shown in the GitHub Actions summary.
- **Images and files** can be uploaded manually to S3 without being overwritten by deploys.

## Project Structure
```
├── index.html / 404.html         # Static landing page
├── terraform/                    # Infrastructure as code
├── .github/workflows/
│   ├── gh-pages.yml              # Site deploy (GHA)
│   └── tf-config.yml             # Infrastructure pipeline (GHA)
```

## How Deploy Works

### 1. Infrastructure Deploy (Terraform)
- Pipeline: `.github/workflows/tf-config.yml`
- Runs on push/pull request to `main` branch.
- Provisions/updates AWS resources via Terraform.
- Important outputs (like S3 site URL) appear in the GitHub Actions summary.

**How to run manually:**
- Edit files in `terraform/` and push to `main`.
- Or run locally:
  ```sh
  cd terraform
  terraform init
  terraform apply
  ```

### 2. Site Deploy (Landing Page)
- Pipeline: `.github/workflows/gh-pages.yml`
- Runs via _workflow_dispatch_ (manual deploy from GitHub UI).
- **Steps:**
  1. Deploy to GitHub Pages (staging/dev)
  2. Manual approval (environment `production`)
  3. Deploy to S3 (production)
- The workflow summary shows links to the site in production (S3) and staging (GitHub Pages).

**How to run:**
- Go to _Actions_ > _Deploy Landing Page_ > _Run workflow_ and fill in the fields.
- Wait for manual approval to publish to production.

## Important Variables
- Set Terraform variables as repository variables in GitHub:
  - `TF_VAR_bucket_name` (S3 bucket name)
  - `TF_VAR_sns_email` (alert email)
  - `TF_VAR_region` (AWS region, e.g. sa-east-1)
- Secrets: `AWS_ACCOUNT_ID` (for OIDC assume role)

## Manual Upload of Files (images, etc)
- For files that should not be overwritten by deploys, upload them manually to a folder excluded from sync (e.g. `images/`).
- Use AWS CLI:
  ```sh
  aws s3 cp path/to/image.jpg s3://<bucket>/images/image.jpg --content-type image/jpeg
  ```
- Reference in HTML using the public S3 URL.

## Security
- Production deploy only after manual approval.
- Automated deploy via OIDC (no static secrets).
- S3 bucket is public only via policy, no ACLs.
- Sensitive variables are never versioned.

## Notes
- The public S3 site endpoint is: `http://<bucket>.s3-website-<region>.amazonaws.com`
- Deploy does not overwrite files in excluded folders (e.g. `images/`).
- The project is easily adaptable for custom domains and Cloudflare via Terraform.

---
